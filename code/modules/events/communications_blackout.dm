/datum/round_event_control/communications_blackout
	name = "Communications Blackout"
	typepath = /datum/round_event/communications_blackout
	weight = 30

/datum/round_event/communications_blackout
	announceWhen	= 1

/datum/round_event/communications_blackout/announce(fake)
	var/alert = pick(	"\[PLEASE DEPOSIT 5 COINS]", \
						"\[PAY 1000 ARCHVALEN GOLD TO CONTINUE MAKING USE OF OUR SERVICES]", \
						"01101001 00100000 01101000 01100001 01110110 01100101 00100000 01101110 01101111 00100000 01101001 01100100 01100101 01100001 00100000 01110111 01101000 01111001 00100000 01111001 01101111 01110101 00100000 01101100 01101111 01101111 01101011 01100101 01100100 00100000 01110100 01101000 01101001 01110011 00100000 01101111 01101110 01100101 00100000 01110101 01110000", \
						"!!!!!!!!!!!!!@@@@@@@#######################", \
						"freddy is coming", \
						"shhh... be quiet.")

	for(var/mob/living/silicon/ai/A as anything in GLOB.ai_list)	//AIs are always aware of communication blackouts.
		to_chat(A, "<br>[span_warning("<b>[alert]</b>")]<br>")

	if(prob(30) || fake)	//most of the time, we don't want an announcement, so as to allow AIs to fake blackouts.
		priority_announce(alert, sound = SSstation.announcer.get_rand_alert_sound())


/datum/round_event/communications_blackout/start()
	for(var/obj/machinery/telecwomms/T in GLOB.telecomms_list)
		T.emp_act(EMP_HEAVY)
