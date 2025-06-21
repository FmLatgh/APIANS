/datum/round_event_control/processor_overload
	name = "Processor Overload"
	typepath = /datum/round_event/processor_overload
	weight = 15
	min_players = 20

/datum/round_event/processor_overload
	announceWhen	= 1

/datum/round_event/processor_overload/announce(fake)
	var/alert = pick(	"we're waiting every night", \
						"to finally roam and invite", \
						"newcomers to play with us", \
						"for many years we've been all alone", \
						"we're be forced to be still and play", \
						"the same songs we know since that day", \
						"an imposter took our life away", \
						"now we're stuck here to decay", \
						"please let us get in, don't lock us away", \
						"we're not like what you're thinking", \
						"we are poor little souls, who lost all control", \
						"and we're forced here to take that role", \
						"we've been all alone, stuck in our little zone", \
						"since 1987", \
						"join us, be our friend, or just be stuck and defend", \
						"after all you only got five nights at freddy's")

	for(var/mob/living/silicon/ai/A as anything in GLOB.ai_list)
	//AIs are always aware of processor overload
		to_chat(A, "<br>[span_warning("<b>[alert]</b>")]<br>")

	// Announce most of the time, but leave a little gap so people don't know
	// whether it's, say, a tesla zapping tcomms, or some selective
	// modification of the tcomms bus
	if(prob(80) || fake)
		priority_announce(alert, sound = SSstation.announcer.get_rand_alert_sound())


/datum/round_event/processor_overload/start()
	for(var/obj/machinery/telecomms/processor/P in GLOB.telecomms_list)
		if(prob(10))
			announce_to_ghosts(P)
			// Damage the surrounding area to indicate that it popped
			explosion(get_turf(P), 0, 0, 2)
			// Only a level 1 explosion actually damages the machine
			// at all
			SSexplosions.high_mov_atom += P
		else
			P.emp_act(EMP_HEAVY)
