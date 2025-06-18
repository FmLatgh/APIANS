/obj/item/swearing_pass
    name = "swearing pass"
    desc = "Allows you to drop the F bomb once. Use again and you explode."
    icon = 'icons/obj/items_and_weapons.dmi'
    icon_state = "paper"
    var/used = FALSE

/obj/item/swearing_pass/attack_self(mob/user)
    if(!used)
        used = TRUE
        to_chat(user, span_notice("You feel empowered to drop the F bomb. Use this again and you will explode!"))
    else
        user.visible_message(span_danger("[user] explodes in a shower of gore for abusing the swearing pass!"))
        user.gib()
        qdel(src)
