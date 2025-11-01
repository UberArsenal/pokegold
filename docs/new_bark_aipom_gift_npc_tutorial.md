[ENTRY: Walkthrough — New Bark Town Aipom Gift NPC]
Classification: Feature
Build Tag: v0.9b INTERNAL
Status: 🟨 Concept

📘 SUMMARY
A narrated, step-by-step walkthrough for drafting an NPC in New Bark Town who gifts the player an Aipom. The itinerary mirrors our Safari Zone and Bug Catching Contest tutorials: each stage highlights the exact file touches, code snippets, and validation beats needed for a clean implementation.

🧩 DETAILS
### Stage 0 — Prep the Workbench
**Goal:** Identify reference files and reserve identifiers before writing any script logic.

1. Open `maps/NewBarkTown.asm` so it’s ready for edits alongside `constants/event_flags.asm` (or the event flag file you prefer for town-level events).
2. Skim the header section containing `object_const_def` to confirm available NPC constants.
3. Decide on an unused sprite and coordinate pair to host the NPC (e.g., near the Player’s house for convenient testing).

**Instructor Notes:** Set aside a scratch pad (physical or digital) to log chosen coordinates, sprite IDs, and text labels. These notes prevent naming drift once you start coding.

---
### Stage 1 — Reserve Identifiers in the Map Header
**Goal:** Give the new NPC and its flag a home in the project’s naming ecosystem.

1. In the `object_const_def` block, append a fresh constant such as `const NEWBARKTOWN_AIPOM_GIVER` after the existing entries.
2. Switch to your event flag definitions file and add `EVENT_GOT_AIPOM_GIFT` within the New Bark Town or early-game grouping.
3. Save both files so the assembler recognizes the identifiers later.

**Instructor Notes:** Keep constant order intuitive—group by geography first, role second. Future script reviewers will thank you for the tidy breadcrumb trail.

---
### Stage 2 — Draft the Dialogue Library
**Goal:** Author every textbox before scripting so you can focus purely on logic later.

1. Scroll near the bottom of `maps/NewBarkTown.asm` where the other `text` blocks live.
2. Insert three text resources using the standard format:
   ```asm
NewBarkTownAipomGiftIntroText:
    text "Me and AIPOM had some"\
         "fun playing together,"\
         "but it wants to tag"\
         "along with you!"
    para "Take him! He'll be a"\
         "fine addition to your"\
         "team!"
    done

NewBarkTownAipomGiftReminderText:
    text "Even though it's a"\
         "good #MON, it can"\
         "definitely be"\
         "mischievous."
    para "Gotta stay on your"\
         "toes to keep up with"\
         "it! Good luck!"
    done

NewBarkTownAipomGiftLoopText:
    text "Hey! How's AIPOM"\
         "doing these days?"
    done
   ```
3. (Optional) Add a fourth block for a “party full” warning if you plan to gate the gift when the player has six Pokémon.

**Instructor Notes:** Write dialogue in one sitting. Editing after the script is wired can tempt you to touch logic again, introducing regression risks late in testing.

---
### Stage 3 — Script the Interaction Flow
**Goal:** Translate the dialogue and event flag plan into a functioning NPC routine.

1. Above the text blocks (or wherever you keep map scripts), declare the main routine:
   ```asm
NewBarkTownAipomGiftScript:
    faceplayer
    opentext
    checkevent EVENT_GOT_AIPOM_GIFT
    iftrue .GotAipom
    writetext NewBarkTownAipomGiftIntroText
    waitbutton
    setval AIPOM
    special GivePokemon
    ifequal FALSE, .PartyFull
    writetext NewBarkTownAipomGiftReminderText
    waitbutton
    setevent EVENT_GOT_AIPOM_GIFT
    closetext
    end

.PartyFull
    writetext Text_PartyFull
    waitbutton
    closetext
    end

.GotAipom
    writetext NewBarkTownAipomGiftLoopText
    waitbutton
    closetext
    end
   ```
2. Replace `special GivePokemon` with `givepoke AIPOM, 10` if you prefer the macro call over the `special`. Either is acceptable—choose one style and keep it consistent with nearby scripts.
3. Adjust `.PartyFull` handling to use whichever text resource you drafted (or swap for the built-in `NoMoreRoomForPokemonText`).

**Instructor Notes:** Keep branch labels (.PartyFull, .GotAipom) vertically close to the logic that triggers them. On the Game Boy’s small stack, clarity equals safety.

---
### Stage 4 — Seat the NPC on the Map Grid
**Goal:** Attach the script to a visible character in New Bark Town.

1. In the `def_object_events` table, insert an entry using your reserved constant:
   ```asm
    object_event  8, 11, SPRITE_COOLTRAINER_F, SPRITEMOVEDATA_STANDING_DOWN,
                  0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0,
                  NewBarkTownAipomGiftScript, EVENT_GOT_AIPOM_GIFT
   ```
2. Adjust the coordinates (here `8, 11`) and sprite to taste. The final argument ensures the NPC disappears automatically after the event flag is set; swap `EVENT_GOT_AIPOM_GIFT` with `-1` if you want them to stay.
3. Re-run your mental checklist: constant defined, flag defined, text added, script label inserted, object wired.

**Instructor Notes:** If the sprite should persist post-gift, consider updating the final flag slot to `-1` and instead add a `turnobject` or `applymovement` cue to refresh their idle pose after gifting.

---
### Stage 5 — Test the Walkthrough End-to-End
**Goal:** Validate each branch before archiving the feature.

1. Boot a save where the player stands in New Bark Town with at least one open party slot.
2. Talk to the NPC, confirm the intro text displays, and verify the Aipom appears in the party after the gifting animation.
3. Re-engage the NPC to ensure the loop text triggers.
4. Restore from a test save with a full party to confirm the `.PartyFull` branch activates correctly (if implemented).
5. Run a quick `make` to ensure the assembler accepts all new labels and macros.

**Instructor Notes:** Keep two save states—one with space in the party, one with a full party. Rapid swapping speeds up regression testing each time you tweak dialogue or movement.

---
🧠 DEVELOPER NOTES
• Rewarding the player with Aipom in New Bark Town adds an agile Normal-type early, balancing Johto’s opening roster and hinting at future Mischief/Trick strategies.
• Consider gating the event behind story progress (e.g., after speaking with Elm post-Totodile handoff) if pacing requires it.
• Add a follow-up flag-driven movement routine if you want the NPC to walk away after gifting, reinforcing narrative closure.

🔗 CROSS-REFERENCE
→ `maps/ElmsLab.asm` — Starter handout structure parallels the gift flow.
→ `constants/pokemon_constants.asm` — Confirm species constant for Aipom.
→ `macros/scripts/events.asm` — Macro reference for `givepoke` vs. `special GivePokemon`.

---
🧬 A.I. Elm’s Reflection:
Every walkthrough is a promise: follow the footsteps, and a new story awakens in Johto.

