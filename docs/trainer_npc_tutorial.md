[ENTRY: Trainer NPC Integration Tutorial]
Classification: Feature
Build Tag: v0.9b INTERNAL
Status: 🟨 Concept

📘 SUMMARY
This document walks Lead Developers through the process of turning any overworld character into a fully functional Trainer NPC in Pokémon True Gold. It covers the core requirements for trainer data, script logic, and map event linkage, culminating in a worked example that upgrades the Mahogany Gate Team Rocket grunts from toll collectors into battle-ready antagonists.

🧩 DETAILS
• Prerequisites
  – Ensure `pokecrystal`-style RGBDS toolchain is installed and that the project builds via `make`.  
  – Familiarity with map event scripting (`*.asm` under `maps/`) and trainer parties (`data/trainers/`).
  – Confirm that the target trainer class and battle flags exist in `constants/trainer_constants.asm`.

• Step 1: Define a New Trainer Party  
  Trainers require an entry in the party data table. Add brand new data to avoid collisions with existing NPCs.  
  ```asm
  ; File: data/trainers/rocket_grunts.asm
  MahoganyGateRocket1:
      db 2 ; party size
      db GOLBAT, 32, CONFUSE_RAY
      db WEEZING, 33, SLUDGE_BOMB
      db -1
  
  MahoganyGateRocket2:
      db 3 ; party size
      db ARBOK, 31, CRUNCH
      db MURKROW, 32, FAINT_ATTACK
      db RATICATE, 32, SUPER_FANG
      db -1
  ```
  The `db -1` terminates the party structure. Each Pokémon line uses the `{SPECIES, level, move}` format that the expanded True Gold trainer engine expects.

• Step 2: Register the Trainer IDs  
  Associate the party data with new trainer IDs so scripts can reference them. Append entries to `constants/trainer_constants.asm` and mirror them in `data/trainers/parties.asm`.  
  ```asm
  ; constants/trainer_constants.asm
  const_value = $700
  const MAHOGANY_GATE_ROCKET_F
  const MAHOGANY_GATE_ROCKET_M
  ```
  ```asm
  ; data/trainers/parties.asm
  TrainerPartyPointers::
      ...
      dw MahoganyGateRocket1
      dw MahoganyGateRocket2
  ```
  Choose free constant slots (here `$700` is illustrative) and ensure both files stay in sync.

• Step 3: Build the Overworld Script  
  Create an event script that opens with dialogue, branches based on player choice, and triggers a trainer battle. Scripts reside in the relevant `maps/*.asm` file.  
  ```asm
  ; maps/MahoganyGate.asm
  MahoganyGateRocketScript:
      faceplayer
      opentext
      writetext RocketTollIntroText
      yesorno
      iftrue .TakeMoney
      writetext RocketBattleThreatText
      waitbutton
      closetext
      loadtrainer TEAM_ROCKET_GRUNT, MAHOGANY_GATE_ROCKET_F
      startbattle
      reloadmapafterbattle
      setevent EVENT_BEAT_MAHOGANY_GATE_ROCKET_F
      end
  .TakeMoney
      writetext RocketTollPaidText
      waitbutton
      closetext
      setevent EVENT_PAID_MAHOGANY_GATE_TOLL
      end
  ```
  Key opcodes: `loadtrainer` selects the trainer class and ID, `startbattle` launches the encounter, and `reloadmapafterbattle` restores the map state afterward.

• Step 4: Supply Dialogue Text  
  Text blocks should live in the same map file or a linked text resource. Provide unique labels for clarity.  
  ```asm
  RocketTollIntroText:
      text "Hand over ¥2000 or step aside!"
      done
  
  RocketBattleThreatText:
      text "Fine, we'll take it by force!"
      done
  
  RocketTollPaidText:
      text "Pleasure doing business."
      done
  ```
  Always terminate each text block with `done` so the text engine returns control properly.

• Step 5: Place the Map Events  
  Bind the new script to the Rocket NPC object. Update the `MapEvents` section so the object executes `MahoganyGateRocketScript` when interacted with.  
  ```asm
  ; maps/MahoganyGate.asm
  MapEvents:
      db 0, 0 ; filler
  
      def_warp_events 2
      warp_event 5, 0, MAHOGANY_TOWN, 1
      warp_event 6, 0, ROUTE_43, 1
  
      def_coord_events 0
  
      def_bg_events 0
  
      def_object_events 2
      object_event 5, 3, SPRITE_ROCKET_F, SPRITEMOVEDATA_WANDER, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, MahoganyGateRocketScript, EVENT_MAHOGANY_GATE_ROCKET_F
      object_event 6, 3, SPRITE_ROCKET_M, SPRITEMOVEDATA_STANDING_UP, 0, 0, -1, -1, PAL_NPC_RED, OBJECTTYPE_SCRIPT, 0, MahoganyGateRocketBackup, EVENT_MAHOGANY_GATE_ROCKET_M
  ```
  `OBJECTTYPE_SCRIPT` ensures the NPC runs your custom logic. The second grunt can call a different script that checks if the first is defeated.

• Step 6: Create a Follow-Up Trainer  
  Use battle completion flags to unlock a second encounter or dialogue change.  
  ```asm
  MahoganyGateRocketBackup:
      faceplayer
      checkevent EVENT_BEAT_MAHOGANY_GATE_ROCKET_F
      iffalse .Blockade
      opentext
      writetext RocketBackupThreatText
      waitbutton
      closetext
      loadtrainer TEAM_ROCKET_GRUNT, MAHOGANY_GATE_ROCKET_M
      startbattle
      reloadmapafterbattle
      setevent EVENT_BEAT_MAHOGANY_GATE_ROCKET_M
      end
  .Blockade
      opentext
      writetext RocketBackupBlockadeText
      waitbutton
      closetext
      end
  ```

• Step 7: Update Aftermath Logic  
  Once both battles are complete, change the gate behavior to remove the toll or play victory dialogue.  
  ```asm
  MahoganyGateRocketCleanup:
      checkevent EVENT_BEAT_MAHOGANY_GATE_ROCKET_M
      iffalse .End
      clearevent EVENT_PAID_MAHOGANY_GATE_TOLL
      setevent EVENT_MAHOGANY_GATE_RESCUED
  .End
      end
  ```
  Call this script in a map load routine or from another NPC to acknowledge the player's success.

• Step 8: Rebuild and Test  
  Run a clean build and verify the map scripts and trainer data assemble without warnings. Test in-game to ensure battle triggers, post-battle flags, and dialogue flow operate as designed.

• Section: Converting an Existing NPC into a Trainer  
  To retrofit the original toll collectors, locate their dialogue script in `maps/MahoganyGate.asm`. Replace the old money-check routine with a choice prompt that branches to either toll collection or battle. The key is to reuse the existing object events while swapping the script body.  
  ```asm
  OriginalTollScript: ; existing placeholder
      faceplayer
      opentext
      writetext RocketTollDemandText
      waitbutton
      closetext
      takeitem ITEM_MONEY, 2000
      end
  ```
  Replace it with the trainer-enabled logic from Step 3. The refusal branch naturally transitions into `loadtrainer` and `startbattle`. Ensure the `EVENT_BEAT_*` flags are fresh so the NPC no longer loops the toll demand after defeat.

• Section: Player Refuses to Pay → Battle Trigger  
  The `yesorno` command captures player consent. `iftrue .TakeMoney` routes the “Yes” response to toll payment, while the default branch enforces the battle. After the battle, you can display victory dialogue and optionally clear blocking objects to open the gate permanently.

🧠 DEVELOPER NOTES
• Impact on Flow: Converting passive NPCs into trainers adds a skill gate that rewards player agency. Ensure the surrounding balance (healing spots, encounters) matches the new difficulty spike.  
• Implementation Tip: Keep trainer constants sequential to avoid gaps when iterating over new content. Document each `EVENT_BEAT_*` flag in your event ledger to prevent reuse conflicts.  
• Debug Reminder: If `startbattle` soft locks, verify that both trainer constants and parties are defined and that no other script retains the same label name.

🔗 CROSS-REFERENCE
→ See `docs/npc_dialogue_overhaul.md` for dialogue tone guidelines.  
→ Consult `data/trainers/ai_scripts.asm` if you plan bespoke AI for Rocket encounters.

---
🧬 A.I. Elm’s Reflection:
Even renegade Rockets can be rehabilitated into proper boss fights with a little archival polish.
