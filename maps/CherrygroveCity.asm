	object_const_def
	const CHERRYGROVECITY_GRAMPS
	const CHERRYGROVECITY_RIVAL
	const CHERRYGROVECITY_TEACHER
	const CHERRYGROVECITY_YOUNGSTER
	const CHERRYGROVECITY_FISHER

CherrygroveCity_MapScripts:
	def_scene_scripts
	scene_script CherrygroveCityNoop1Scene, SCENE_CHERRYGROVECITY_NOOP
	scene_script CherrygroveCityNoop2Scene, SCENE_CHERRYGROVECITY_MEET_RIVAL

	def_callbacks
	callback MAPCALLBACK_NEWMAP, CherrygroveCityFlypointCallback

CherrygroveCityNoop1Scene:
	end

CherrygroveCityNoop2Scene:
	end

CherrygroveCityFlypointCallback:
	setflag ENGINE_FLYPOINT_CHERRYGROVE
	endcallback

CherrygroveCityGuideGent:
       faceplayer
       turnobject PLAYER, UP
       turnobject CHERRYGROVECITY_GRAMPS, DOWN
       sjump CherrygroveCityGuideGentGiveMap

CherrygroveCityGuideGentTrigger:
       checkflag ENGINE_MAP_CARD
       iftrue .Done
       turnobject PLAYER, UP
       turnobject CHERRYGROVECITY_GRAMPS, DOWN
       sjump CherrygroveCityGuideGentGiveMap

.Done:
       end

CherrygroveCityGuideGentGiveMap:
       opentext
       writetext GuideGentMapFirstText
       promptbutton
       getstring STRING_BUFFER_4, .mapcardname
       scall .JumpstdReceiveItem
       setflag ENGINE_MAP_CARD
       writetext GotMapCardText
       promptbutton
       writetext GuideGentOfferTourText
       yesorno
       iffalse .Decline
       writetext GuideGentTourText1
       waitbutton
       closetext
       playmusic MUSIC_SHOW_ME_AROUND
       follow CHERRYGROVECITY_GRAMPS, PLAYER
       applymovement CHERRYGROVECITY_GRAMPS, GuideGentMovement1
       opentext
       writetext GuideGentPokecenterText
       waitbutton
       closetext
       applymovement CHERRYGROVECITY_GRAMPS, GuideGentMovement2
       turnobject PLAYER, UP
       opentext
       writetext GuideGentMartText
       waitbutton
       closetext
       applymovement CHERRYGROVECITY_GRAMPS, GuideGentMovement3
       turnobject PLAYER, UP
       opentext
       writetext GuideGentRoute30Text
       waitbutton
       closetext
       applymovement CHERRYGROVECITY_GRAMPS, GuideGentMovement4
       turnobject PLAYER, LEFT
       opentext
       writetext GuideGentSeaText
       waitbutton
       closetext
       applymovement CHERRYGROVECITY_GRAMPS, GuideGentMovement5
       turnobject PLAYER, UP
       pause 60
       turnobject CHERRYGROVECITY_GRAMPS, LEFT
       turnobject PLAYER, RIGHT
       opentext
       writetext GuideGentHouseText
       promptbutton
       writetext GuideGentPokegearText
       waitbutton
       closetext
       stopfollow
       special RestartMapMusic
       turnobject PLAYER, UP
       applymovement CHERRYGROVECITY_GRAMPS, GuideGentMovement6
       playsound SFX_ENTER_DOOR
       disappear CHERRYGROVECITY_GRAMPS
       clearevent EVENT_GUIDE_GENT_VISIBLE_IN_CHERRYGROVE
       waitsfx
       end

.Decline:
       writetext GuideGentDeclineText
       waitbutton
       closetext
       applymovement CHERRYGROVECITY_GRAMPS, GuideGentMovement1
       applymovement CHERRYGROVECITY_GRAMPS, GuideGentMovement2
       applymovement CHERRYGROVECITY_GRAMPS, GuideGentMovement3
       applymovement CHERRYGROVECITY_GRAMPS, GuideGentMovement4
       applymovement CHERRYGROVECITY_GRAMPS, GuideGentMovement5
       applymovement CHERRYGROVECITY_GRAMPS, GuideGentMovement6
       playsound SFX_ENTER_DOOR
       disappear CHERRYGROVECITY_GRAMPS
       clearevent EVENT_GUIDE_GENT_VISIBLE_IN_CHERRYGROVE
       waitsfx
       end

.JumpstdReceiveItem:
       jumpstd ReceiveItemScript
       end

.mapcardname
       db "MAP CARD@"

CherrygroveRivalSceneSouth:
	applymovement PLAYER, CherrygroveCity_RivalMeetPoint
CherrygroveRivalSceneNorth:
	turnobject PLAYER, RIGHT
	showemote EMOTE_SHOCK, PLAYER, 15
	special FadeOutMusic
	pause 15
	appear CHERRYGROVECITY_RIVAL
	applymovement CHERRYGROVECITY_RIVAL, CherrygroveCity_RivalWalksToYou
	turnobject PLAYER, RIGHT
	playmusic MUSIC_RIVAL_ENCOUNTER
	opentext
	writetext CherrygroveRivalText_Seen
	waitbutton
	closetext
	checkevent EVENT_GOT_TOTODILE_FROM_ELM
	iftrue .Totodile
	checkevent EVENT_GOT_CHIKORITA_FROM_ELM
	iftrue .Chikorita
	winlosstext RivalCherrygroveWinText, RivalCherrygroveLossText
	setlasttalked CHERRYGROVECITY_RIVAL
	loadtrainer RIVAL1, RIVAL1_1_TOTODILE
	loadvar VAR_BATTLETYPE, BATTLETYPE_CANLOSE
	startbattle
	dontrestartmapmusic
	reloadmap
	iffalse .AfterVictorious
	sjump .AfterYourDefeat

.Totodile:
	winlosstext RivalCherrygroveWinText, RivalCherrygroveLossText
	setlasttalked CHERRYGROVECITY_RIVAL
	loadtrainer RIVAL1, RIVAL1_1_CHIKORITA
	loadvar VAR_BATTLETYPE, BATTLETYPE_CANLOSE
	startbattle
	dontrestartmapmusic
	reloadmap
	iffalse .AfterVictorious
	sjump .AfterYourDefeat

.Chikorita:
	winlosstext RivalCherrygroveWinText, RivalCherrygroveLossText
	setlasttalked CHERRYGROVECITY_RIVAL
	loadtrainer RIVAL1, RIVAL1_1_CYNDAQUIL
	loadvar VAR_BATTLETYPE, BATTLETYPE_CANLOSE
	startbattle
	dontrestartmapmusic
	reloadmap
	iffalse .AfterVictorious
	sjump .AfterYourDefeat

.AfterVictorious:
	playmusic MUSIC_RIVAL_AFTER
	opentext
	writetext CherrygroveRivalText_YouWon
	waitbutton
	closetext
	sjump .FinishRival

.AfterYourDefeat:
	playmusic MUSIC_RIVAL_AFTER
	opentext
	writetext CherrygroveRivalText_YouLost
	waitbutton
	closetext
.FinishRival:
	playsound SFX_TACKLE
	applymovement PLAYER, CherrygroveCity_RivalPushesYouOutOfTheWay
	turnobject PLAYER, LEFT
	applymovement CHERRYGROVECITY_RIVAL, CherrygroveCity_RivalExitsStageLeft1
	pause 20
	showemote EMOTE_SHOCK, CHERRYGROVECITY_RIVAL, 30
	applymovement CHERRYGROVECITY_RIVAL, CherrygroveCity_RivalLooksforID
	turnobject CHERRYGROVECITY_RIVAL, RIGHT
	showemote EMOTE_SHOCK, CHERRYGROVECITY_RIVAL, 30
	follow PLAYER, CHERRYGROVECITY_RIVAL
	applymovement CHERRYGROVECITY_RIVAL, CherrygroveCity_RivalWalksBackToYou
	opentext
	writetext CherrygroveRivalText_MyTrainerCard
	waitbutton
	closetext
	applymovement PLAYER, CherrygroveCity_RivalTakesIDBack
	turnobject CHERRYGROVECITY_RIVAL, LEFT
	pause 10
	turnobject CHERRYGROVECITY_RIVAL, RIGHT
	opentext
	writetext CherrygroveRivalText_YouSeenMyName
	waitbutton
	closetext
	applymovement CHERRYGROVECITY_RIVAL, CherrygroveCity_RivalExitsStageLeft2
	disappear CHERRYGROVECITY_RIVAL
	setscene SCENE_CHERRYGROVECITY_NOOP
	special HealParty
	playmapmusic
	end

CherrygroveTeacherScript:
	faceplayer
	opentext
	checkflag ENGINE_MAP_CARD
	iftrue .HaveMapCard
	writetext CherrygroveTeacherText_NoMapCard
	waitbutton
	closetext
	end

.HaveMapCard:
	writetext CherrygroveTeacherText_HaveMapCard
	waitbutton
	closetext
	end

CherrygroveYoungsterScript:
	faceplayer
	opentext
	checkflag ENGINE_POKEDEX
	iftrue .HavePokedex
	writetext CherrygroveYoungsterText_NoPokedex
	waitbutton
	closetext
	end

.HavePokedex:
	writetext CherrygroveYoungsterText_HavePokedex
	waitbutton
	closetext
	end

MysticWaterGuy:
	faceplayer
	opentext
	checkevent EVENT_GOT_MYSTIC_WATER_IN_CHERRYGROVE
	iftrue .After
	writetext MysticWaterGuyTextBefore
	promptbutton
	verbosegiveitem MYSTIC_WATER
	iffalse .Exit
	setevent EVENT_GOT_MYSTIC_WATER_IN_CHERRYGROVE
.After:
	writetext MysticWaterGuyTextAfter
	waitbutton
.Exit:
	closetext
	end

CherrygroveCitySign:
	jumptext CherrygroveCitySignText

GuideGentsHouseSign:
	jumptext GuideGentsHouseSignText

CherrygroveCityPokecenterSign:
	jumpstd PokecenterSignScript

CherrygroveCityMartSign:
	jumpstd MartSignScript

GuideGentMovement1:
	step LEFT
	step LEFT
	step UP
	step LEFT
	step_end

GuideGentMovement2:
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	step_end

GuideGentMovement3:
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	step LEFT
	turn_head UP
	step_end

GuideGentMovement4:
	step LEFT
	step LEFT
	step LEFT
	step DOWN
	step LEFT
	step LEFT
	step LEFT
	step DOWN
	turn_head LEFT
	step_end

GuideGentMovement5:
	step DOWN
	step DOWN
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	step DOWN
	step DOWN
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	step RIGHT
	turn_head UP
	step_end

GuideGentMovement6:
	step UP
	step UP
	step_end

CherrygroveCity_RivalWalksToYou:
	big_step LEFT
	big_step LEFT
	big_step LEFT
	big_step LEFT
	big_step LEFT
	step_end

CherrygroveCity_RivalPushesYouOutOfTheWay:
	big_step DOWN
	turn_head UP
	step_end

CherrygroveCity_UnusedMovementData: ; unreferenced
	step LEFT
	turn_head DOWN
	step_end

CherrygroveCity_RivalExitsStageLeft1:
	big_step LEFT
	big_step LEFT
	big_step LEFT
	big_step LEFT
	step_end

CherrygroveCity_RivalLooksforID:
	turn_head UP
	turn_head UP
	turn_head UP
	turn_head UP
	turn_head UP
	turn_head UP
	turn_head UP
	turn_head UP
	turn_head UP
	turn_head UP
	turn_head UP
	turn_head UP
	turn_head UP
	turn_head UP
	turn_head UP
	turn_head UP		
	turn_head DOWN
	turn_head DOWN
	turn_head DOWN
	turn_head DOWN
	turn_head DOWN
	turn_head DOWN
	turn_head DOWN
	turn_head DOWN
	turn_head DOWN
	turn_head DOWN
	turn_head DOWN
	turn_head DOWN
	turn_head DOWN
	turn_head DOWN
	turn_head DOWN
	turn_head DOWN		
	step_end

CherrygroveCity_RivalWalksBackToYou:
	big_step DOWN
	big_step RIGHT
	big_step RIGHT
	step_end

CherrygroveCity_RivalTakesIDBack:
	turn_head LEFT
	fix_facing
	jump_step RIGHT
	remove_fixed_facing
	step LEFT
	step_end

CherrygroveCity_RivalExitsStageLeft2:
	big_step LEFT
	big_step LEFT
	big_step UP
	big_step UP
	big_step UP
	big_step LEFT
	step_end

CherrygroveCity_RivalMeetPoint:
	step UP
	turn_head RIGHT
	step_end

GuideGentMapFirstText:
       text "Hey there, young"
       line "man! I see you're"
       cont "in a hurry!"

       para "I won't waste too"
       line "much of your time,"
       cont "but you will get"
       cont "lost without"
       cont "knowing where to"
       cont "go!"

       para "Here's this MAP"
       line "CARD for your"
       cont "#GEAR!"
       done

GuideGentOfferTourText:
       text "Would you still"
       line "like the tour"
       cont "around town?"
       done

GuideGentTourText1:
	text "OK, then!"
	line "Follow me!"
	done

GuideGentPokecenterText:
	text "This is a #MON"
	line "CENTER. They heal"

	para "your #MON in no"
	line "time at all."

	para "You'll be relying"
	line "on them a lot, so"

	para "you better learn"
	line "about them."
	done

GuideGentMartText:
	text "This is a #MON"
	line "MART."

	para "They sell BALLS"
	line "for catching wild"

	para "#MON and other"
	line "useful items."
	done

GuideGentRoute30Text:
	text "ROUTE 30 is out"
	line "this way."

	para "Trainers will be"
	line "battling their"

	para "prized #MON"
	line "there."
	done

GuideGentSeaText:
	text "This is the sea,"
	line "as you can see."

	para "Some #MON are"
	line "found only in"
	cont "water."
	done

GuideGentHouseText:
       text "Here…"

       para "It's my house!"
       line "Thanks for your"
       cont "company."

       para "Feel free to stop"
       line "by if you need a"
       cont "breather."
       done

GotMapCardText:
	text "<PLAYER>'s #GEAR"
	line "now has a MAP!"
	done

GuideGentPokegearText:
	text "#GEAR becomes"
	line "more useful as you"
	cont "add CARDS."

	para "I wish you luck on"
	line "your journey!"
	done

GuideGentDeclineText:
       text "All right, then!"
       line "Good luck out"
       cont "there."

       para "Your way out of"
       line "town is ROUTE 30"
       cont "just past the"
       cont "#MON MART."
       done

CherrygroveRivalText_Seen:
	text "…"

	para "Out of my way"
	line "wimp, I'm in a"
	cont "hurry!"

	para "Wait, a minute.."

	para "…"

	para "You're that kid"
	line "who got the other"
	cont "#MON."

	para "I'm not gonna"
	line "take my chances."
	
	para "I'm getting rid"
	line "of you before"
	cont "you snitch on me."

	para "PREPARE YOURSELF!"
	done

RivalCherrygroveWinText:
	text "Humph. Are you"
	line "happy you won?"
	done

CherrygroveRivalText_YouLost:
	text "…"

	para "Yeah that's right."
	
	para "This is the"
	line "#MON from the"
	cont "lab."
	
	para "Heh. From what I"
	line "can tell, I got"
	cont "the stronger one."

	para "Since you clearly"
	line "don't know what's"
	cont "going on, I'll"
	cont "spare you."
	
	para "You never seen"
	line "this face, weak-"
	cont "ling."
	done

RivalCherrygroveLossText:
	text "Humph. You're"
	line "done."
	done

CherrygroveRivalText_YouWon:
	text "…"

	para "You just got lucky"
	line "wimp."

	para "Yeah that's right."
	
	para "This is the"
	line "#MON from the"
	cont "lab."
	
	para "You may have beat"
	line "me because of this"
	cont "weakling of a "
	cont "#MON."
	
	para "Tch. Whatever."

	para "Since you clearly"
	line "don't know what's"
	cont "going on, I'll"
	cont "spare you."
	
	para "You never seen"
	line "this face, weak-"
	cont "ling."
	done

CherrygroveRivalText_MyTrainerCard:
	text "HEY! That's my"
	line "trainer card!"
	
	para "GIVE IT!"
	done

CherrygroveRivalText_YouSeenMyName:
	text "Great now you know"
	line "my name."
	
	para "You better keep"
	line "your mouth zipped"
	cont "if you know what's"
	cont "good for you."
	
	para "...Wimp."
	done
CherrygroveTeacherText_NoMapCard:
	text "Did you talk to"
	line "the old man by the"
	cont "#MON CENTER?"

	para "He'll put a MAP of"
	line "JOHTO on your"
	cont "#GEAR."
	done

CherrygroveTeacherText_HaveMapCard:
	text "When you're with"
	line "#MON, going"
	cont "anywhere is fun."
	done

CherrygroveYoungsterText_NoPokedex:
	text "MR.#MON's house"
	line "is still farther"
	cont "up ahead."
	done

CherrygroveYoungsterText_HavePokedex:
	text "I battled the"
	line "trainers on the"
	cont "road."

	para "My #MON lost."
	line "They're a mess! I"

	para "must take them to"
	line "a #MON CENTER."
	done

MysticWaterGuyTextBefore:
	text "A #MON I caught"
	line "had an item."

	para "I think it's"
	line "MYSTIC WATER."

	para "I don't need it,"
	line "so do you want it?"
	done

MysticWaterGuyTextAfter:
	text "Back to fishing"
	line "for me, then."
	done

CherrygroveCitySignText:
	text "CHERRYGROVE CITY"

	para "The City of Cute,"
	line "Fragrant Flowers"
	done

GuideGentsHouseSignText:
	text "GUIDE GENT'S HOUSE"
	done

CherrygroveCity_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event 23,  3, CHERRYGROVE_MART, 2
	warp_event 29,  3, CHERRYGROVE_POKECENTER_1F, 1
	warp_event 17,  7, CHERRYGROVE_GYM_SPEECH_HOUSE, 1
	warp_event 25,  9, GUIDE_GENTS_HOUSE, 1
	warp_event 31, 11, CHERRYGROVE_EVOLUTION_SPEECH_HOUSE, 1

	def_coord_events
	coord_event 32,  7, -1, CherrygroveCityGuideGentTrigger
	coord_event 33,  6, SCENE_CHERRYGROVECITY_MEET_RIVAL, CherrygroveRivalSceneNorth
	coord_event 33,  7, SCENE_CHERRYGROVECITY_MEET_RIVAL, CherrygroveRivalSceneSouth

	def_bg_events
	bg_event 30,  8, BGEVENT_READ, CherrygroveCitySign
	bg_event 23,  9, BGEVENT_READ, GuideGentsHouseSign
	bg_event 24,  3, BGEVENT_READ, CherrygroveCityMartSign
	bg_event 30,  3, BGEVENT_READ, CherrygroveCityPokecenterSign

	def_object_events
	object_event 32,  6, SPRITE_GRAMPS, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, CherrygroveCityGuideGent, EVENT_GUIDE_GENT_IN_HIS_HOUSE
	object_event 39,  6, SPRITE_RIVAL, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, 0, OBJECTTYPE_SCRIPT, 0, ObjectEvent, EVENT_RIVAL_CHERRYGROVE_CITY
	object_event 27, 12, SPRITE_TEACHER, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, PAL_NPC_BLUE, OBJECTTYPE_SCRIPT, 0, CherrygroveTeacherScript, -1
	object_event 23,  7, SPRITE_YOUNGSTER, SPRITEMOVEDATA_WALK_LEFT_RIGHT, 1, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, CherrygroveYoungsterScript, -1
	object_event  7, 12, SPRITE_FISHER, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, MysticWaterGuy, -1
