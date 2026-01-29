⚠️IMPORTANT (Read This First)

This is for Arcane Odyssey: Game made by Vetex
MAKE SURE YOU HAVE YOUR FISHING ROD YOU WANT TO USE EQUIPPED ON SLOT 0
This script taps 0 to unequip / re-equip your rod during resets, so slot 0 must be your rod.
Keep your mouse positioned where the red exclamation mark appears

What This Script Does ------------
This AutoHotkey v2 script helps you auto-fish by:
Detecting the red exclamation mark (fish on hook)
Spam-clicking to fight/reel the fish
Auto-resetting the rod if something gets stuck (no fish caught for a while / rod not casted)

  Tracking stats in a GUI:
    Fish caught (loops)
    Failsafe resets
    Elapsed time




- Fully Tunable - (You Can Adjust Everything)

All the behavior is controlled by variables at the top of the script.
You can tune speed and timing for your PC/game latency.

  Key tuning examples:
    FightMs → how long it spam-clicks after red is detected
    ClickDelayMs → click speed during fight
    NoRedResetMs → how long without seeing red before it does a failsafe reset
    RecastClicks / RecastClickGapMs → how many times it tries to cast again + spacing
  
  For the Giant Bait version:
    MenuLeadInMs / MenuTapMs / MenuGapMs / MenuTailMs control the slow “human tap” menu sequence.

Auto Reset / Failsafe Feature
If the script doesn’t detect red for a set amount of time, it assumes something went wrong (examples: no fish, rod wasn’t casted, animation glitch).
Then it will:
  Tap 0 (unequip)
  Tap 0 again (re-equip)
  Left click to re-cast (tries multiple times)
  This keeps the bot from “stalling out.”




Two Script Versions
There are two versions:

1) Default

For normal fishing only.

2) Giant Bait

  Includes an extra “human-tap” key sequence after each fish:
  \ → Right → Up → Enter → \
  This is intentionally delayed so the game actually registers it.
  Make sure you run the version that matches your fishing method.

Controls / Hotkeys
P = Start
O = Stop
M = Exit

Use the GUI Start/Stop buttons if you prefer.





Requirements

AutoHotkey v2.0
Rod equipped on slot 0
Keep your mouse positioned where the red exclamation mark appears (as instructed by your setup)
Tips:
  If inputs feel too fast/slow, tune the variables at the top.
  If the game ignores inputs, try running AHK as Administrator.


For more information, visit
https://discord.gg/WMHtAq67
Property of Azalea Guild · Made by Daniel
