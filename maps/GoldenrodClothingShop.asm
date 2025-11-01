	
	
	object_const_def
	const GOLDENRODCLOTHINGSHOP_CLERK
	const GOLDENRODCLOTHINGSHOP_STYLIST


DEF GOLDENRODCLOTHINGSHOP_BLUE_PRICE     EQU 1500
DEF GOLDENRODCLOTHINGSHOP_GREEN_PRICE    EQU 2000
DEF GOLDENRODCLOTHINGSHOP_PURPLE_PRICE   EQU 3500

GoldenrodClothingShop_MapScripts:
	def_scene_scripts

	def_callbacks

GoldenrodClothingShopClerkScript:
	faceplayer
	opentext
.MenuLoop:
	writetext GoldenrodClothingShopClerkGreetingText
	loadmenu GoldenrodClothingShopMenuHeader
	verticalmenu
	closewindow
	ifequal 1, .BlueOption
	ifequal 2, .GreenOption
	ifequal 3, .PurpleOption
	sjump .Goodbye

.BlueOption:
	scall GoldenrodClothingShopOfferBlue
	sjump .MenuLoop

.GreenOption:
	scall GoldenrodClothingShopOfferGreen
	sjump .MenuLoop

.PurpleOption:
	scall GoldenrodClothingShopOfferPurple
	sjump .MenuLoop

.Goodbye:
	writetext GoldenrodClothingShopClerkComeAgainText
	waitbutton
	closetext
	end

GoldenrodClothingShopOfferBlue:
	checkevent EVENT_GOLDENROD_CLOTHING_SHOP_BOUGHT_BLUE
	iftrue .AlreadyOwn
	special PlaceMoneyTopRight
	writetext GoldenrodClothingShopBluePitchText
	yesorno
	iffalse .Decline
	checkmoney YOUR_MONEY, GOLDENRODCLOTHINGSHOP_BLUE_PRICE
	ifequal HAVE_LESS, .NoMoney
	takemoney YOUR_MONEY, GOLDENRODCLOTHINGSHOP_BLUE_PRICE
	special PlaceMoneyTopRight
	playsound SFX_TRANSACTION
	waitsfx
	setevent EVENT_GOLDENROD_CLOTHING_SHOP_BOUGHT_BLUE
	writetext GoldenrodClothingShopBluePurchaseText
	promptbutton
	sjump .AskToWear

.AlreadyOwn:
	writetext GoldenrodClothingShopBlueOwnedText
	promptbutton

.AskToWear:
	writetext GoldenrodClothingShopBlueEquipPromptText
	yesorno
	iffalse .NoChange
	setval PLAYER_OUTFIT_BLUE
	special ApplyPlayerOutfit
	writetext GoldenrodClothingShopBlueEquipText
	waitbutton
	sjump .End

.Decline:
	writetext GoldenrodClothingShopMaybeAnotherTimeText
	waitbutton
	sjump .End

.NoMoney:
	writetext GoldenrodClothingShopNotEnoughMoneyText
	waitbutton
	sjump .End

.NoChange:
	writetext GoldenrodClothingShopKeepCurrentLookText
	waitbutton

.End:
	end

GoldenrodClothingShopOfferGreen:
	checkevent EVENT_GOLDENROD_CLOTHING_SHOP_BOUGHT_GREEN
	iftrue .AlreadyOwn
	special PlaceMoneyTopRight
	writetext GoldenrodClothingShopGreenPitchText
	yesorno
	iffalse .Decline
	checkmoney YOUR_MONEY, GOLDENRODCLOTHINGSHOP_GREEN_PRICE
	ifequal HAVE_LESS, .NoMoney
	takemoney YOUR_MONEY, GOLDENRODCLOTHINGSHOP_GREEN_PRICE
	special PlaceMoneyTopRight
	playsound SFX_TRANSACTION
	waitsfx
	setevent EVENT_GOLDENROD_CLOTHING_SHOP_BOUGHT_GREEN
	writetext GoldenrodClothingShopGreenPurchaseText
	promptbutton
	sjump .AskToWear

.AlreadyOwn:
	writetext GoldenrodClothingShopGreenOwnedText
	promptbutton

.AskToWear:
	writetext GoldenrodClothingShopGreenEquipPromptText
	yesorno
	iffalse .NoChange
	setval PLAYER_OUTFIT_GREEN
	special ApplyPlayerOutfit
	writetext GoldenrodClothingShopGreenEquipText
	waitbutton
	sjump .End

.Decline:
	writetext GoldenrodClothingShopMaybeAnotherTimeText
	waitbutton
	sjump .End

.NoMoney:
	writetext GoldenrodClothingShopNotEnoughMoneyText
	waitbutton
	sjump .End

.NoChange:
	writetext GoldenrodClothingShopKeepCurrentLookText
	waitbutton

.End:
	end

GoldenrodClothingShopOfferPurple:
	checkevent EVENT_GOLDENROD_CLOTHING_SHOP_BOUGHT_PURPLE
	iftrue .AlreadyOwn
	special PlaceMoneyTopRight
	writetext GoldenrodClothingShopPurplePitchText
	yesorno
	iffalse .Decline
	checkmoney YOUR_MONEY, GOLDENRODCLOTHINGSHOP_PURPLE_PRICE
	ifequal HAVE_LESS, .NoMoney
	takemoney YOUR_MONEY, GOLDENRODCLOTHINGSHOP_PURPLE_PRICE
	special PlaceMoneyTopRight
	playsound SFX_TRANSACTION
	waitsfx
	setevent EVENT_GOLDENROD_CLOTHING_SHOP_BOUGHT_PURPLE
	writetext GoldenrodClothingShopPurplePurchaseText
	promptbutton
	sjump .AskToWear

.AlreadyOwn:
	writetext GoldenrodClothingShopPurpleOwnedText
	promptbutton

.AskToWear:
	writetext GoldenrodClothingShopPurpleEquipPromptText
	yesorno
	iffalse .NoChange
	setval PLAYER_OUTFIT_PURPLE
	special ApplyPlayerOutfit
	writetext GoldenrodClothingShopPurpleEquipText
	waitbutton
	sjump .End

.Decline:
	writetext GoldenrodClothingShopMaybeAnotherTimeText
	waitbutton
	sjump .End

.NoMoney:
	writetext GoldenrodClothingShopNotEnoughMoneyText
	waitbutton
	sjump .End

.NoChange:
	writetext GoldenrodClothingShopKeepCurrentLookText
	waitbutton

.End:
	end

GoldenrodClothingShopStylistScript:
	jumptextfaceplayer GoldenrodClothingShopStylistText

GoldenrodClothingShopDisplayLeft:
	jumptext GoldenrodClothingShopDisplayLeftText

GoldenrodClothingShopDisplayRight:
	jumptext GoldenrodClothingShopDisplayRightText

GoldenrodClothingShopChangingRoom:
	opentext
.WardrobeLoop:
	writetext GoldenrodClothingShopChangingRoomText
	loadmenu GoldenrodClothingShopChangingRoomMenuHeader
	verticalmenu
	closewindow
	ifequal 1, .Classic
	ifequal 2, .BlueFit
	ifequal 3, .GreenFit
	ifequal 4, .PurpleFit
	sjump .Exit

.BlueFit:
	checkevent EVENT_GOLDENROD_CLOTHING_SHOP_BOUGHT_BLUE
	iffalse .Locked
	setval PLAYER_OUTFIT_BLUE
	special ApplyPlayerOutfit
	writetext GoldenrodClothingShopBlueEquipText
	waitbutton
	sjump .WardrobeLoop

.GreenFit:
	checkevent EVENT_GOLDENROD_CLOTHING_SHOP_BOUGHT_GREEN
	iffalse .Locked
	setval PLAYER_OUTFIT_GREEN
	special ApplyPlayerOutfit
	writetext GoldenrodClothingShopGreenEquipText
	waitbutton
	sjump .WardrobeLoop

.PurpleFit:
	checkevent EVENT_GOLDENROD_CLOTHING_SHOP_BOUGHT_PURPLE
	iffalse .Locked
	setval PLAYER_OUTFIT_PURPLE
	special ApplyPlayerOutfit
	writetext GoldenrodClothingShopPurpleEquipText
	waitbutton
	sjump .WardrobeLoop

.Classic:
	setval PLAYER_OUTFIT_CLASSIC
	special ApplyPlayerOutfit
	writetext GoldenrodClothingShopClassicEquipText
	waitbutton
	sjump .WardrobeLoop

.Locked:
	writetext GoldenrodClothingShopWardrobeLockedText
	waitbutton
	sjump .WardrobeLoop

.Exit:
	writetext GoldenrodClothingShopChangingRoomExitText
	waitbutton
	closetext
	end

GoldenrodClothingShopClerkGreetingText:
	text "Welcome to GOLD-"
	line "ENROD APPAREL!"
	
	para "Got a color that"
	line "catches your eye?"
	done

GoldenrodClothingShopClerkComeAgainText:
	text "Come again when"
	line "you're ready for"

	para "another new look."
	done

GoldenrodClothingShopBluePitchText:
	text "The CHERRYGROVE"
	line "BLUE is ¥1500."
	cont "Shall I wrap it"
	cont "up?"
	done

GoldenrodClothingShopBluePurchaseText:
	text "Lovely! We'll"
	line "prepare the"
	cont "CHERRYGROVE BLUE"
	cont "for you!"
	done

GoldenrodClothingShopBlueOwnedText:
	text "You've already"
	line "picked up the"
	cont "CHERRYGROVE BLUE."
	done

GoldenrodClothingShopBlueEquipPromptText:
	text "Change into the"
	line "CHERRYGROVE BLUE"
	cont "right now?"
	done

GoldenrodClothingShopBlueEquipText:
	text "The cool BLUE"
	line "tones suit you"
	cont "perfectly!"
	done

GoldenrodClothingShopGreenPitchText:
	text "The NATIONAL"
	line "GREEN costs"
	cont "¥2000."
	
	para "Interested?"
	done

GoldenrodClothingShopGreenPurchaseText:
	text "Excellent choice!"
	line "That NATIONAL"
	cont "GREEN is yours!"
	done

GoldenrodClothingShopGreenOwnedText:
	text "You've already"
	line "claimed the"
	cont "NATIONAL GREEN."
	done

GoldenrodClothingShopGreenEquipPromptText:
	text "Wear the NATIONAL"
	line "GREEN for a fresh"
	cont "park feel?"
	done

GoldenrodClothingShopGreenEquipText:
	text "Verdant greens"
	line "flow around you"
	cont "with confidence."
	done

GoldenrodClothingShopPurplePitchText:
	text "The EXEC. PURPLE"
	line "costs ¥3500."
	cont "Shall we proceed?"
	done

GoldenrodClothingShopPurplePurchaseText:
	text "A radiant pick!"
	line "The EXEC. PURPLE"
	cont "is ready for you."
	done

GoldenrodClothingShopPurpleOwnedText:
	text "You've already"
	line "secured the"
	cont "EXEC. PURPLE."
	done

GoldenrodClothingShopPurpleEquipPromptText:
	text "Slip into the"
	line "EXEC. PURPLE"
	cont "right this moment?"
	done

GoldenrodClothingShopPurpleEquipText:
	text "The purple hues"
	line "bring out your"
	cont "warmth nicely."
	done

GoldenrodClothingShopMaybeAnotherTimeText:
	text "No rush. Style"
	line "should be chosen"
	cont "at your pace."
	done

GoldenrodClothingShopNotEnoughMoneyText:
	text "Oh! It seems"
	line "you're short on"
	cont "funds right now."
	done

GoldenrodClothingShopKeepCurrentLookText:
	text "All right. We'll"
	line "keep your current"
	cont "outfit pressed."
	done

GoldenrodClothingShopStylistText:
	text "Color tells your"
	line "story. Try on"

	para "new shades to"
	line "match your mood."
	done

GoldenrodClothingShopDisplayLeftText:
	text "A rack of neatly"
	line "pressed jackets"
	cont "and scarves."
	done

GoldenrodClothingShopDisplayRightText:
	text "Swatches of fabric"
	line "showcasing each"
	cont "palette's tone."
	done

GoldenrodClothingShopChangingRoomText:
	text "The curtain"
	line "rustles softly."

	para "Which palette"
	line "will you try on?"
	done

GoldenrodClothingShopClassicEquipText:
	text "Back to your"
	line "classic colors—"
	cont "timeless as ever."
	done

GoldenrodClothingShopWardrobeLockedText:
	text "That palette"
	line "isn't in your"
	cont "wardrobe yet."
	done

GoldenrodClothingShopChangingRoomExitText:
	text "Refreshed and"
	line "ready to travel"
	cont "Johto in style!"
	done

GoldenrodClothingShop_MenuData:
	db STATICMENU_CURSOR
	db 4
	db "C.GROVE BLUE@"
	db "NAT. GREEN@"
	db "EXEC. PURPLE@"
	db "EXIT@"

GoldenrodClothingShopMenuHeader:
	db MENU_BACKUP_TILES
	menu_coords 0, 0, 15, 9
	dw GoldenrodClothingShop_MenuData
	db 1

GoldenrodClothingShopChangingRoomMenuData:
	db STATICMENU_CURSOR
	db 5
	db "JOHTO CLASSIC@"
	db "C.GROVE BLUE@"
	db "NAT. GREEN@"
	db "EXEC. PURPLE@"
	db "EXIT@"

GoldenrodClothingShopChangingRoomMenuHeader:
	db MENU_BACKUP_TILES
	menu_coords 0, 0, 16, 11
	dw GoldenrodClothingShopChangingRoomMenuData
	db 1

GoldenrodClothingShop_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  4,  7, GOLDENROD_CITY, 8
	warp_event  5,  7, GOLDENROD_CITY, 8

	def_coord_events

	def_bg_events
	bg_event  0,  0, BGEVENT_READ, GoldenrodClothingShopDisplayLeft
	bg_event  2,  0, BGEVENT_READ, GoldenrodClothingShopDisplayRight
	bg_event 6,  0, BGEVENT_READ, GoldenrodClothingShopChangingRoom

	def_object_events
	object_event  3,  1, SPRITE_CLERK, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_PURPLE, OBJECTTYPE_SCRIPT, 0, GoldenrodClothingShopClerkScript, -1
	object_event 6,  6, SPRITE_LASS, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, GoldenrodClothingShopStylistScript, -1
