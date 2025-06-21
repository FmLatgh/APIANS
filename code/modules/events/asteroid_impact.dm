
/datum/round_event_control/asteroid_impact
	name = "Asteroid Impact (End Round)"
	typepath = /datum/round_event/asteroid_impact
	weight = -1
	max_occurrences = 0

/datum/round_event/asteroid_impact
	//Should be enough time to escape.
	startWhen = 260
	announceWhen = 1

/datum/round_event/asteroid_impact/announce(fake)
	priority_announce("did you know? apple pie is a very hard roblox game. i uhhhhhh hey chat is that a meteor comin guiour wey", SSstation.announcer.get_rand_alert_sound())
	if(!fake)
		SSsecurity_level.set_level(SEC_LEVEL_DELTA)
		var/area/A = GLOB.areas_by_type[/area/centcom]
		if(EMERGENCY_IDLE_OR_RECALLED)
			SSshuttle.emergency.request(null, A, "Automatic Shuttle Call: WE FUCKED UP", TRUE)
		else
			if(SSshuttle.emergency.timer > world.time + 5 MINUTES)
				SSshuttle.emergency.setTimer(5 MINUTES)

/datum/round_event/asteroid_impact/start()
	for(var/mob/living/M in GLOB.mob_list)
		if(is_station_level(M.z) && !QDELETED(M))
			explosion(M, 3, 4, 6, 0, FALSE)
			qdel(M)
			CHECK_TICK
