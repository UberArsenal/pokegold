
DEF GOLDENRODCLOTHINGSHOP_CBLUE_PRICE     EQU 1500
DEF GOLDENRODCLOTHINGSHOP_NGREEN_PRICE    EQU 2000
DEF GOLDENRODCLOTHINGSHOP_EPURPLE_PRICE   EQU 3500

	object_const_def
	const GOLDENRODCLOTHINGSHOP_CLERK
	const GOLDENRODCLOTHINGSHOP_STYLIST

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
	ifequal 1, .blue
	ifequal 2, .green
	ifequal 3, .purple
	sjump .Goodbye

.blue:
	scall GoldenrodClothingShopOfferBlue
	sjump .MenuLoop

.green:
	scall GoldenrodClothingShopOfferGreen
	sjump .MenuLoop

.purple:
	scall GoldenrodClothingShopOfferPurple
	sjump .MenuLoop

.Goodbye:
	writetext GoldenrodClothingShopClerkComeAgainText
	waitbutton
	closetext
	end

GoldenrodClothingShopOfferBlue:
	checkevent EVENT_GOLDENROD_CLOTHING_SHOP_BOUGHT_CBLUE
	iftrue .AlreadyOwn
	special PlaceMoneyTopRight
	writetext GoldenrodClothingShopBluePitchText
	yesorno
	iffalse .Decline
	checkmoney YOUR_MONEY, GOLDENRODCLOTHINGSHOP_CBLUE_PRICE
	ifequal HAVE_LESS, .NoMoney
	takemoney YOUR_MONEY, GOLDENRODCLOTHINGSHOP_CBLUE_PRICE
	special PlaceMoneyTopRight
	playsound SFX_TRANSACTION
	waitsfx
	setevent EVENT_GOLDENROD_CLOTHING_SHOP_BOUGHT_CBLUE
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
	setval PLAYER_OUTFIT_CBLUE
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
	checkevent EVENT_GOLDENROD_CLOTHING_SHOP_BOUGHT_NGREEN
	iftrue .AlreadyOwn
	special PlaceMoneyTopRight
	writetext GoldenrodClothingShopGreenPitchText
	yesorno
	iffalse .Decline
	checkmoney YOUR_MONEY, GOLDENRODCLOTHINGSHOP_NGREEN_PRICE
	ifequal HAVE_LESS, .NoMoney
	takemoney YOUR_MONEY, GOLDENRODCLOTHINGSHOP_NGREEN_PRICE
	special PlaceMoneyTopRight
	playsound SFX_TRANSACTION
	waitsfx
	setevent EVENT_GOLDENROD_CLOTHING_SHOP_BOUGHT_NGREEN
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
	setval PLAYER_OUTFIT_NGREEN
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
	checkevent EVENT_GOLDENROD_CLOTHING_SHOP_BOUGHT_EPURPLE
	iftrue .AlreadyOwn
	special PlaceMoneyTopRight
	writetext GoldenrodClothingShopPurplePitchText
	yesorno
	iffalse .Decline
	checkmoney YOUR_MONEY, GOLDENRODCLOTHINGSHOP_EPURPLE_PRICE
	ifequal HAVE_LESS, .NoMoney
	takemoney YOUR_MONEY, GOLDENRODCLOTHINGSHOP_EPURPLE_PRICE
	special PlaceMoneyTopRight
	playsound SFX_TRANSACTION
	waitsfx
	setevent EVENT_GOLDENROD_CLOTHING_SHOP_BOUGHT_EPURPLE
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
	setval PLAYER_OUTFIT_EPURPLE
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
	ifequal 2, .blue
	ifequal 3, .green
	ifequal 4, .purple
	sjump .Exit

blue:
	checkevent EVENT_GOLDENROD_CLOTHING_SHOP_BOUGHT_CBLUE
	iffalse .Locked
	setval PLAYER_OUTFIT_CBLUE
	special ApplyPlayerOutfit
	writetext GoldenrodClothingShopAzureEquipText
	waitbutton
	sjump .WardrobeLoop

.green:
	checkevent EVENT_GOLDENROD_CLOTHING_SHOP_BOUGHT_NGREEN
	iffalse .Locked
	setval PLAYER_OUTFIT_NGREEN
	special ApplyPlayerOutfit
	writetext GoldenrodClothingShopGreenEquipText
	waitbutton
	sjump .WardrobeLoop

.purple:
	checkevent EVENT_GOLDENROD_CLOTHING_SHOP_BOUGHT_EPURPLE
	iffalse .Locked
	setval PLAYER_OUTFIT_EPURPLE
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

GoldenrodClothingShopAzurePitchText:
	text "The CHERRYGROVE"
	line "BLUE is ¥1500."
	cont "Shall I wrap it"
	cont "up?"
	done

GoldenrodClothingShopAzurePurchaseText:
	text "Lovely! We'll"
	line "prepare the"
	cont "CHERRYGROVE BLUE"
	cont "for you!"
	done

GoldenrodClothingShopAzureOwnedText:
	text "You've already"
	line "picked up the"
	cont "CHERRYGROVE BLUE."
	done

GoldenrodClothingShopAzureEquipPromptText:
	text "Change into the"
	line "CHERRYGROVE BLUE"
	cont "right now?"
	done

GoldenrodClothingShopAzureEquipText:
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
	db STATICMENU_OPTIONS
	db 4
	db "Cherrygrove Blue@"
	db "National Green@"
	db "Executive Purple@"
	db "Cancel@"

GoldenrodClothingShopMenuHeader:
	db MENU_BACKUP_TILES
	menu_coords 0, 2, 15, TEXTBOX_Y - 1
	dw GoldenrodClothingShop_MenuData
	db 1

GoldenrodClothingShopChangingRoomMenuData:
	db STATICMENU_OPTIONS
	db 5
	db "Johto Classic@"
	db "Cherrygrove Blue@"
	db "National Green@"
	db "Executive Purple@"
	db "Exit@"

GoldenrodClothingShopChangingRoomMenuHeader:
	db MENU_BACKUP_TILES
	menu_coords 0, 2, 16, TEXTBOX_Y - 1
	dw GoldenrodClothingShopChangingRoomMenuData
	db 1

GoldenrodClothingShop_MapEvents:
	db 0, 0 ; filler

	def_warp_events
	warp_event  7,  7, GOLDENROD_CITY, 8
	warp_event  8,  7, GOLDENROD_CITY, 8

	def_coord_events

	def_bg_events
	bg_event  1,  0, BGEVENT_READ, GoldenrodClothingShopDisplayLeft
	bg_event  2,  0, BGEVENT_READ, GoldenrodClothingShopDisplayRight
	bg_event 13,  0, BGEVENT_READ, GoldenrodClothingShopChangingRoom

	def_object_events
	object_event  8,  2, SPRITE_CLERK, SPRITEMOVEDATA_STANDING_RIGHT, 0, 0, -1, -1, PAL_NPC_PURPLE, OBJECTTYPE_SCRIPT, 0, GoldenrodClothingShopClerkScript, -1
	object_event 11,  3, SPRITE_LASS, SPRITEMOVEDATA_STANDING_LEFT, 0, 0, -1, -1, PAL_NPC_GREEN, OBJECTTYPE_SCRIPT, 0, GoldenrodClothingShopStylistScript, -1
