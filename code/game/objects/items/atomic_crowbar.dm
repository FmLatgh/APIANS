/obj/item/crowbar/atomic
	name = "atomic crowbar"
	desc = "A crowbar imbued with strange dimensional energies. It hums with barely-contained power."
	icon = 'icons/obj/tools.dmi'
	icon_state = "crowbar"
	force = 15
	throwforce = 20
	w_class = WEIGHT_CLASS_NORMAL
	toolspeed = 0.3
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	light_range = 3
	light_power = 2
	light_color = "#00ffff"
	var/cooldown_time = 300 // 30 seconds
	var/cooldown = 0
	var/invisibility_duration = 150 // 15 seconds

/obj/item/crowbar/atomic/Initialize()
	. = ..()
	AddComponent(/datum/component/effect_remover, \
		success_feedback = "You destabilize the anomaly with %THEWEAPON.", \
		tip_text = "Destabilize anomalies", \
		on_clear_callback = CALLBACK(src, PROC_REF(on_anomaly_cleared)))

/obj/item/crowbar/atomic/proc/on_anomaly_cleared(obj/effect/anomaly/A)
	playsound(src, 'sound/effects/empulse.ogg', 100, TRUE)
	do_sparks(5, TRUE, A.loc)
	qdel(A)

/obj/item/crowbar/atomic/attack_self(mob/user)
	if(world.time < cooldown)
		to_chat(user, span_warning("The crowbar is still recharging!"))
		return

	var/list/options = list(
		"Rift Tear" = image(icon = 'icons/effects/effects.dmi', icon_state = "bhole3"),
		"Door Breach" = image(icon = 'icons/obj/structures.dmi', icon_state = "door_airlock"),
		"Dimensional Phase" = image(icon = 'icons/effects/effects.dmi', icon_state = "static_base")
	)

	var/choice = show_radial_menu(user, user, options, require_near = TRUE)
	if(!choice || world.time < cooldown)
		return

	cooldown = world.time + cooldown_time

	switch(choice)
		if("Rift Tear")
			create_rift(user)
		if("Door Breach")
			breach_door(user)
		if("Dimensional Phase")
			phase_shift(user)

/obj/item/crowbar/atomic/proc/create_rift(mob/user)
	user.visible_message(span_danger("[user] tears a hole in reality with [src]!"), span_notice("You focus the crowbar's energy and create a dimensional rift."))

	var/turf/T = get_turf(user)
	playsound(T, 'sound/effects/supermatter.ogg', 100, TRUE)
	new /obj/effect/temp_visual/rift(T)

	var/list/possible_destinations = list()
	for(var/turf/open/floor/F in world) // Changed from turf/simulated/floor to turf/open/floor
		if(!is_station_level(F.z) || F.density)
			continue
		possible_destinations += F

	if(possible_destinations.len)
		var/turf/destination = pick(possible_destinations)
		new /obj/effect/portal(T, destination, 100)
		do_sparks(5, TRUE, T)

/obj/item/crowbar/atomic/proc/breach_door(mob/user)
	var/turf/T = get_turf(user)
	playsound(T, 'sound/effects/explosionfar.ogg', 100, TRUE)
	user.visible_message(span_danger("[user] slams [src] into the ground, causing a shockwave!"), span_notice("You release a concussive blast that shatters nearby barriers."))

	for(var/obj/machinery/door/D in range(5, T))
		if(D.density)
			D.open(force=TRUE)
			D.ex_act(EXPLODE_HEAVY)

	for(var/mob/living/M in range(3, T))
		if(M == user)
			continue
		M.Knockdown(40)
		to_chat(M, span_userdanger("The shockwave knocks you off your feet!"))

/obj/item/crowbar/atomic/proc/phase_shift(mob/user)
	user.visible_message(span_warning("[user] fades out of existence!"), span_notice("You slip into a pocket dimension, becoming invisible to normal sight."))
	user.alpha = 0
	user.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	user.set_light(0)

	addtimer(CALLBACK(src, PROC_REF(end_phase_shift), user), invisibility_duration)

/obj/item/crowbar/atomic/proc/end_phase_shift(mob/user)
	if(!user)
		return
	user.alpha = initial(user.alpha)
	user.mouse_opacity = initial(user.mouse_opacity)
	user.set_light(initial(user.light_range), initial(user.light_power), initial(user.light_color))
	to_chat(user, span_warning("You return from the pocket dimension."))
	playsound(user, 'sound/effects/phasein.ogg', 50, TRUE)

/obj/item/crowbar/atomic/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(!proximity_flag || !isliving(user) || user.incapacitated())
		return ..()

	if(istype(target, /obj/machinery/door))
		var/obj/machinery/door/D = target
		if(D.density)
			playsound(src, 'sound/effects/explosion1.ogg', 100, TRUE)
			D.open(force=TRUE)
			D.ex_act(EXPLODE_HEAVY)
			user.visible_message(span_danger("[user] violently pries open [D] with [src]!"), span_notice("You unleash the crowbar's energy to force [D] open."))
			return

	return ..()

/obj/effect/temp_visual/rift
	name = "dimensional rift"
	desc = "A tear in the fabric of reality."
	icon = 'icons/effects/effects.dmi'
	icon_state = "bhole3"
	duration = 100
	light_range = 3
	light_power = 2
	light_color = "#ff00ff"
