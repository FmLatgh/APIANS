/datum/round_event_control/meteor_wave/major_dust
	name = "Major Space Dust"
	typepath = /datum/round_event/meteor_wave/major_dust
	weight = 8

/datum/round_event/meteor_wave/major_dust
	wave_name = "space dust"

/datum/round_event/meteor_wave/major_dust/announce(fake)
	var/reason = "*COUGH COUGH COUGH*"
	priority_announce(pick(reason), "When the dust comes settling in", SSstation.announcer.get_rand_alert_sound())
