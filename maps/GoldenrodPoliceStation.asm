
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

GoldenrodPoliceStationCop2Script:
	faceplayer
	opentext
	writetext GoldenrodPoliceStationCop2Text
	waitbutton
	closetext
	turnobject GOLDENRODPOLICESTATION_COP2, UP


GoldenrodPoliceStationCop3Script:
	faceplayer
	opentext
	writetext GoldenrodPoliceStationCop3Text
	waitbutton
	closetext
	turnobject GOLDENRODPOLICESTATION_COP3, UP


GoldenrodPoliceStationCop4Script:
	faceplayer
	opentext
	writetext GoldenrodPoliceStationCop4Text
	waitbutton
	closetext
	turnobject GOLDENRODPOLICESTATION_COP4, UP


GoldenrodPoliceStationChiefScript:
	faceplayer
	opentext
	writetext GoldenrodPoliceStationChiefText
	waitbutton
	closetext
	turnobject GOLDENRODPOLICESTATION_CHIEF, UP
	
GoldenrodPoliceStationCriminalScript:

GoldenrodPoliceStationRocketScript:

RocketTalkScript:
	opentext
	writetext RocketTalkText
	waitbutton
	closetext

BurglarTalkScript:
	opentext
	writetext BurglarTalkText
	waitbutton
	closetext

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
	line "here stole multiple"
	cont "items from a store"
	cont "in VIOLET CITY."
	
	para "I had to take this"
	line "thief the longer"
	cont "back to GOLDENROD."
	
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
	line "never got lost from"
	cont "his crew. Ha!"
	done

GoldenrodPoliceStationChiefText:
	text "I am the Chief of"
	line "this POLICE STATION."
	
	para "You must be <PLAYER>."
	line "A pleasure to meet you."
	
	para "I'm an acquaintance"
	line "of PROF. ELM's."
	
	para "He contacted me person-"
	line "ally about the SILVER"
	cont "thief."
	
	para "We're doing what we"
	line "can to find him."
	
	para "He's a slippery one."
	
	para "If you see him again,"
	line "you have my FULL per-"
	cont "mission to stop him"
	cont "at ALL costs."
	done

RocketTalkText:
	text "Hmph. The POLICE"
	line "might have caught me"
	
	para "but I know my TEAM"
	line "will come and rescue"
	cont "me! Just you wait!"
	
	para "OFFICER: Yeah, yeah!"
	line "Keep talking criminal!"
	
	para "Where your buddies at"
	line "now??"
	
	para "..."
	
	para "Oh ok, that's what I"
	line "thought."
	
	para "ROCKET: Tch."
	done

BurglarTalkText:
	text "BURGLAR: Man.. This"
	line "blows..."
	
	para "I wish I had never"
	line "stole in the first"
	cont "place."
	
	para "Officer, is there"
	line "any way you can"
	cont "let me out? PLEAASE."
	
	para "OFFICER: ...."
	
	para "BURGLAR: SIGH..."
	done

GoldenrodPoliceStation_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  4, 11, GOLDENROD_CITY, 8
	warp_event  5, 11, GOLDENROD_CITY, 8

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
	