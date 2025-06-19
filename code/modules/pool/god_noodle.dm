/obj/item/pool/god_noodle
    icon = 'icons/obj/pool.dmi'
    icon_state = "pool_noodle"
    lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
    righthand_file = 'icons/mob/inhands/items_righthand.dmi'
    name = "god noodle"
    desc = "39 buried. 0 found. \"ahelp he grief me\""
    w_class = WEIGHT_CLASS_GIGANTIC
    force = 300
    damtype = BRUTE
    throwforce = 999
    throw_range = 20
    attack_verb_continuous = list("obliterates", "finishes off", "bans", "annihilates", "smites")
    attack_verb_simple = list("obliterate", "finish off", "ban", "annihilate", "smite")
    resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
    light_range = 7
    light_power = 3
    light_color = "#FF0000"
    var/suiciding = FALSE
    var/knockback_force = 1000
    var/cooldown_time = 10
    var/cooldown = 0

/obj/item/pool/god_noodle/Initialize()
    . = ..()
    AddComponent(/datum/component/two_handed, TRUE)
/obj/item/pool/god_noodle/attack(mob/living/target, mob/living/user)
    if(world.time < src.cooldown)
        return
    src.cooldown = world.time + src.cooldown_time

    playsound(src, 'sound/effects/explosion_distant.ogg', 200, TRUE)
    playsound(src, 'sound/magic/clockwork/ratvar_attack.ogg', 150, TRUE)

    new /obj/effect/temp_visual/cleave(target.loc)
    addtimer(CALLBACK(GLOBAL_PROC, PROC_REF(qdel), target), 50) // 5 seconds

    var/throw_dir = get_dir(user, target)
    var/throw_target = get_edge_target_turf(target, throw_dir)
    target.throw_at(throw_target, 30, 4, TRUE)

    target.adjustBruteLoss(src.force)
    target.Paralyze(100) // 10 seconds

    message_admins("[key_name_admin(user)] has SMITED [key_name_admin(target)] with the GOD NOODLE at [AREACOORD(target)]")

    return ..()

/obj/item/pool/god_noodle/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
    if(ismob(hit_atom))
        var/mob/M = hit_atom
        M.gib()
    new /obj/effect/temp_visual/explosion(get_turf(hit_atom))
    return ..()

/obj/item/pool/god_noodle/suicide_act(mob/user)
    if(suiciding)
        return
    suiciding = TRUE
    user.visible_message(span_suicide("[user] attempts to invoke divine judgment with [src]! The gods frown upon this heresy..."))
    playsound(src, 'sound/magic/disintegrate.ogg', 200, TRUE)
    addtimer(CALLBACK(src, PROC_REF(divine_retribution), user), 3 SECONDS)
    return MANUAL_SUICIDE

/obj/item/pool/god_noodle/proc/divine_retribution(mob/user)
    if(!user)
        return
    user.visible_message(span_danger("The heavens open up and smite [user] for their hubris!"))
    explosion(user, devastation_range = 5, heavy_impact_range = 10, light_impact_range = 20, flash_range = 30)
    user.gib()

/obj/item/pool/god_noodle/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
    if(!proximity_flag && istype(target, /turf))
        user.visible_message(span_danger("[user] raises [src] to the sky, calling down divine wrath!"))
        playsound(src, 'sound/magic/lightning_chargeup.ogg', 100, TRUE)
        addtimer(CALLBACK(src, PROC_REF(lightning_strike), get_turf(target), user), 2 SECONDS)

/obj/item/pool/god_noodle/proc/lightning_strike(turf/T, mob/user)
    if(!T)
        return
    playsound(T, 'sound/magic/lightningbolt.ogg', 200, TRUE)
    tesla_zap(T, 10, 10000, TESLA_MOB_DAMAGE | TESLA_OBJ_DAMAGE | TESLA_MOB_STUN)
    // Removed undefined /obj/effect/temp_visual/beam
    // Optionally, use an existing effect or leave this out

/obj/effect/temp_visual/cleave
    name = "divine cleave"
    desc = "You don't know what you're seeing!"
    icon = 'icons/effects/96x96.dmi'
    icon_state = "judicial_explosion"
    duration = 10
    pixel_x = -32
    pixel_y = -32
