/obj/item/swearing_pass
    name = "swearing pass"
    desc = "Allows you to drop the F bomb once while holding it. If you do it again, you explode."
    icon = 'icons/obj/items_and_weapons.dmi'
    icon_state = "nucleardisk"
    var/used = FALSE

/obj/item/swearing_pass/Initialize(mapload)
    . = ..()
    // Register signal for when the item is picked up
    RegisterSignal(src, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equip))
    RegisterSignal(src, COMSIG_ITEM_DROPPED, PROC_REF(on_drop))

/obj/item/swearing_pass/proc/on_equip(datum/source, mob/equipper, slot)
    if(!(slot & ITEM_SLOT_HANDS)) // Only care about hand slots
        return
    // Listen for speech while held
    RegisterSignal(equipper, COMSIG_MOB_SAY, PROC_REF(on_say))

/obj/item/swearing_pass/proc/on_drop(datum/source, mob/user)
    // Stop listening for speech when dropped
    UnregisterSignal(user, COMSIG_MOB_SAY)

/obj/item/swearing_pass/Destroy()
    // Clean up signals
    for(var/mob/M in GLOB.player_list) // More efficient than mob_list
        UnregisterSignal(M, COMSIG_MOB_SAY)
    return ..()

/obj/item/swearing_pass/proc/on_say(mob/user, list/speech_args)
    if(user.get_active_held_item() != src && user.get_inactive_held_item() != src)
        return

    var/message = lowertext(speech_args[SPEECH_MESSAGE])
    // Remove punctuation at the end
    message = replacetext(message, ".", "")
    message = replacetext(message, "!", "")
    message = replacetext(message, "?", "")
    message = trim(message)

    if(message == "fuck")
        if(!used)
            used = TRUE
            to_chat(user, span_warning("You have used your one and only F bomb pass. Next time, you won't be so lucky!"))
        else
            user.visible_message(span_danger("[user] explodes in a shower of gore for excessive swearing!"))
            user.gib()
            qdel(src)
