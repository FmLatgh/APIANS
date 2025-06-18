/obj/effect/bubble
    name = "bubble"
    desc = "A shimmering floating bubble that violently pops when it hits something."
    icon = 'icons/effects/fields.dmi'
    icon_state = "projectile_dampen_effect"
    density = FALSE
    anchored = FALSE
    layer = ABOVE_MOB_LAYER
    mouse_opacity = 0
    var/moving = TRUE
    var/pop_power = 3 // How hard it throws mobs when popping

    New()
        ..()
        // Optional shimmer or init stuff

    proc/start_movement(direction)
        dir = direction
        moving = TRUE
        spawn(0)
            while(moving)
                var/turf/next = get_step(src, dir)
                if(!next || !isturf(next) || next.density)
                    violent_pop()
                    return
                step(src, dir)
                sleep(2)

    Bump(atom/A)
        violent_pop()

    proc/violent_pop()
        if(!moving) // Already popping
            return

        moving = FALSE
        visible_message(span_danger("The bubble violently pops!"))

        // Throw nearby mobs away
        for(var/mob/living/M in range(1, src))
            var/throw_dir = get_dir(src, M)
            var/turf/target = get_edge_target_turf(M, throw_dir)
            M.throw_at(target, pop_power, 1)
            to_chat(M, span_userdanger("You're thrown back by the bursting bubble!"))

        // Visual effect
        explosion(get_turf(src), 0, 0, 1, 1, TRUE, TRUE, 0, TRUE)
        qdel(src)
