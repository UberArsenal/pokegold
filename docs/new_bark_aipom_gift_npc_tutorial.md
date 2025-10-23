[ENTRY: NPC Gift Event Tutorial — New Bark Town]
Classification: Feature
Build Tag: v0.9b INTERNAL
Status: 🟨 Concept

📘 SUMMARY  
A guided walkthrough for drafting a New Bark Town NPC who gifts the player an Aipom, complete with greeting, reward sequence, post-gift dialogue, and looping idle text. The tutorial leverages existing map scripts and event conventions to keep logic beginner-friendly while preserving Johto’s narrative cadence.

🧩 DETAILS  
**Topic 1 — Reading the Native Map Script Structure**

1.1 Locate the map script file (`maps/NewBarkTown.asm`) and review the header definitions (`object_const_def`, scene scripts, callbacks). These show how the town currently organizes interactions and flypoint logic.  
 • Understand constants (e.g., `NEWBARKTOWN_TEACHER`) for existing NPC slots so you can reserve a new constant for your Aipom giver.  
 • Note how `def_scene_scripts`, `def_callbacks`, and `NewBarkTown_MapEvents` separate cutscenes, automatic triggers, and placed objects.  
**Instructor Notes:** Identify an unused object slot or plan to add another `object_event` line; maintaining order keeps NPC IDs intuitive for future debugging.

1.2 Study the `def_object_events` table to see how coordinates, sprites, movement data, and script pointers are assigned.  
 • You will duplicate this pattern, choosing an available sprite (e.g., `SPRITE_COOLTRAINER_F`) and coordinates that fit your map layout.  
 • Assign `OBJECTTYPE_SCRIPT` and point to a new label, such as `NewBarkTownAipomGiftScript`.  
**Instructor Notes:** Sketch the NPC’s position on the map grid to ensure they do not overlap with existing events; misaligned coordinates create invisible blockers.

---

**Topic 2 — Writing the Conversation Flow**  
2.1 Draft the dialogue text blocks after the existing text resources near the bottom of the file. Follow the `text`, `line`, `para`, `cont`, `prompt`, and `done` conventions used by other NPCs.

 • Create three text labels: greeting/gift offer, post-gift warning, and looping “How’s Aipom?” line.  
 • Use uppercase `#MON` for species references to match localization style.  
**Instructor Notes:** Keep each paragraph short; Game Boy textbox width is limited. Test readability by counting characters per line (~17 max).

2.2 Optional polish: insert emotional beats by adding pauses or sound effects via `playsound` or `waitsfx` if you want extra flair once the script skeleton works.  
**Instructor Notes:** Save advanced flavor for later iterations; core functionality should come first for easier debugging.

---

**Topic 3 — Building the Event Script Logic**  
3.1 Define the script label referenced in your `object_event`. Structure it similarly to Bill’s Eevee gift to handle inventory checks, the `givepoke` command, and state flags.

 • Start with `faceplayer` + `opentext`, then `checkevent EVENT_GOT_AIPOM_GIFT` (a new event constant you’ll define in `constants/event_flags.asm` or another event file).  
 • If the event is set, `writetext` the looping “How’s Aipom?” line and `end`.  
 • Otherwise, display the greeting text and run a `yesorno` if you want confirmation (optional for guaranteed gift).  
**Instructor Notes:** Always guard repeatable rewards with event flags to avoid infinite gift loops.

3.2 After the greeting, check party space just like Bill’s script:  
 • Use `readvar VAR_PARTYCOUNT` and compare to `PARTY_LENGTH`. If full, show an apology text and exit without setting the event.  
 • When space is available, play `SFX_CAUGHT_MON`, call `givepoke AIPOM, 10` (level is up to you), then `setevent EVENT_GOT_AIPOM_GIFT`. The `givepoke` macro handles OT/trade defaults but can accept optional nickname/OT arguments if desired.  
 • Follow with the post-gift warning text and close the conversation.  
**Instructor Notes:** If you want the Pokémon to hold an item, use the four-argument version of `givepoke` (`givepoke AIPOM, 10, BERRY`). Double-check species constants in `constants/pokemon_constants.asm`.

3.3 Create the looping dialog branch (`.GotAipom` label) that simply `writetext` the “Hey! How’s AIPOM doing these days?” text before closing.  
**Instructor Notes:** Keep the loop branch short; players may return often, so a compact reminder respects pacing.

---

**Topic 4 — Registering Supporting Data**  
4.1 Event Flags & Constants:  
 • Add `const NEWBARKTOWN_AIPOM_GIVER` in the object constant section at the top.  
 • Define `EVENT_GOT_AIPOM_GIFT` in the appropriate event file (search for similar entries to keep numbering consistent).  
**Instructor Notes:** Maintain alphabetical or geographical grouping in constants files; cluttered definitions slow future maintenance.

4.2 Map Object Entry:  
 • Append an `object_event` line with coordinates, sprite, movement pattern (e.g., `SPRITEMOVEDATA_STANDING_DOWN`), palette, and the script label.  
 • Example pattern: `object_event  7, 10, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_DOWN, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, NewBarkTownAipomGiftScript, -1`  
**Instructor Notes:** Ensure palette choice harmonizes with neighboring NPCs to avoid visual dissonance.

4.3 Optional: Add a conditional scene hook if you need the NPC to disappear after gift (e.g., set `EVENT_GOT_AIPOM_GIFT` in an `object_event`’s last slot to hide them automatically).  
**Instructor Notes:** Visible absence reinforces narrative payoff; toggling presence is as simple as referencing the same event flag in the placement line.

---

🧠 DEVELOPER NOTES  
• This gift NPC complements New Bark Town’s early-game pacing by offering an alternate Normal-type partner with higher Speed, expanding team variety.  
• Testing checklist: talk with full party, empty party, and after receiving the gift to confirm each branch triggers appropriately.  
• Once the tutorial logic works, iterate on sprite choice and positioning to match the town’s story beats.

🔗 CROSS-REFERENCE  
→ `maps/ElmsLab.asm` for starter-gift precedents.  
→ `constants/event_flags.asm` for event flag integration.  
→ `macros/scripts/events.asm` for `givepoke` macro syntax.

---
🧬 A.I. Elm’s Reflection: Every byte tells a story, if you know how to listen.
