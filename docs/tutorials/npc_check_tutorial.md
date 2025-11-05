# NPC Check Systems in Pokémon True Gold

## Overview
This guide explores how scripted non-player characters (NPCs) can inspect the player's progress or inventory in Pokémon True Gold. We will review the core script commands used to check for items, Pokémon species, Pokégear phone numbers, and badge-related events. Along the way, we will construct complete examples that you can adapt for Johto's towns and routes.

## Key Script Commands

### Item Checks with `checkitem`
The `checkitem` command loads an item ID from the script, places it into `wCurItem`, and calls `CheckItem` to see whether the player has the item in their Bag. The result is stored in `wScriptVar` so that later branches can react accordingly.【F:engine/overworld/scripting.asm†L1630-L1643】

### Pokémon Party Checks with `checkpoke`
`checkpoke` reads a species ID and scans the player's party (`wPartySpecies`) using `IsInArray`. It sets `wScriptVar` to `TRUE` when the requested Pokémon is present, enabling species-gated NPC dialogue.【F:engine/overworld/scripting.asm†L1740-L1752】

### Badge and Story Flag Checks with `checkevent` and `checkflag`
Badges and many story milestones are tracked as events (engine flags). Both `checkevent` and `checkflag` pull a 16-bit flag ID, call `EventFlagAction`, and report whether the bit is set via `wScriptVar`. Badges typically use named constants such as `EVENT_BEAT_FALKNER`, so you can gate NPC dialogue or rewards behind Gym victories.【F:engine/overworld/scripting.asm†L1866-L1889】

### Coin Case and Money Checks
`checkmoney` compares the player's money (or Mom's savings) to a scripted value and writes `HAVE_LESS`, `HAVE_AMOUNT`, or `HAVE_MORE` to `wScriptVar`. `checkcoins` works similarly for Game Corner coins. Combine these with `if_equal` or `if_greater_than` to steer your NPC logic.【F:engine/overworld/scripting.asm†L1660-L1695】【F:engine/overworld/scripting.asm†L1696-L1710】

## Building an NPC Inspection Flow

### Step 1: Reserve Script Variables
Most checks only return a boolean in `wScriptVar`. Plan your script so that each decision reads that value before issuing more commands. A typical pattern is `checkitem` followed by `iffalse` or `iftrue` jumps.

### Step 2: Provide Feedback Paths
Always script both success and failure branches. Players should understand why an NPC blocks progress and what requirement they are missing.

### Step 3: Reset Temporary Flags
If you set temporary events or flags during the interaction, be sure to clear them later. This prevents the NPC from repeating rewards or incorrectly blocking the player after requirements are met.

## Example Scripts

### Goldenrod Underground – Gate Guard (Item Check)
```asm
GoldenrodUnderground_GateGuardScript:
    faceplayer
    opentext
    checkitem BASEMENT_KEY
    iftrue .unlockWarehouse
    writetext GoldenrodUnderground_GateGuardNeedKeyText
    waitbutton
    closetext
    end
.unlockWarehouse
    writetext GoldenrodUnderground_GateGuardOpenText
    playsound SFX_UNLOCK_DOOR
    waitbutton
    closetext
    setevent EVENT_GOLDENROD_UNDERGROUND_WAREHOUSE_BLOCKED_OFF
    end
```
*What is happening?* The guard checks for the Basement Key and sets a map event to open the warehouse once the item is confirmed.【F:maps/GoldenrodUnderground.asm†L374-L388】

### Route 29 Ranger – Pokémon Species Check
```asm
Route29_RangerScript:
    faceplayer
    opentext
    checkpoke CHIKORITA
    iftrue .botanyLesson
    writetext Route29_RangerNoGrassStarterText
    waitbutton
    closetext
    end
.botanyLesson
    writetext Route29_RangerBotanyLessonText
    special GiveMysterySeedReward
    waitbutton
    closetext
    end
```
*What is happening?* This brand new script awards a custom `special` routine when the player travels with Chikorita. Use `special` to hand off to a custom function (for example, giving a held item or triggering a cutscene).

### Azalea Town Artisan – Badge Check via Event
```asm
AzaleaTown_ArtisanScript:
    faceplayer
    opentext
    checkevent EVENT_BEAT_BUGSY
    iffalse .needsHiveBadge
    writetext AzaleaTown_ArtisanCongratsText
    verbosegiveitem SILVERPOWDER
    waitbutton
    closetext
    setevent EVENT_GOT_SILVERPOWDER_FROM_ARTISAN
    end
.needsHiveBadge
    writetext AzaleaTown_ArtisanBadgeReminderText
    waitbutton
    closetext
    end
```
*What is happening?* After verifying the Hive Badge event, the artisan gives out SilverPowder and flags the reward so it cannot be repeated. Replace the text constants with actual entries in your `text` block, and define the new event in your map’s object list.

### Mahogany Gate Toll – Money and Coin Check Combo
```asm
MahoganyGate_TollScript:
    faceplayer
    opentext
    writetext MahoganyGate_TollIntroText
    waitbutton
    checkmoney YOUR_MONEY, 0, 5, 0 ; checks for 500 Pokéyen
    if_equal HAVE_LESS, .offerCoinOption
    writetext MahoganyGate_PaidWithCashText
    takemoney YOUR_MONEY, 0, 5, 0
    waitsfx
    closetext
    end
.offerCoinOption
    writetext MahoganyGate_CoinCaseOfferText
    yesorno
    iffalse .cannotPass
    checkitem COIN_CASE
    iffalse .noCoinCase
    checkcoins 0, 2 ; requires 200 coins
    if_equal HAVE_LESS, .notEnoughCoins
    takecoins 0, 2
    writetext MahoganyGate_PaidWithCoinsText
    waitbutton
    closetext
    end
.noCoinCase
    writetext MahoganyGate_NoCoinCaseText
    waitbutton
    closetext
    end
.notEnoughCoins
    writetext MahoganyGate_NotEnoughCoinsText
    waitbutton
    closetext
    end
.cannotPass
    writetext MahoganyGate_CannotPassText
    waitbutton
    closetext
    end
```
*What is happening?* The toll guard first attempts to charge the player in Pokéyen, then falls back to a Coin Case payment if cash is insufficient. This demonstrates nested checks and multiple currency types.

## Beginner-Friendly Explanation of the Engine Helpers

- **`GetScriptByte`** pulls the next byte from the running script, allowing commands to read arguments directly from the script data.【F:engine/overworld/scripting.asm†L1602-L1636】
- **`ReceiveItem`** and **`TossItem`** interact with the player’s bag; `checkitem` leverages `CheckItem` to query without modifying inventory.【F:engine/overworld/scripting.asm†L1602-L1656】
- **`EventFlagAction`** is the core routine that reads or writes story flags. When `checkevent` calls it with `CHECK_FLAG`, the carry flag signals success, which is mirrored into `wScriptVar` for script-level branching.【F:engine/overworld/scripting.asm†L1866-L1889】
- **`IsInArray`** looks through the party’s species list byte by byte, making `checkpoke` quick and lightweight. You do not have to loop manually in your script—just feed the desired species constant.【F:engine/overworld/scripting.asm†L1740-L1752】

## Putting It All Together
By chaining `checkitem`, `checkpoke`, and `checkevent`, you can author NPCs who respond dynamically to the player's journey. Remember to:

1. **Read `wScriptVar` immediately** after each check, since the next command may overwrite it.
2. **Set or clear events** when rewarding the player to prevent repetition.
3. **Communicate requirements** through NPC text so players understand gating logic.

With these tools, every gatekeeper, mentor, and artisan across Johto can feel responsive to the player’s progress.

---
Compiled for the True Gold Developer Codex.
