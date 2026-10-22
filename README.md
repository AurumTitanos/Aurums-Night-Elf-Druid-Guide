# Aurums Night Elf Druid Guide

My **Night Elf Druid leveling route for World of Warcraft: Forever**, built as a
**guide pack for [Polestar](https://github.com/fitzforge/polestar)**.

> **Everything past level 20 has NOT been tested in game and is best effort.**
> I'm still testing and improving the earlier chapters too, so expect rough edges.

## The route

The guide starts in Teldrassil and works toward level 30, with Druid class quests,
training reminders, travel steps and dungeon trips along the way.

- Suggested **Skinning and Leatherworking** steps, including gathering leather,
  keeping useful materials and crafting during town visits or group waits.
- Cooking and camping-supply reminders.
- **Hall of Thanes (HoT)**, **Ruins of Lordaeron** and **The Deadmines**, with
  quest preparation and hand-ins.
- Later draft chapters covering **Stockades** and **Excavation Site**, alongside
  outdoor questing. These are part of the untested content past level 20.

Bring a group for the dungeon chapters. This is a general leveling route;
professions are suggestions rather than a complete skill-up guide.

## Requirements

Install **[Polestar for WoW Forever](https://github.com/fitzforge/polestar)** and
its required components first. This pack targets **Polestar 0.2.6**; later
versions may need compatibility updates.

My **[Polestar Planner companion](https://github.com/AurumTitanos/Aurums-Polestar-Planner)**
is optional. The guide works without it.

## Download and install

1. [Download the guide-pack ZIP](downloads/PolestarPack_AurumForeverDruid-0.4.37.zip?raw=true).
2. Fully exit WoW, then extract **`PolestarPack_AurumForeverDruid`** into your
   Forever client's **`Interface/AddOns/`** folder. The `.toc` should be directly
   inside that addon folder, without an extra nested folder.
3. Start WoW and enable **Polestar Pack: Aurums Night Elf Druid Guide** alongside
   Polestar.
4. For a new Night Elf Druid, enter **`/polestar guide aurum-druid/start-here`**.
   The first chapter is **01 - Teldrassil and Bear Form**. Enable automatic
   continuation if you'd like the next chapter to load automatically.

Version **0.4.37** is intended for a fresh run. If you're updating an existing
character, back up your addon settings and choose the chapter that matches your
quest log. Progress from older builds may need manual adjustment; you don't need
to delete SavedVariables to install the pack.

**Players only need the ZIP.** The source archive is for editing or rebuilding
the guide, not for installation in WoW.

## Feedback and testing

I'm testing this route as I play and fixing problems along the way. If you find
a mistake, [open an issue](https://github.com/AurumTitanos/Aurums-Night-Elf-Druid-Guide/issues)
with the chapter, step, character level and quest-log objective.

**Everything past level 20 is untested in game and best effort.** All 21 chapters
pass the automated Polestar simulation, but that doesn't verify quest availability,
XP pacing, dungeon difficulty or travel time in game. Beta content may also
change before release. Known warnings and map-data gaps are listed in
[VALIDATION.md](VALIDATION.md).

## Source and license

- [`guides/`](guides/) contains the editable `.guide` files; [`pack.json`](pack.json)
  describes the pack.
- [`PolestarPack_AurumForeverDruid/`](PolestarPack_AurumForeverDruid/) contains the
  Lua files included in the install ZIP.
- [Download the complete build source](downloads/Aurums-Night-Elf-Druid-Guide-0.4.37-source.tar.xz?raw=true)
  for the build scripts, reference data and route-layout migration inputs.
  Rebuild instructions are in `BUILDING.md` inside the archive.
- [`SHA256SUMS`](SHA256SUMS) contains checksums for both downloads.

Released under **GPL-3.0-only**; see [LICENSE](LICENSE).

## Credits

**Thanks to Fitz and the Polestar authors** for Polestar, its authoring tools and
the original GPL-licensed guide material. The Teldrassil, Westfall, Duskwood and
Druid class-quest sections adapt their work. My additions include route changes,
Night Elf Druid filtering, and the dungeon and class-quest trips.

Original attribution and license notices are preserved. See
[THIRD-PARTY-CREDITS.txt](THIRD-PARTY-CREDITS.txt) for details and the
[upstream source revision](https://github.com/fitzforge/polestar/tree/1775eb81e56fc1e127ae869ccec0b7dc8d7092fd).

This is an independent community guide, not an official Polestar release.
World of Warcraft belongs to Blizzard Entertainment; no endorsement is claimed.
