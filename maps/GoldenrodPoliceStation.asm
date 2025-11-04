
	object_const_def
	const GOLDENRODPOLICESTATION_COP1
	const GOLDENRODPOLICESTATION_COP2
	const GOLDENRODPOLICESTATION_COP3
	const GOLDENRODPOLICESTATION_COP4
	const GOLDENRODPOLICESTATION_CHIEF
	const GOLDENRODPOLICESTATION_PHARMACIST
	const GOLDENRODPOLICESTATION_ROCKET
	
	GoldenrodPoliceStation_MapScripts:
	def_scene_scripts
	
	def_callbacks

GoldenrodPoliceStationCop1Script:
	faceplayer
	opentext
	writetext GoldenrodPoliceStationCop1Text
	waitbutton
	closetext
	turnobject GOLDENRODPOLICESTATION_COP1, UP
	end

GoldenrodPoliceStationCop2Script:
	faceplayer
	opentext
	writetext GoldenrodPoliceStationCop2Text
	waitbutton
	closetext
	turnobject GOLDENRODPOLICESTATION_COP2, UP
	end

GoldenrodPoliceStationCop3Script:
	faceplayer
	opentext
	writetext GoldenrodPoliceStationCop3Text
	waitbutton
	closetext
	turnobject GOLDENRODPOLICESTATION_COP3, UP
	end

GoldenrodPoliceStationCop4Script:
	faceplayer
	opentext
	writetext GoldenrodPoliceStationCop4Text
	waitbutton
	closetext
	turnobject GOLDENRODPOLICESTATION_COP4, UP
	end

GoldenrodPoliceStationChiefScript:
	faceplayer
	opentext
	writetext GoldenrodPoliceStationChiefText
	waitbutton
	closetext
	turnobject GOLDENRODPOLICESTATION_CHIEF, UP
	end
	
GoldenrodPoliceStationCriminalScript:

GoldenrodPoliceStationRocketScript:

RocketTalkScript:
	opentext
	writetext RocketTalkText
	waitbutton
	closetext
	end
	
BurglarTalkScript:
	opentext
	writetext BurglarTalkText
	waitbutton
	closetext
	end

GoldenrodPoliceStationCop1Text:
	text "Hey kid! Do NOT"
	line "ever steal from"
	cont "people!"
	
	para "You will end up"
	line "like these crim-"
	cont "inals in these"
	cont "jail cells!"
	done

GoldenrodPoliceStationCop2Text:
	text "Even though the"
	line "POLICE STATION"
	cont "might seem small,"
	
	para "we actually have a"
	line "pretty big roster"
	cont "of POLICE around"
	cont "the JOHTO region!"
	done

GoldenrodPoliceStationCop3Text:
	text "This BURGLAR right"
	line "here stole multi-"
	cont "ple items from a"
	cont "store in VIOLET"
	cont "CITY."
	
	para "I had to take this"
	line "thief the longer"
	cont "way back to GOLD-"
	cont "ENROD."
	
	para "The guy wouldn't"
	line "stop crying and"
	cont "complaining. Ugh.."
	done

GoldenrodPoliceStationCop4Text:
	text "After the SLOWPOKE"
	line "WELL incident, we"
	cont "found this ROCKET"
	cont "member lost in the"
	cont "ILEX FOREST."
	
	para "Idiot should have"
	line "never got lost"
	cont "from his crew. Ha!"
	done

GoldenrodPoliceStationChiefText:
	text "I am the Chief of"
	line "this POLICE STAT-"
	cont "ION."
	
	para "You must be <PLAYER>."
	line "A pleasure to meet"
	cont "you."
	
	para "I'm an acquaintance"
	line "of PROF. ELM's."
	
	para "He called me per-"
	line "sonally about this"
	cont "thief SILVER."
	
	para "We're doing what we"
	line "can to find him."
	
	para "He's a slippery"
	line "one."
	
	para "You find him again,"
	line "you have my FULL"
	cont "permission to stop"
	cont "him."
	
	para "At ALL Costs!"
	done

RocketTalkText:
	text "Hmph. The POLICE"
	line "might have caught"
	cont "me this time."
	
	para "But I know my TEAM"
	line "will come and get"
	cont "me! Just you wait!"
	
	para "OFFICER: Yeah,"
	line "Yeah!"
	
	para "Keep talking cri-"
	line "minal!!"
	
	para "Where your buddies"
	line "at now??"
	
	para "ROCKET: ..."
	
	para "Oh ok, that's what"
	line "I thought!"
	
	para "ROCKET: Tch."
	done

BurglarTalkText:
	text "BURGLAR: Man..."
	line "This blows..."
	
	para "I wish I had never"
	line "stole in the first"
	cont "place."
	
	para "Officer, is there"
	line "any way you can"
	cont "let me out?"
	
	para "PLEEEEASE."
	
	para "OFFICER: ...."
	
	para "BURGLAR: SIGH..."
	done

GoldenrodPoliceStation_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  4, 11, GOLDENROD_CITY, 15
	warp_event  5, 11, GOLDENROD_CITY, 15

	def_coord_events

	def_bg_events
	bg_event 9, 3, BGEVENT_READ, RocketTalkScript
	bg_event 0, 3, BGEVENT_READ, BurglarTalkScript
	
	def_object_events
	object_event 2, 9, SPRITE_OFFICER, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, GoldenrodPoliceStationCop1Script, -1
	object_event 6, 9, SPRITE_OFFICER, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, GoldenrodPoliceStationCop2Script, -1
	object_event 2, 5, SPRITE_OFFICER, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, GoldenrodPoliceStationCop3Script, -1
	object_event 6, 5, SPRITE_OFFICER, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, GoldenrodPoliceStationCop4Script, -1
	object_event 4, 3, SPRITE_OFFICER, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_PURPLE, OBJECTTYPE_SCRIPT, 0, GoldenrodPoliceStationChiefScript, -1
	object_event 0, 2, SPRITE_PHARMACIST, SPRITEMOVEDATA_STANDING_DOWN,  0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, GoldenrodPoliceStationCriminalScript, -1
	object_event 9, 2, SPRITE_ROCKET, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, GoldenrodPoliceStationRocketScript, -1
	