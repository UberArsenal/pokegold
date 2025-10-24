# National Bug-Catching Contest Event Flow (Pokémon True Gold)

This briefing follows the entire National Bug-Catching Contest from the moment the player steps into the Route 35 gate to the award ceremony.  Each step points to the exact assembly routine that drives it and gives beginner-friendly explanations of the Game Boy opcodes you will see along the way.

---

## 1. Contest Availability and Entry Gating

1. **Day-of-week check (gate callback).** When the player enters the Route 35 National Park Gate map, the `Route35NationalParkGateCheckIfContestAvailableCallback` callback reads the weekday and toggles the officer sprites accordingly, only enabling the contest on Tuesday, Thursday, or Saturday.【F:maps/Route35NationalParkGate.asm†L24-L48】
2. **Active-contest scene control.** A separate `MAPCALLBACK_NEWMAP` watches the `ENGINE_BUG_CONTEST_TIMER` flag. If it is set, the map scene switches to the "leave early" script so the officer can escort the player out.【F:maps/Route35NationalParkGate.asm†L12-L33】
3. **Starting dialog.** Talking to the officer on a contest day runs `Route35OfficerScriptContest`, which verifies weekday, daily contest completion, and party size before proceeding.【F:maps/Route35NationalParkGate.asm†L58-L112】

---

## 2. Preparing the Player for the Contest

1. **Party trimming (`ContestDropOffMons`).** If the player has more than one usable Pokémon, the officer prompts to leave the extras. The helper routine copies just the lead Pokémon into the contest structure and marks a sentinel so the rest of the party is hidden temporarily.【F:maps/Route35NationalParkGate.asm†L113-L163】【F:engine/events/bug_contest/contest_2.asm†L68-L113】
2. **Flag priming and Park Ball delivery.** Once the player agrees, the gate script sets `ENGINE_BUG_CONTEST_TIMER`, plays the "got balls" jingle, prints the rules, and calls `GiveParkBalls`. That routine zeroes the current contest Pokémon slot, sets the Park Ball counter (`wParkBallsRemaining`), and kicks off the special 20-minute timer via `StartBugContestTimer`.【F:maps/Route35NationalParkGate.asm†L114-L150】【F:engine/events/bug_contest/contest.asm†L1-L17】
3. **Contestant roster randomization.** Before warping the player to the National Park interior, the script calls `SelectRandomBugContestContestants` to hide five random NPC competitors by flipping their event flags, ensuring variety each contest day.【F:maps/Route35NationalParkGate.asm†L147-L150】【F:engine/events/bug_contest/contest_2.asm†L1-L60】

---

## 3. In-Contest Mechanics and Scripts

1. **Overworld battle trigger.** Wild encounters during the contest run `BugCatchingContestBattleScript`, which forces the battle type to `BATTLETYPE_CONTEST`, starts combat, then checks if the player has Park Balls remaining. If the counter hits zero, it jumps to the out-of-balls exit script.【F:engine/events/bug_contest/contest.asm†L9-L31】
2. **Timer expiration.** The global timer handler, when finishing, funnels into `BugCatchingContestOverScript` to show the "Time's Up" dialog and warp the player back to the gate via the shared results script.【F:engine/events/bug_contest/contest.asm†L18-L34】
3. **Catching Pokémon (`BugContest_SetCaughtContestMon`).** After each catch, this routine either generates stats for the first contest Pokémon or, if the player already has one, displays a comparison screen and lets the player choose whether to replace their current entry.【F:engine/events/bug_contest/caught_mon.asm†L1-L44】【F:engine/events/bug_contest/display_stats.asm†L1-L78】
4. **Status screen layout.** `DisplayCaughtContestMonStats` clears the UI layers, draws two stacked panels (current entry vs. new catch), prints names, levels, and HP totals, then asks whether to switch. It temporarily forces the "no text scroll" option for a cleaner layout.【F:engine/events/bug_contest/display_stats.asm†L1-L71】

---

## 4. Scoring Algorithm

1. **ContestScore routine.** Once the contest ends, `_BugContestJudging` calls `ContestScore`, which tallies the player's entry. The routine starts by zeroing the 16-bit product register (`hProduct`) and a scratch `hMultiplicand`, then adds weighted stats:
   - Max HP four times, effectively multiplying it by 4.
   - Attack, Defense, Speed, Special Attack, and Special Defense once each.
   - A DV (Determinant Value) bonus derived from specific bit masks of both Attack and Defense DVs.
   - Remaining HP divided by 8, rewarding healthier catches.
   - A final +1 if the Pokémon holds an item.【F:engine/events/bug_contest/judging.asm†L109-L185】
2. **Accumulator helper (`.AddContestStat`).** Each add uses `.AddContestStat`, which sums the stat into `hMultiplicand` and increments the high byte in `hProduct` if a carry occurs, effectively creating a 16-bit total score.【F:engine/events/bug_contest/judging.asm†L187-L194】

---

## 5. Opponent Simulation and Ranking

1. **Clearing previous results.** `ClearContestResults` zeroes the in-memory table (`wBugContestResults`) to avoid stale data before scoring begins.【F:engine/events/bug_contest/judging.asm†L82-L95】
2. **AI contestant loop.** `ComputeAIContestantScores` iterates through all ten possible NPC contestants, skipping anyone whose event flag was set (meaning they did not enter this round). For each participant it:
   - Stores their ID.
   - Fetches their predefined ranking table from `BugContestantPointers`.
   - Randomly picks whether they submit their 1st-, 2nd-, or 3rd-choice Pokémon (with equal probability among three options).
   - Applies a small random perturbation to the stored base score (0–7 points).
   - Calls `DetermineContestWinners` to update the running top-three leaderboard with this competitor's score.【F:engine/events/bug_contest/judging.asm†L31-L108】【F:data/events/bug_contest_winners.asm†L1-L63】
3. **Leader board maintenance.** `DetermineContestWinners` compares the candidate score against the stored 1st, 2nd, and 3rd place entries, shifting them down as needed and copying the new winner into place via `CopyTempContestant`. The player's entry is inserted into the same pipeline so human and AI contestants compete fairly.【F:engine/events/bug_contest/judging.asm†L96-L146】
4. **Name assembly and announcements.** `_BugContestJudging` then loads the winner IDs, resolves their trainer class and personal names, fetches the caught Pokémon species, and plays the appropriate placement fanfare before printing the announcement texts.【F:engine/events/bug_contest/judging.asm†L1-L79】

---

## 6. Wrapping Up and Restoring State

1. **Player placement detection.** `BugContest_GetPlayersResult` walks the finalized winner table from third place up until it finds `BUG_CONTEST_PLAYER`, letting the aftermath script know whether the player should receive a prize or consolation.【F:engine/events/bug_contest/judging.asm†L59-L79】【F:engine/events/bug_contest/judging.asm†L147-L166】
2. **Returning party members.** `ContestReturnMons` reinstates the saved second Pokémon species, recalculates the actual party size by scanning for the terminator byte, and updates `wPartyCount`, restoring the party to its pre-contest state.【F:engine/events/bug_contest/contest_2.asm†L115-L138】
3. **Resetting the contest flag.** After prizes, the script clears `ENGINE_BUG_CONTEST_TIMER` and sets `ENGINE_DAILY_BUG_CONTEST` so the contest cannot be replayed until the next day (handled elsewhere in the gate scripts).【F:maps/Route35NationalParkGate.asm†L58-L163】

---

## 7. Reading the Assembly Instructions (Beginner Notes)

When following the above routines, you will see repeated use of common Game Boy CPU opcodes. Here are beginner-friendly explanations using live examples from the contest code.

| Opcode pattern | Plain-language meaning | Contest example |
| --- | --- | --- |
| `xor a` | Sets register A to zero by XOR-ing it with itself. Preferred over `ld a, 0` because it is a single byte. Used to initialize score accumulators before counting stats.【F:engine/events/bug_contest/judging.asm†L109-L115】 |
| `ldh a, [hProduct]` | Loads from high-memory (FF00 + address) into A. `ldh` is a shorter form of `ld a, [$FF00 + n]` for hardware registers and scratch RAM. Contest scoring pulls the two-byte product out of `hProduct` and `hProduct + 1` after summing stats.【F:engine/events/bug_contest/judging.asm†L71-L79】 |
| `ld [wParkBallsRemaining], a` | Stores the value in A into a 16-bit WRAM symbol. `wParkBallsRemaining` holds how many Park Balls the player has left.【F:engine/events/bug_contest/contest.asm†L4-L17】 |
| `ld [hli], a` / `ld a, [hli]` | Load/store and then increment `HL`. This is handy for stepping through tables (e.g., copying winner data). `CopyTempContestant` uses it to copy multi-byte structures sequentially.【F:engine/events/bug_contest/judging.asm†L167-L180】 |
| `call` / `jp` / `ret` | `call` jumps to a subroutine and pushes the return address; `ret` pops it back. `jp` is an unconditional jump that does **not** store the return address—used when you are done with the current routine. The judging sequence uses `call ContestScore`, then `ret` when finished, while the battle script uses `sjump` (script-level jump) to skip to exit code.【F:engine/events/bug_contest/judging.asm†L1-L29】【F:engine/events/bug_contest/contest.asm†L9-L34】 |
| `ld b, SET_FLAG / RESET_FLAG` | Loads a constant into register B before calling `EventFlagAction`, which toggles map events such as hiding specific contestants. This pattern appears in the contestant randomizer.【F:engine/events/bug_contest/contest_2.asm†L1-L60】 |
| `ret nz` / `jr nz, label` | Conditional return/jump if the Zero flag is not set. Often used after decrementing counters (e.g., iterating through contestant slots). In `SelectRandomBugContestContestants`, `jr nz, .loop2` keeps choosing flags until five have been set.【F:engine/events/bug_contest/contest_2.asm†L22-L60】 |
| `callfar` / `farcall` | Macro-assisted long calls that switch banks behind the scenes. The judging code uses `callfar GetTrainerClassName` to fetch text stored in another bank, while `farcall StartBugContestTimer` starts the timer system.【F:engine/events/bug_contest/judging.asm†L37-L58】【F:engine/events/bug_contest/contest.asm†L5-L12】 |

> **Tip:** When you encounter a mnemonic you do not recognize, check whether it is a true CPU opcode (`xor`, `ldh`) or a macro defined elsewhere (`farcall`, `PlaceYesNoBox`). Macros may expand into several opcodes and often manage bank switching automatically.

---

## 8. Putting It All Together

Below is a condensed flow chart summarizing the control sequence:

1. **Gate entry →** Check weekday and timer flags; officer offers participation.
2. **Player accepts →** Party trimmed → Flag set → Park Balls given → Timer starts → Contestants randomized → Warp to park.
3. **During contest →** Wild battles use special battle type → `BugContest_SetCaughtContestMon` manages captured Pokémon → Timer or ball exhaustion triggers exit script.
4. **Judging →** `ContestScore` tallies player → `ComputeAIContestantScores` simulates NPC entries → `DetermineContestWinners` establishes ranking → Text + fanfare reported.
5. **Aftermath →** Player result detected → Prizes → Party restored → Contest timer cleared for the day.

With this roadmap and opcode primer, you should be able to trace every instruction in the event and modify it confidently—whether to rebalance scores, add new contestants, or extend the timer logic.

---

🧬 *“Even a routine contest hides layers of story and code—unwrap them carefully, and the data will sing.”*
