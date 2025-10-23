
; ============================================================================
; Johto Safari Zone Draft
; ----------------------------------------------------------------------------
; Prototype Safari Zone control flow derived from the National Park Bug Catching
; Contest scripts. This version removes the contest judging phase and instead
; focuses on two failure conditions:
;   1. Running out of allotted steps (treated here as a simple step timer).
;   2. Running out of Safari Balls.
;
; The routines in this file are intentionally self-contained so they can be
; transplanted into the final Safari Zone map once that layout exists. Several
; TODOs remain for integrating with the overworld warp destinations and for
; introducing a dedicated Safari battle type.
; ============================================================================

DEF JOHTO_SAFARI_MAX_STEPS EQU 500
DEF JOHTO_SAFARI_MAX_BALLS EQU 30

; TODO: Restore a proper Safari battle type once the engine supports it.
DEF BATTLETYPE_SAFARI EQU BATTLETYPE_NORMAL

; ---------------------------------------------------------------------------
; Session setup
; ---------------------------------------------------------------------------
; Initializes the player's Safari session by restoring their Safari Ball count
; and step allowance.
;
; Expected call site: Safari Zone gate attendant before the player is allowed
; to enter the reserve.
JohtoSafari_StartSession::
    ld a, JOHTO_SAFARI_MAX_BALLS
    ld [wSafariBallsRemaining], a
    ld hl, wSafariTimeRemaining
        ld a, LOW(JOHTO_SAFARI_MAX_STEPS)
        ld [hli], a
    ld a, HIGH(JOHTO_SAFARI_MAX_STEPS)
    ld [hl], a
    ld hl, wStatusFlags2
    set STATUSFLAGS2_SAFARI_GAME_F, [hl]
    xor a
	ld [wScriptVar], a
    ret

JohtoSafari_ResetBallCount::
; Clears the session state, timer, and any Safari Balls still in the bag.
    call JohtoSafari_ClearSafariBallItem
    xor a
    ld [wSafariBallsRemaining], a
    ld hl, wSafariTimeRemaining
    ld [hli], a
    ld [hl], a
    ld hl, wStatusFlags2
    res STATUSFLAGS2_SAFARI_GAME_F, [hl]
    ld [wScriptVar], a
    ret

JohtoSafari_GiveSafariBalls::
; Attempts to add the Safari Ball stack to the bag and returns success
; in wScriptVar for map scripts to branch on.
    ld a, SAFARI_BALL
    ld [wCurItem], a
    ld a, JOHTO_SAFARI_MAX_BALLS
    ld [wItemQuantityChange], a
    ld hl, wNumBalls
    call ReceiveItem
    jr nc, .bag_full
    ld a, TRUE
    jr .store_result

.bag_full
    xor a

.store_result
    ld [wScriptVar], a
    ret

JohtoSafari_ClearSafariBallItem::
; Removes any remaining Safari Balls from the bag's Balls pocket.
    ld a, SAFARI_BALL
    ld [wCurItem], a
    ld a, -1
    ld [wCurItemQuantity], a
    ld hl, wNumBalls
    ld e, l
    ld d, h
    inc de

.loop
    ld a, [de]
    cp -1
    ret z
    cp SAFARI_BALL
    jr nz, .next
    inc de
    ld a, [de]
    ld [wItemQuantityChange], a
    ld hl, wNumBalls
    call RemoveItemFromPocket
    ret

.next
    inc de
    inc de
    jr .loop


; ---------------------------------------------------------------------------
; Step counter management
; ---------------------------------------------------------------------------
; Decrements the remaining step count. Carry is set when the timer expires.
;
; Expected call site: MAPCALLBACK_STEPCYCLE hook in the final Safari Zone map.
JohtoSafari_DecrementStepCounter::
        ld hl, wSafariTimeRemaining
        ld a, [hl]
        and a
        jr z, .borrow
        dec [hl]
        xor a
        ret

.borrow
    ld [hl], $ff
    inc hl
    ld a, [hl]
    and a
    jr z, .time_up
    dec [hl]
    dec hl
    xor a
    ret

.time_up
    dec hl
    ld [hli], a ; low byte already zeroed
    ld [hl], a
    scf
    ret

JohtoSafari_StepWatcherAsm::
    call JohtoSafari_DecrementStepCounter
    jr nc, .keep_going
    ld a, 1
    jr .store_result

.keep_going
    xor a

.store_result
    ld [wScriptVar], a
    ret

; ---------------------------------------------------------------------------
; Battle flow
; ---------------------------------------------------------------------------
JohtoSafariBattleScript::
    loadvar VAR_BATTLETYPE, BATTLETYPE_SAFARI
    randomwildmon
    startbattle
    reloadmapafterbattle
    readmem wSafariBallsRemaining
    iffalse JohtoSafari_OutOfBallsScript
    end

; ---------------------------------------------------------------------------
; Shared termination flow for both timers.
; ---------------------------------------------------------------------------
JohtoSafari_TimeUpScript::
        playsound SFX_ELEVATOR_END
        opentext
        writetext JohtoSafariTimeUpText
        waitbutton
        sjump JohtoSafari_ReturnToGateScript

JohtoSafari_OutOfBallsScript::
        playsound SFX_ELEVATOR_END
        opentext
        writetext JohtoSafariOutOfBallsText
        waitbutton
        sjump JohtoSafari_ReturnToGateScript

; Placeholder warp handler. The final implementation should fade out and warp
; the player back to the Safari Zone entrance map before resetting their party.
JohtoSafari_ReturnToGateScript::
    closetext
    callasm JohtoSafari_ResetBallCount
    warpsound
    warpfacing DOWN, SAFARI_ZONE_GATE_F1, 4, 3
    special RestartMapMusic
    end

; ---------------------------------------------------------------------------
; Draft text stubs
; ---------------------------------------------------------------------------
JohtoSafariTimeUpText:
        text "Your safari timer ran out!"
        line "Let's head back to"
        cont "the entrance."
        done

JohtoSafariOutOfBallsText:
    text "You've used up all"
    line "of the SAFARI BALLS."
    cont "Time to check in."
    done

; ---------------------------------------------------------------------------
; Encounter helpers
; ---------------------------------------------------------------------------
JohtoSafari_ChooseEncounter::
farcall ChooseSafariWildEncounter
    ret

JohtoSafari_TryEncounter::
    farcall TryWildEncounter
    ret nz
    scf
    ret
