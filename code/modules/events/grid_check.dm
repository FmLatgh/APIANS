/datum/round_event_control/grid_check
	name = "Grid Check"
	typepath = /datum/round_event/grid_check
	weight = 10
	max_occurrences = 3

/datum/round_event/grid_check
	announceWhen	= 1
	startWhen = 1

/datum/round_event/grid_check/announce(fake)
	priority_announce("Something evil will happen to your power grid", "United States of Galentopia", ANNOUNCER_POWEROFF)

/datum/round_event/grid_check/start()
	power_fail(30, 120)
