
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
        ret

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
        ld [hl], 0
        dec hl
        ld [hl], 0
        scf
        ret

; Bridges the step counter to the scripting engine. Returns 1 in wScriptVar
; when the player has exhausted their step quota.
JohtoSafari_StepWatcherAsm::
        call JohtoSafari_DecrementStepCounter
        jr nc, .okay
        ld a, 1
        jr .store

.okay
        xor a

.store
        ld [wScriptVar], a
        ret

; ---------------------------------------------------------------------------
; Ball tracking helper
; ---------------------------------------------------------------------------
; Simple routine to restore the default Safari Ball inventory. This mirrors how
; the Bug Catching Contest replenishes Park Balls each attempt.
JohtoSafari_ResetBallCount::
        ld a, JOHTO_SAFARI_MAX_BALLS
        ld [wSafariBallsRemaining], a
        ret

; ---------------------------------------------------------------------------
; Encounter script (draft)
; ---------------------------------------------------------------------------
; This closely mirrors BugCatchingContestBattleScript, minus the contest rank
; logic. Once a Safari-specific battle mode exists, replace the placeholder
; battle type below.
JohtoSafariBattleScript::
        loadvar VAR_BATTLETYPE, BATTLETYPE_SAFARI ; TODO: dedicated Safari rules
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
        clearflag ENGINE_SAFARI_ZONE
        ; TODO: Define warp back to the Safari Zone entrance gate.
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
