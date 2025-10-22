JohtoSafariZone_MapScripts:
    def_scene_scripts
        scene_script JohtoSafariZoneNoopScene, SCENE_JOHTOSAFARIZONE_DEFAULT

    def_callbacks
        callback MAPCALLBACK_NEWMAP, JohtoSafariZoneEnterCallback
        callback MAPCALLBACK_STEPCYCLE, JohtoSafariZoneStepCallback

JohtoSafariZoneNoopScene:
    end

JohtoSafariZoneEnterCallback:
    checkflag ENGINE_SAFARI_ZONE
    iffalse .Done
    callasm JohtoSafari_StartSession
.Done:
    endcallback

JohtoSafariZoneStepCallback:
    callasm JohtoSafari_StepWatcherAsm
    iffalse .KeepExploring
    sdefer JohtoSafari_TimeUpScript
.KeepExploring:
    endcallback

JohtoSafariZone_MapEvents:
    db 0, 0 ; filler

    def_warp_events
        warp_event  9, 23, SAFARI_ZONE_GATE_F1, 1
        warp_event 10, 23, SAFARI_ZONE_GATE_F1, 2
	def_coord_events

	def_bg_events

	def_object_events