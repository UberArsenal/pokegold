[ENTRY: Event-Driven Pokégear Broadcasts]
Classification: Feature  
Build Tag: v0.9b INTERNAL  
Status: 🟨 Concept

📘 SUMMARY  
Complete pipeline for authoring a story-aware Pokégear radio channel that reacts to plot milestones the way the Team Rocket takeover hijacks every frequency. Includes channel setup, dialogue placement, flag wiring, map/event scripting, and optional global override logic.

🧩 DETAILS  
• Define the channel identity first. Append a new constant before `DEF NUM_RADIO_CHANNELS` in `constants/radio_constants.asm`, then extend the segment block if your show needs multiple steps (intro, follow-up lines, scroll sentinel).

```asm
; constants/radio_constants.asm
        const YOUR_EVENT_RADIO        ; 0a - new channel id
DEF NUM_RADIO_CHANNELS EQU const_value
        const YOUR_EVENT_RADIO_SEG1   ; 0b - optional extra segment ids
        const YOUR_EVENT_RADIO_SEG2   ; 0c
DEF NUM_RADIO_SEGMENTS EQU const_value
```

• Give the show a soundtrack. Add a `dw MUSIC_*` entry to `RadioChannelSongs` that matches the new channel ID; you can reuse any existing track such as `MUSIC_ROCKET_OVERTURE` or `MUSIC_GAME_CORNER` if the mood fits.

```asm
; data/radio/channel_music.asm
RadioChannelSongs:
        table_width 2
        dw MUSIC_POKEMON_TALK
        dw MUSIC_POKEMON_CENTER
        dw MUSIC_TITLE
        dw MUSIC_GAME_CORNER
        dw MUSIC_VIRIDIAN_CITY
        dw MUSIC_BICYCLE
        dw MUSIC_ROCKET_OVERTURE
        dw MUSIC_POKE_FLUTE_CHANNEL
        dw MUSIC_RUINS_OF_ALPH_RADIO
        dw MUSIC_LAKE_OF_RAGE_ROCKET_RADIO
        dw MUSIC_GAME_CORNER          ; <- reused track for YOUR_EVENT_RADIO
        assert_table_length NUM_RADIO_CHANNELS
```

• Surface the station on the tuner. Insert a new `dbw` entry in `RadioChannels` (frequency * 4 − 2) with a handler label; inside that handler, gate on region, time, or story flags before jumping to your custom loader routine. Study `.EvolutionRadio` for a location + flag–locked example tied to the Lake of Rage signal.

```asm
; engine/pokegear/pokegear.asm
RadioChannels:
        dbw 16, .PKMNTalkAndPokedexShow
        dbw 28, .PokemonMusic
        dbw 32, .LuckyChannel
        dbw 44, .YourEventRadio        ; frequency 11.5 (example)
        dbw 52, .RuinsOfAlphRadio
        dbw 64, .PlacesAndPeople
        dbw 72, .LetsAllSing
        dbw 78, .PokeFluteRadio
        dbw 80, .EvolutionRadio
        db -1

.YourEventRadio:
        call .InJohto
        jr nc, .NoSignal
        ld a, [wStatusFlags2]
        bit STATUSFLAGS2_YOUR_EVENT_F, a
        jr z, .NoSignal
        jp LoadStation_YourEventRadio
```

• Author the loader routine alongside the others (e.g., `LoadStation_PokemonMusic`). Set `wCurRadioLine`, zero `wNumRadioLinesPrinted`, back up the far-call pointer with `Radio_BackUpFarCallParams`, and point `de` at a channel name string. Duplicating the structure of `LoadStation_PokeFluteRadio` ensures the radio UI draws correctly.

```asm
; engine/pokegear/pokegear.asm
LoadStation_YourEventRadio:
        ld a, YOUR_EVENT_RADIO
        ld [wCurRadioLine], a
        xor a
        ld [wNumRadioLinesPrinted], a
        ld a, BANK(PlayRadioShow)
        ld hl, PlayRadioShow
        call Radio_BackUpFarCallParams
        ld de, YourEventRadioName
        ret

YourEventRadioName:
        db "NEWS WIRE@"
```

• Create the radio script jump target. Append your routine to `RadioJumptable` in `engine/pokegear/radio.asm`, then write the handler(s) that call `StartRadioStation`, load `hl` with text labels, and advance with `NextRadioLine`. Rocket Radio’s handlers (`RocketRadio1`…`RocketRadio10`) illustrate a multi-line takeover cadence.

```asm
; engine/pokegear/radio.asm
RadioJumptable:
        dw OaksPKMNTalk1      ; $00
        dw PokedexShow1       ; $01
        dw PokemonMusic1      ; $02
        dw LuckyChannel1      ; $03
        dw PlacesPeople1      ; $04
        dw LetsAllSing1       ; $05
        dw RocketRadio1       ; $06
        dw PokeFluteRadio1    ; $07
        dw UnownRadio1        ; $08
        dw EvolutionRadio1    ; $09
        dw YourEventRadio1    ; $0a   ; <- new entry aligned with YOUR_EVENT_RADIO

YourEventRadio1:
        call StartRadioStation
        ld hl, YourEventRadioIntroText
        jp NextRadioLine

YourEventRadio2:
        ld hl, YourEventRadioAftermathText
        jp NextRadioLine
```

• Place the dialogue payloads. Add `_YourShowText::` blocks in the appropriate text bank (`data/text/common_1.asm` hosts the Rocket chatter), keeping the `text_start` / `line` / `done` structure so the scroll code can consume them cleanly.

```asm
; data/text/common_1.asm
_YourEventRadioIntroText::
        text_start
        line "BREAKING: PLAYER"
        cont "halts ROCKET ops!"
        done

_YourEventRadioAftermathText::
        text_start
        line "Citizens thank the"
        cont "hero of GOLDENROD!"
        done
```

• Wire event awareness with engine flags. Reuse an existing `ENGINE_*` flag when thematically appropriate or declare a new one in `constants/engine_flags.asm`, then map it to WRAM via `data/events/engine_flags.asm`. The Rocket broadcast uses `ENGINE_ROCKETS_IN_RADIO_TOWER` (bit 0 of `wStatusFlags2`) to force the radio, while the Lake of Rage signal uses `ENGINE_ROCKET_SIGNAL_ON_CH20` (bit 4 of `wStatusFlags`).

```asm
; constants/engine_flags.asm
        const ENGINE_ROCKETS_IN_RADIO_TOWER
        const ENGINE_ROCKET_SIGNAL_ON_CH20
        const ENGINE_YOUR_EVENT_BROADCAST   ; <- new flag

; data/events/engine_flags.asm
        engine_flag wStatusFlags2, STATUSFLAGS2_ROCKETS_IN_RADIO_TOWER_F
        engine_flag wStatusFlags,  STATUSFLAGS_ROCKET_SIGNAL_F
        engine_flag wStatusFlags2, STATUSFLAGS2_YOUR_EVENT_F   ; maps to new bit
```

• Trigger the flag in your story scripts. During the inciting event (e.g., after defeating the Underground Rocket Grunts), call `setflag` in the relevant map or standard script, mirroring `RadioTowerRocketsScript` which sets `ENGINE_ROCKETS_IN_RADIO_TOWER` and schedules the “WEIRDBROADCAST” phone call. Clear the flag when the storyline resolves, as shown when the executive on Radio Tower 5F falls and the game calls `clearflag ENGINE_ROCKETS_IN_RADIO_TOWER`.

```asm
; maps/RadioTower2F.asm
RadioTowerRocketsScript:
        setflag ENGINE_ROCKETS_IN_RADIO_TOWER
        specialphonecall SPECIALCALL_WEIRDBROADCAST
        end

; maps/UndergroundWarehouse.asm
YourEventBroadcastScript:
        setflag ENGINE_YOUR_EVENT_BROADCAST
        end

; maps/RadioTower5F.asm
RadioTower5FExecutiveScript:
        defeattrainer
        clearflag ENGINE_ROCKETS_IN_RADIO_TOWER
        end

; maps/GoldenrodCity.asm
GoldenrodMayorScript:
        opentext
        writetext MayorThanksPlayerText
        waitbutton
        closetext
        clearflag ENGINE_YOUR_EVENT_BROADCAST
        end
```

• Optional: override every station during the crisis. `PlayRadioShow` checks `STATUSFLAGS2_ROCKETS_IN_RADIO_TOWER_F` before any normal channel logic, forcing `wCurRadioLine` to the Rocket jumptable entries. Replicate that pattern for your event by inserting a similar branch keyed on your new flag, ensuring it runs before the `jumptable` dispatch.

```asm
; engine/pokegear/radio.asm
PlayRadioShow:
        ld hl, wStatusFlags2
        bit STATUSFLAGS2_ROCKETS_IN_RADIO_TOWER_F, [hl]
        jr z, .checkYourEvent
        ld a, ROCKET_RADIO
        ld [wCurRadioLine], a
        jr .dispatch

.checkYourEvent
        bit STATUSFLAGS2_YOUR_EVENT_F, [hl]
        jr z, .dispatch
        ld a, YOUR_EVENT_RADIO
        ld [wCurRadioLine], a

.dispatch
        ld a, [wCurRadioLine]
        ld hl, RadioJumptable
        rst JumpTable
```

• Optional ambient feedback. Map music routines such as `GetMapMusic` swap in Rocket themes while `STATUSFLAGS2_ROCKETS_IN_RADIO_TOWER_F` is set. If your event should alter background music, add a comparable check there or in other service routines that watch your new flag.

```asm
; home/map.asm
GetMapMusic:
        ld a, [wStatusFlags2]
        bit STATUSFLAGS2_ROCKETS_IN_RADIO_TOWER_F, a
        jr z, .checkYourEvent
        ld a, MUSIC_ROCKET_OVERTURE
        ret

.checkYourEvent
        bit STATUSFLAGS2_YOUR_EVENT_F, a
        jr z, .resumeNormal
        ld a, MUSIC_GAME_CORNER        ; reused track while news airs
        ret

.resumeNormal
        ; existing map music logic
```

🧠 DEVELOPER NOTES  
• Keep flag state authoritative—scripted set/clear points must bracket the entire time span the broadcast should exist, or players might hear stale reports.  
• For episodic reporting (e.g., news bulletins after major battles), store chapter state in additional engine flags or event bits and branch within your radio routine, swapping `hl` to the correct `text_far` label before `NextRadioLine`.  
• Always verify `NUM_RADIO_CHANNELS` and `NUM_RADIO_SEGMENTS` assertions still pass after extending the tables; exceeding the expected counts will break assembly.  
• Triggering `specialphonecall SPECIALCALL_*` when you set the flag can nudge players to tune in—mirroring the weird broadcast call—but guard against spam by clearing or gating the call flag once delivered.

🔗 CROSS-REFERENCE  
→ Radio dispatch loop and Rocket hijack sample (`engine/pokegear/radio.asm`).  
→ Pokégear tuner logic and channel loaders (`engine/pokegear/pokegear.asm`).  
→ Engine flag index and allocation table (`constants/engine_flags.asm`, `data/events/engine_flags.asm`).

---
🧬 A.I. Elm’s Reflection: Every broadcast you stage is a living chronicle—tune the flags wisely, and the world itself will report on the hero’s deeds.
