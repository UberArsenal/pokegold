JohtoSafariZone_MapScripts:
	def_scene_scripts

	def_callbacks

JohtoSafariZone_MapEvents:
	db 0, 0 ; filler

	def_warp_events
        warp_event  9, 23, SAFARI_ZONE_GATE_F1, 1
        warp_event 10, 23, SAFARI_ZONE_GATE_F1, 2
	def_coord_events

	def_bg_events

	def_object_events
