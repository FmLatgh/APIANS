// Valentine's Day events //
// why are you playing spessmens on valentine's day you wizard //

//Assoc list
// Key: Sender
// Value: Receiever
GLOBAL_LIST(valentine_mobs)

// valentine / candy heart distribution //

/datum/round_event_control/valentines
	name = "Valentines!"
	holidayID = VALENTINES
	typepath = /datum/round_event/valentines
	weight = -1							//forces it to be called, regardless of weight
	max_occurrences = 1
	earliest_start = 0 MINUTES

/datum/round_event/valentines
	endWhen = 300 // 5 minutes

/datum/round_event/valentines/start()
	GLOB.valentine_mobs = list()
	//Blammo
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H.stat == DEAD || !H.mind || H.mind.has_antag_datum(/datum/antagonist/valentine))
			continue
		var/turf/T = get_turf(H)
		if(H.mind.assigned_role && SSjob.GetJob(H.mind.assigned_role)) // only give valentines to people who are actually eligible
			H.put_in_hands(new /obj/item/valentine(T))
			to_chat(H, span_clown("you feel a violent urge to write a heart-felt message to someone"))
		// everyone else gets chocolates and a heart
		var/b = locate(/obj/item/storage/backpack) in H.contents
		if(!b)
			b = T
		new /obj/item/food/candyheart(b)
		new /obj/item/storage/fancy/heart_box(b)

/datum/round_event/valentines/end()

	// Remove all the date candidates, anyone who got a mutual date now has the antag datum
	GLOB.valentine_mobs = null

	// Anyone who didn't get a date + silicons
	var/list/valentines = list()
	for(var/mob/living/M in GLOB.player_list)
		if(M.stat == DEAD || !M.mind || !M.mind.assigned_role || !SSjob.GetJob(M.mind.assigned_role) || M.mind.has_antag_datum(/datum/antagonist/valentine))
			continue
		if(!ishuman(M) && !issilicon(M)) // allow borgs!
			continue

		valentines += M

	while(valentines.len)
		var/mob/living/L = pick_n_take(valentines)
		if(valentines.len)
			var/mob/living/date = pick_n_take(valentines)

			forge_valentines_objective(L, date)
			forge_valentines_objective(date, L)
		else // Uh oh, you got left out!
			var/datum/antagonist/heartbreaker/D = new
			if(!D.is_banned(L))
				L.mind.add_antag_datum(D)
			else
				qdel(D)

/proc/forge_valentines_objective(mob/living/lover, mob/living/date)
	lover.mind.special_role = "valentine"
	var/datum/antagonist/valentine/V = new
	V.date = date.mind
	lover.mind.add_antag_datum(V) //These really should be teams but i can't be assed to incorporate third wheels right now

/datum/round_event/valentines/announce(fake)
	priority_announce("chat tis February 14th aint that crazy \
	you cant be going alone so losers will be assigned one.", sound = SSstation.announcer.get_rand_alert_sound())

/obj/item/valentine
	name = "valentine"
	desc = "A Valentine's card! Wonder what it says..."
	icon = 'icons/obj/toy.dmi'
	icon_state = "sc_Ace of Hearts_syndicate" // shut up
	var/message = "A generic message of love or whatever."
	resistance_flags = FLAMMABLE
	w_class = WEIGHT_CLASS_TINY
	var/mob/target = null
	var/mob/sender = null
	var/used = FALSE

/obj/item/valentine/Initialize(mapload)
	. = ..()
	message = pick(strings(VALENTINE_FILE, "valentines"))

/obj/item/valentine/proc/write_valentine(mob/user)
	if(!islist(GLOB.valentine_mobs))
		to_chat(user, span_warning("HOW DID YOU FORGET TO WRITE OMDS"))
		used = TRUE
		return
	if(used)
		return
	var/turf/user_turf = get_turf(user)
	if(!SSmobs.clients_by_zlevel[user_turf.z])
		to_chat(user, span_warning("this is what you get"))
		return
	//No going back now
	var/list/clients_on_level = SSmobs.clients_by_zlevel[user_turf.z]
	var/list/mob_names = list()
	for(var/mob/living/carbon/human/H in clients_on_level)
		if(H.stat == DEAD || !H.mind || !H.mind.assigned_role || !SSjob.GetJob(H.mind.assigned_role) || H.mind.has_antag_datum(/datum/antagonist/valentine))
			continue
		if(H == user)
			continue
		mob_names["[H.real_name]"] = H
	if(!LAZYLEN(mob_names))
		to_chat(user, span_warning("whelp... nobody likes u..."))
		return
	//Pick names
	var/picked_name = tgui_input_list(user, "VICTIM NAME", "Valentines Card", mob_names)
	var/mob/living/carbon/human/picked_human = mob_names[picked_name]
	if(!istype(picked_human))
		to_chat(user, span_notice("...But it refused."))
		return
	if(!islist(GLOB.valentine_mobs))
		to_chat(user, span_warning("wow ok did you forget to write the actual card smh smh"))
		used = TRUE
		return
	if(used)
		to_chat(user, span_warning("not yoyrs >:("))
		return
	to_chat(user, span_notice("Me: I hope they got this im sweating bullets right now"))
	// Assign our side of the date, if they picked us then create the objective
	GLOB.valentine_mobs[user] = picked_human
	if(GLOB.valentine_mobs[picked_human] == user)
		// they picked each other, so now they get to go on a date
		forge_valentines_objective(user, picked_human)
		forge_valentines_objective(picked_human, user)
	//Off it goes!
	//Create a new card to prevent exploiting
	var/obj/item/valentine/new_card = new(get_turf(picked_human))
	new_card.message = message
	new_card.sender = user
	new_card.target = picked_human
	new_card.name = "valentines card from [new_card.sender]"
	new_card.desc = "19 dolar valentine card. It is addressed to [new_card.target]."
	new_card.used = TRUE
	picked_human.equip_to_appropriate_slot(new_card)
	to_chat(picked_human, span_clown("WHAT"))
	qdel(src)

/obj/item/valentine/examine(mob/user)
	. = ..()
	if(in_range(user, src) || isobserver(user))
		user << browse(HTML_SKELETON_TITLE(name, message), "window=[name]")
		onclose(user, "[name]")
	else
		. += span_notice("It is too far away.")

/obj/item/valentine/attack_self(mob/user)
	if(!used)
		write_valentine(user)
		return
	user.examinate(src)

/obj/item/food/candyheart
	name = "candy heart"
	icon = 'icons/obj/holiday_misc.dmi'
	icon_state = "candyheart"
	desc = "A heart-shaped candy that reads: "
	food_reagents = list(/datum/reagent/consumable/sugar = 2)
	junkiness = 5

/obj/item/food/candyheart/Initialize(mapload)
	. = ..()
	desc = pick(strings(VALENTINE_FILE, "candyhearts"))
	icon_state = pick("candyheart", "candyheart2", "candyheart3", "candyheart4")
