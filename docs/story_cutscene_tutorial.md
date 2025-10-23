# Story Cutscene Building Tutorial

> *Prepared for the Pokémon True Gold development team as a friendly walkthrough on orchestrating narrative set pieces inside the disassembly.*

## Table of Contents
1. [What Counts as a Story Cutscene?](#what-counts-as-a-story-cutscene)
2. [How the Script Engine Executes Events](#how-the-script-engine-executes-events)
3. [Registers, Memory, and the `ld` Family of Instructions](#registers-memory-and-the-ld-family-of-instructions)
4. [Preparing a Map to Host a Cutscene](#preparing-a-map-to-host-a-cutscene)
5. [Controlling Flow with Scene IDs and Flags](#controlling-flow-with-scene-ids-and-flags)
6. [Core Script Commands You Will Use Constantly](#core-script-commands-you-will-use-constantly)
7. [Animating Characters with Movement Data](#animating-characters-with-movement-data)
8. [Displaying Dialogue and UI Prompts](#displaying-dialogue-and-ui-prompts)
9. [Calling Special Routines and Audio Control](#calling-special-routines-and-audio-control)
10. [Step-by-Step: Recreating the New Bark Escort](#step-by-step-recreating-the-new-bark-escort)
11. [Testing, Debugging, and Iteration Tips](#testing-debugging-and-iteration-tips)

---

## What Counts as a Story Cutscene?
A *story cutscene* is any scripted sequence where player control is paused so that characters, camera, or UI perform a choreographed narrative beat. In this disassembly, cutscenes are driven by **map scripts** that fire when conditions such as coordinates, story flags, or callbacks are met. The example in `maps/NewBarkTown.asm` where the teacher escorts the player home is a canonical cutscene triggered by stepping on a coordinate gate while a particular scene ID is active.【F:maps/NewBarkTown.asm†L6-L46】【F:maps/NewBarkTown.asm†L312-L325】

Cutscenes combine three ingredients:
- **Scene/controller setup** (map headers, callbacks, and triggers)
- **Script commands** (the instruction stream executed by the script engine)
- **Supporting data** (movement lists, text resources, and flags)

Understanding how these pieces interlock will let you design new sequences confidently.

---

## How the Script Engine Executes Events
When a cutscene begins, the engine enters *script mode* by writing a mode constant into `wScriptMode`, a byte in WRAM reserved for controlling how scripts advance.【F:engine/overworld/scripting.asm†L3-L18】【F:ram/wram.asm†L2230-L2238】 The main loop fetches the current mode, looks up the handler in a jump table, and either reads the next command, waits for movement, or delays for timers. This dispatch table lives at `ScriptCommandTable`, where every command ID points to a routine such as `Script_opentext` or `Script_applymovement`.【F:engine/overworld/scripting.asm†L58-L200】

Each script command is ultimately a small ASM routine that interprets bytes from the script stream. For example, `Script_applymovement` pulls an object ID into register `c`, copies the movement pointer into `hl`, and loads the bank into `b` before calling `GetMovementData`. If the data indicates a movement is in progress, it swaps the mode to `SCRIPT_WAIT_MOVEMENT` so the loop waits until animations finish.【F:engine/overworld/scripting.asm†L747-L773】

The upshot: you write readable macros like `applymovement` in map files, but the engine translates them into raw bytes that these routines interpret frame by frame.

---

## Registers, Memory, and the `ld` Family of Instructions
Cutscene scripts rely heavily on the Game Boy CPU’s load (`ld`) instruction to shuttle values between registers and memory. A few key examples taken straight from the script engine:

- `ld a, SCRIPT_READ` loads the constant `SCRIPT_READ` into register `a`, preparing the mode byte that tells the engine to keep reading commands.【F:engine/overworld/scripting.asm†L3-L8】
- `ld [wScriptMode], a` stores whatever is currently in register `a` into the WRAM variable `wScriptMode`, changing how the engine behaves on the next loop.【F:engine/overworld/scripting.asm†L3-L18】
- `ld c, a` copies the object ID pulled from the script stream into register `c`, which many routines use as the active object index.【F:engine/overworld/scripting.asm†L747-L751】
- `ld l, a` / `ld h, a` successively fill the low and high bytes of the `hl` register pair with the pointer to movement data that the command just read.【F:engine/overworld/scripting.asm†L761-L764】
- `ld b, a` moves the current script bank into `b` so the engine can fetch data across banks without losing context.【F:engine/overworld/scripting.asm†L765-L768】

Whenever you see macros expand to multiple bytes, remember that the runtime code will use `ld` to copy those bytes into working registers. Explaining this to new scripters demystifies how constants, object IDs, and pointers travel through the engine.

---

## Preparing a Map to Host a Cutscene
Every map script file begins by defining object constants, scene scripts, callbacks, and event tables using macros declared in `macros/scripts/maps.asm`. These macros not only reserve space but also export symbolic constants such as `SCENE_NEWBARKTOWN_TEACHER_STOPS_YOU` so you can test or switch scenes easily.【F:maps/NewBarkTown.asm†L1-L24】【F:macros/scripts/maps.asm†L12-L83】

Key setup steps:
1. **Define scene scripts** with `def_scene_scripts` and `scene_script`. Each entry points to the top-level routine that should run when a scene ID is active.【F:maps/NewBarkTown.asm†L6-L18】【F:macros/scripts/maps.asm†L12-L36】
2. **Register callbacks** that should run on map load or step counts using `def_callbacks` / `callback`. This is how the map ensures the fly point flag is set as soon as the player visits.【F:maps/NewBarkTown.asm†L20-L23】【F:macros/scripts/maps.asm†L38-L49】
3. **Create trigger zones** with `def_coord_events` and `coord_event`. The New Bark teacher cutscene listens for the player stepping on `(1,8)` or `(1,9)` while the introductory scene is active.【F:maps/NewBarkTown.asm†L312-L314】【F:macros/scripts/maps.asm†L67-L83】
4. **List NPC objects** via `def_object_events` and `object_event`, specifying sprite, movement pattern, palette, script, and optional appearance flag.【F:maps/NewBarkTown.asm†L322-L325】【F:macros/scripts/maps.asm†L101-L134】

With this infrastructure in place, your cutscene script will have actors to control and a deterministic way to trigger.

---

## Controlling Flow with Scene IDs and Flags
Two families of flags govern whether a cutscene should start:

- **Event flags (`EVENT_*`)** persist across maps and track story milestones. You set or clear them using commands like `setevent` or `clearevent`. The teacher script checks story progress by reading `EVENT_GOT_A_POKEMON_FROM_ELM`, `EVENT_GAVE_MYSTERY_EGG_TO_ELM`, and other milestones defined in `constants/event_flags.asm`.【F:maps/NewBarkTown.asm†L75-L102】【F:constants/event_flags.asm†L3-L120】
- **Engine flags (`ENGINE_*`)** live in different WRAM bitfields and often toggle system-wide features like fly points. The callback sets `ENGINE_FLYPOINT_NEW_BARK` once you visit town so Fly can target the location later.【F:maps/NewBarkTown.asm†L20-L23】【F:constants/engine_flags.asm†L64-L112】

Scene IDs offer finer control within the map itself. Commands like `setscene` and `setmapscene` change which `scene_script` slot should run next time the map loads. In Elm’s Lab, finishing the starter selection explicitly switches New Bark Town to its neutral scene so you cannot retrigger the escort sequence later.【F:maps/NewBarkTown.asm†L6-L18】【F:maps/ElmsLab.asm†L236-L236】

When documenting or designing a cutscene, list the exact flags and scenes you intend to manipulate. This prevents soft-locks caused by forgotten `setscene` calls or mutually exclusive events.

---

## Core Script Commands You Will Use Constantly
Under the hood, each script macro emits a command byte defined in `macros/scripts/events.asm`. Knowing the basic vocabulary lets you reason about sequences and debug with the disassembly tools.

| Macro | What it Expands To | Beginner Explanation |
| --- | --- | --- |
| `opentext` / `closetext` | Command IDs `$47`/`$49`, handled by `Script_opentext` and `Script_closetext` | Opens and closes the standard dialogue box so no other input happens while the box is visible.【F:engine/overworld/scripting.asm†L138-L151】 |
| `writetext SomeLabel` | Command `$4c` with a pointer to your text | Feeds the engine the address of text you defined elsewhere so it can stream characters to the dialogue box.【F:engine/overworld/scripting.asm†L142-L150】 |
| `waitbutton` | Command `$53` | Pauses until the player presses A or B, ensuring they read the message before the script continues.【F:engine/overworld/scripting.asm†L148-L151】 |
| `playmusic MUSIC_MOM` | Command `$7e` | Switches the BGM to the specified track so the cutscene has its own score.【F:engine/overworld/scripting.asm†L193-L200】 |
| `applymovement Object, MovementList` | Command `$68` plus arguments | Freezes other NPCs, loads the movement pointer, and sets the engine to wait until the animation finishes.【F:engine/overworld/scripting.asm†L747-L773】 |
| `follow Leader, Follower` / `stopfollow` | Commands `$6f`/`$70` | Locks two objects together so one automatically tracks the other until you stop it.【F:engine/overworld/scripting.asm†L178-L180】 |
| `special RestartMapMusic` | Command `$0f` referencing the specials table | Calls into a predefined ASM routine; in this case it restarts whatever map BGM should be playing.【F:macros/scripts/events.asm†L98-L102】【F:home/audio.asm†L366-L395】 |

Because each macro ultimately becomes bytecode, you can interleave them freely to choreograph dialogue, movement, and effects. If you ever need to call a custom ASM helper, hook it into the specials table and invoke it with `special` for readability.

---

## Animating Characters with Movement Data
Movement lists are just byte sequences built from macros in `macros/scripts/movement.asm`. In the teacher escort example, the movement `step LEFT` expands to a direction opcode, and `step_end` terminates the sequence. These macros abstract away the actual bit patterns (e.g., `$0c` for a normal step) so you can write expressive choreography.【F:maps/NewBarkTown.asm†L148-L180】【F:macros/scripts/movement.asm†L1-L126】

Useful movement macros to keep at hand:
- `step <DIR>`: Walks one tile in the specified direction (`UP`, `DOWN`, `LEFT`, `RIGHT`).
- `turn_head <DIR>`: Rotates the sprite without moving, perfect for reaction shots.
- `jump_step <DIR>`: Hops one tile with a bounce effect, great for shoves or leaps.【F:maps/NewBarkTown.asm†L186-L191】【F:macros/scripts/movement.asm†L61-L74】【F:macros/scripts/movement.asm†L166-L198】
- `fix_facing` / `remove_fixed_facing`: Temporarily locks the sprite’s orientation so forced movement doesn’t auto-turn.【F:maps/NewBarkTown.asm†L186-L191】【F:macros/scripts/movement.asm†L89-L107】

Remember to end every movement list with `step_end`; otherwise the interpreter will read into unrelated data and crash or glitch.【F:maps/NewBarkTown.asm†L148-L196】【F:macros/scripts/movement.asm†L122-L126】

---

## Displaying Dialogue and UI Prompts
Dialogue lines come from labeled text blocks that use macros in `macros/scripts/text.asm`. The `text` macro starts a new message, `line` and `para` control formatting, and `done` or `prompt` tell the engine how to close the box. The teacher’s reminders are plain examples of how these commands render multi-line dialogue.【F:maps/NewBarkTown.asm†L197-L302】【F:macros/scripts/text.asm†L1-L32】

The flow is always:
1. `opentext`
2. `writetext` referencing your label
3. Formatting inside the label (`line`, `para`, etc.)
4. `waitbutton` or `prompt`
5. `closetext`

Because text commands are data, you can reuse them across scripts simply by pointing another `writetext` to the same label.

---

## Calling Special Routines and Audio Control
Many memorable moments hinge on camera shakes, sound effects, or game-state tweaks that exceed a single command. The specials system bridges scripts with bespoke ASM routines. `special RestartMapMusic`, for instance, jumps into `RestartMapMusic::` in the audio engine, briefly silences playback, and then reloads the current map track so the BGM feels seamless after dialogue.【F:macros/scripts/events.asm†L98-L102】【F:home/audio.asm†L366-L395】

You can add your own helper by appending it to `data/events/special_pointers.asm` and writing the routine in an appropriate bank. From the script’s perspective, it is just another `special` call.

For more dynamic beats, mix in:
- `playmusic` to swap background music.
- `playsound` / `waitsfx` for one-off sound effects.
- `earthquake` or `showemote` to emphasize events (see additional command handlers in the script table).【F:engine/overworld/scripting.asm†L178-L200】

---

## Step-by-Step: Recreating the New Bark Escort
Use this walkthrough as a template for your own story beats.

1. **Declare actors and scenes.** Add object constants and the `scene_script` entries. The escort needs `NEWBARKTOWN_TEACHER` plus a scene ID reserved for the gate check.【F:maps/NewBarkTown.asm†L1-L10】
2. **Set map arrival behavior.** The `MAPCALLBACK_NEWMAP` callback sets the fly flag the first time the player enters town.【F:maps/NewBarkTown.asm†L20-L23】
3. **Place coordinate triggers.** Two adjacent tiles reference `NewBarkTown_TeacherStopsYouScene1` and `_Scene2`, so walking onto either launches the script.【F:maps/NewBarkTown.asm†L312-L314】
4. **Script the encounter.** Inside the scene scripts, chain together dialogue, facing commands, `applymovement` sequences, and the `follow`/`stopfollow` pair to shepherd the player home.【F:maps/NewBarkTown.asm†L25-L70】
5. **Author movement data.** Define labeled movement lists that mirror the actual path you want the NPC to take. The teacher’s list simply walks left four steps, then guides the player back to the lab.【F:maps/NewBarkTown.asm†L148-L180】
6. **Write dialogue text.** Provide the text labels the script references so there is always readable output.【F:maps/NewBarkTown.asm†L197-L302】
7. **Reset the atmosphere.** Finish by calling `special RestartMapMusic` to restore the field BGM after the lecture.【F:maps/NewBarkTown.asm†L41-L45】

Swap in your own actors, movements, and dialogue to build new vignettes. The structure stays identical, which keeps maintenance and debugging predictable.

---

## Testing, Debugging, and Iteration Tips
- **Verify flag flow.** Before finalizing, confirm that each `setevent`, `clearevent`, or `setscene` is matched with the intended story beat to avoid dangling triggers.【F:maps/NewBarkTown.asm†L75-L102】【F:maps/ElmsLab.asm†L236-L236】
- **Watch register usage in custom ASM.** When writing new specials, push/pop registers you modify, imitating routines like `RestartMapMusic` that preserve the CPU state with `push`/`pop` pairs around `ld` instructions.【F:home/audio.asm†L366-L395】
- **Check movement termination.** If an NPC freezes, confirm every movement list ends with `step_end` so `GetMovementData` knows when to resume command processing.【F:maps/NewBarkTown.asm†L148-L196】【F:engine/overworld/scripting.asm†L767-L773】
- **Leverage script mode.** If you need the player frozen during multi-part sequences, ensure your commands leave the engine in `SCRIPT_WAIT_MOVEMENT` or use timers so the mode doesn’t revert to reading too soon.【F:engine/overworld/scripting.asm†L747-L773】

With these diagnostics and the foundational knowledge above, crafting new story cutscenes becomes a matter of mixing dialogue, movement, and flag choreography until the sequence matches your narrative vision.

---

*End of tutorial — ready for archival in the True Gold Developer Codex.*
