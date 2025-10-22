
        object_const_def
        const ROUTE40SAFARIZONEGATEF1_RECEPTIONIST
        const ROUTE40SAFARIZONEGATEF1_NPC1
        const ROUTE40SAFARIZONEGATEF1_NPC2

Route40SafariZoneGateF1_MapScripts:
        def_scene_scripts

        def_callbacks

Route40SafariZoneGateF1ReceptionistScript:
        jumptextfaceplayer Route40SafariZoneGateF1ReceptionistText

Route40SafariZoneGateF1Npc1Script:
        jumptextfaceplayer Route40SafariZoneGateF1NpcPlaceholderText

Route40SafariZoneGateF1Npc2Script:
        jumptextfaceplayer Route40SafariZoneGateF1NpcPlaceholderText

Route40SafariZoneGateF1LockedDoorScript:
        jumptext Route40SafariZoneGateF1LockedDoorText

Route40SafariZoneGateF1_MapEvents:
        db 0, 0 ; filler

        def_warp_events
        warp_event  4,  7, ROUTE_40, 1
        warp_event  5,  7, ROUTE_40, 2

        def_coord_events

        def_bg_events
        bg_event  4,  0, BGEVENT_UP, Route40SafariZoneGateF1LockedDoorScript
        bg_event  5,  0, BGEVENT_UP, Route40SafariZoneGateF1LockedDoorScript

        def_object_events
        object_event  0,  3, SPRITE_RECEPTIONIST, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, Route40SafariZoneGateF1ReceptionistScript, -1
        object_event  3,  2, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_SPINRANDOM_SLOW, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, Route40SafariZoneGateF1Npc1Script, -1
        object_event  7,  5, SPRITE_FISHER, SPRITEMOVEDATA_WANDER, 1, 1, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, Route40SafariZoneGateF1Npc2Script, -1

Route40SafariZoneGateF1ReceptionistText:
        text "Welcome to JOHTO's"
        line "very own SAFARI"
        cont "ZONE!"

        para "We are currently"
        line "closed right now,"
        cont "but opening day is"
        cont "coming soon!"
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
