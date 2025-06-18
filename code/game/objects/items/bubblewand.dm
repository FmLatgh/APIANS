/obj/item/bubblewand
    icon_state = "hypertool"
    lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
    righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
    icon = 'icons/obj/device.dmi'
    name = "bubble wand"
    desc = "A bubble wand that creates bubbles which trap things inside them."
    w_class = WEIGHT_CLASS_TINY
    var/uses = 10

    afterattack(atom/target, mob/user, proximity_flag, click_parameters)
        if(!target || target == user || !isturf(user.loc) || uses <= 0)
            return

        uses--
        var/obj/effect/bubble/B = new(get_turf(user))

        // Use click direction if available, fallback to get_dir
        var/direction = (isnum(click_parameters["icon-x"]) && isnum(click_parameters["icon-y"])) \
            ? get_dir(user, locate(user.x + (click_parameters["icon-x"] - 16) / 16, user.y + (click_parameters["icon-y"] - 16) / 16, user.z)) \
            : get_dir(user, target)
        B.start_movement(direction)

        to_chat(user, span_notice("You blow a shimmering bubble toward [target]!"))
        user.visible_message(span_notice("[user] blows a shimmering bubble toward [target]."), user)

        if(uses <= 0)
            to_chat(user, span_warning("The bubble wand has run out of uses!"))
            qdel(src)
        else
            to_chat(user, span_notice("The bubble wand has [uses] uses left."))

    // Allow user to refill using bars of soap
    proc/refill(mob/user)
        if(uses >= 10)
            to_chat(user, span_warning("The bubble wand is already full!"))
            return

        if(istype(loc, /mob))
            to_chat(user, span_warning("You need to drop the bubble wand first!"))
            return

        var/obj/item/soap/S = locate(/obj/item/soap) in user
        if(!S)
            to_chat(user, span_warning("You need a bar of soap to refill the bubble wand!"))
            return

        uses = min(10, uses + S.use(1))
        to_chat(user, span_notice("You refill the bubble wand with soap. It now has [uses] uses left."))
