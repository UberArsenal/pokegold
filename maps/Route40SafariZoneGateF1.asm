object_const_def
        const ROUTE40SAFARIZONEGATEF1_RECEPTIONIST
        const ROUTE40SAFARIZONEGATEF1_NPC1
        const ROUTE40SAFARIZONEGATEF1_NPC2

DEF ROUTE40SAFARIZONEGATEF1_SESSION_PRICE EQU 400

Route40SafariZoneGateF1_MapScripts:
    def_scene_scripts
        scene_script Route40SafariZoneGateF1NoopScene, SCENE_ROUTE40SAFARIZONEGATEF1_DEFAULT

    def_callbacks
        callback MAPCALLBACK_NEWMAP, Route40SafariZoneGateF1ReturnCallback

Route40SafariZoneGateF1NoopScene:
    end

Route40SafariZoneGateF1ReceptionistScript:
    faceplayer
    opentext
    checkflag ENGINE_SAFARI_ZONE
    iftrue Route40SafariZoneGateF1ReceptionistSessionActive
    special PlaceMoneyTopRight
    writetext Route40SafariZoneGateF1ReceptionistOfferText
    yesorno
    iffalse Route40SafariZoneGateF1ReceptionistDeclined
    checkmoney YOUR_MONEY, ROUTE40SAFARIZONEGATEF1_SESSION_PRICE
    ifequal HAVE_LESS, Route40SafariZoneGateF1ReceptionistNoMoney
    takemoney YOUR_MONEY, ROUTE40SAFARIZONEGATEF1_SESSION_PRICE
    special PlaceMoneyTopRight
    playsound SFX_TRANSACTION
    writetext Route40SafariZoneGateF1ReceptionistThankYouText
    waitbutton
	callasm JohtoSafari_GiveSafariBalls
    iffalse Route40SafariZoneGateF1ReceptionistNoBagSpace
    playsound SFX_GOT_SAFARI_BALLS
    writetext Route40SafariZoneGateF1ReceptionistBallsText
    waitbutton
	itemnotify
    closetext
    setflag ENGINE_SAFARI_ZONE
    applymovement PLAYER, Route40SafariZoneGateF1_PlayerToSafariMovement
    end

Route40SafariZoneGateF1ReceptionistSessionActive:
    writetext Route40SafariZoneGateF1ReceptionistSessionActiveText
    waitbutton
    closetext
    end

Route40SafariZoneGateF1ReceptionistDeclined:
    writetext Route40SafariZoneGateF1ReceptionistDeclineText
    waitbutton
    closetext
    end

Route40SafariZoneGateF1ReceptionistNoMoney:
    writetext Route40SafariZoneGateF1ReceptionistNoMoneyText
    waitbutton
    closetext
    end

Route40SafariZoneGateF1ReceptionistNoBagSpace:
    givemoney YOUR_MONEY, ROUTE40SAFARIZONEGATEF1_SESSION_PRICE
    special PlaceMoneyTopRight
    writetext Route40SafariZoneGateF1ReceptionistNoBagSpaceText
    waitbutton
    closetext
    end


Route40SafariZoneGateF1Npc1Script:
    jumptextfaceplayer Route40SafariZoneGateF1NpcPlaceholderText

Route40SafariZoneGateF1Npc2Script:
        jumptextfaceplayer Route40SafariZoneGateF1NpcPlaceholderText

Route40SafariZoneGateF1LockedDoorScript:
    checkflag ENGINE_SAFARI_ZONE
    iftrue Route40SafariZoneGateF1DoorOpens
    turnobject PLAYER, DOWN
    opentext
    writetext Route40SafariZoneGateF1LockedDoorText
    waitbutton
    closetext
    applymovement PLAYER, Route40SafariZoneGateF1_PushBackMovement
    end

Route40SafariZoneGateF1DoorOpens:
    end

Route40SafariZoneGateF1ReturnCallback:
    checkflag ENGINE_SAFARI_ZONE
    iffalse .Done
    sdefer Route40SafariZoneGateF1EndSafariScript
.Done:
    endcallback

Route40SafariZoneGateF1EndSafariScript:
    clearflag ENGINE_SAFARI_ZONE
    callasm JohtoSafari_ResetBallCount
    opentext
    writetext Route40SafariZoneGateF1EndSafariText
    waitbutton
    closetext
    special RestartMapMusic
    end

Route40SafariZoneGateF1_MapEvents:
    db 0, 0 ; filler

    def_warp_events
        warp_event  4,  0, JOHTO_SAFARI_ZONE, 1
    warp_event  5,  0, JOHTO_SAFARI_ZONE, 2
    warp_event  4,  7, ROUTE_40, 1
    warp_event  5,  7, ROUTE_40, 2

    def_coord_events
    coord_event  4,  0, SCENE_ROUTE40SAFARIZONEGATEF1_DEFAULT, Route40SafariZoneGateF1LockedDoorScript
    coord_event  5,  0, SCENE_ROUTE40SAFARIZONEGATEF1_DEFAULT, Route40SafariZoneGateF1LockedDoorScript

    def_bg_events


    def_object_events
        object_event  0,  3, SPRITE_RECEPTIONIST, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, Route40SafariZoneGateF1ReceptionistScript, -1
        object_event  3,  2, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, Route40SafariZoneGateF1Npc1Script, -1
        object_event  7,  5, SPRITE_FISHER, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, Route40SafariZoneGateF1Npc2Script, -1

Route40SafariZoneGateF1_PlayerToSafariMovement:
    step RIGHT
    step RIGHT
    step RIGHT
    step UP
    step UP
    step UP
    step_end

Route40SafariZoneGateF1_PushBackMovement:
    step DOWN
    step_end

Route40SafariZoneGateF1ReceptionistOfferText:
    text "Welcome to JOHTO's"
    line "SAFARI ZONE."

    para "A session is ¥{d:ROUTE40SAFARIZONEGATEF1_SESSION_PRICE}"
    line "for 30 SAFARI"
    cont "BALLS. Want to"
    cont "head inside?"
    done

Route40SafariZoneGateF1ReceptionistThankYouText:
    text "Great! That'll be"
    line "¥{d:ROUTE40SAFARIZONEGATEF1_SESSION_PRICE}."
    done

Route40SafariZoneGateF1ReceptionistBallsText:
    text "Here are 30"
    line "SAFARI BALLS."

    para "We'll guide you"
    line "to the gate."
    done

Route40SafariZoneGateF1ReceptionistDeclineText:
    text "No worries. We'll"
    line "be here when"
    cont "you're ready."
    done

Route40SafariZoneGateF1ReceptionistNoMoneyText:
    text "I'm sorry, but"
    line "you don't have"
    cont "enough money."
    done

Route40SafariZoneGateF1ReceptionistSessionActiveText:
    text "Your SAFARI"
    line "session is ready."

    para "Please proceed"
    line "through the gate."
    done

Route40SafariZoneGateF1ReceptionistNoBagSpaceText:
    text "It looks like your"
    line "PACK is full."

    para "Make some room"
    line "for the SAFARI"
    cont "BALLS first."
    done


Route40SafariZoneGateF1NpcPlaceholderText:
    text "NPC has not been"
    line "scripted yet."
    done

Route40SafariZoneGateF1LockedDoorText:
    text "The door is locked."

    para "Maybe paying for"
    line "the SAFARI ZONE"
    cont "game will open it."
    done

Route40SafariZoneGateF1EndSafariText:
    text "Welcome back!"
    line "Your SAFARI"
    cont "session is over."

    para "Come again"
    line "anytime!"
    done