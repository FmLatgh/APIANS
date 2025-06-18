/obj/item/swearing_pass
    name = "swearing pass"
    desc = "Allows you to drop the F bomb once while holding it. If you do it again, you explode."
    icon = 'icons/obj/items_and_weapons.dmi'
    icon_state = "nucleardisk"
    var/used = FALSE

/obj/item/swearing_pass/Initialize()
    . = ..()
    // Register signal for when the item is picked up
    RegisterSignal(src, COMSIG_ITEM_PICKUP, PROC_REF(on_pickup))
    RegisterSignal(src, COMSIG_ITEM_DROPPED, PROC_REF(on_drop))

/obj/item/swearing_pass/proc/on_pickup(mob/user)
    // Listen for speech while held
    RegisterSignal(user, COMSIG_MOB_SAY, PROC_REF(on_say))

/obj/item/swearing_pass/proc/on_drop(mob/user)
    // Stop listening for speech when dropped
    UnregisterSignal(user, COMSIG_MOB_SAY)

/obj/item/swearing_pass/Destroy()
    // Clean up signals
    for(var/mob/M in GLOB.mob_list)
        UnregisterSignal(M, COMSIG_MOB_SAY)
    return ..()

/obj/item/swearing_pass/proc/on_say(mob/user, message, ...)
    if(user.get_active_hand() != src)
        return
    if(findtext(lowertext(message), "fuck"))
        if(!used)
            used = TRUE
            to_chat(user, span_warning("You have used your one and only F bomb pass. Next time, you won't be so lucky!"))
        else
            user.visible_message(span_danger("[user] explodes in a shower of gore for excessive swearing!"))
            user.gib()
            qdel(src)
