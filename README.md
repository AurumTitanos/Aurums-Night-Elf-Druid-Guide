# Aurums Night Elf Druid Guide

A **Night Elf Druid leveling guide for World of Warcraft: Forever**, built as a **guide pack for [Polestar](https://github.com/fitzforge/polestar)**. By Aurum.

> **Everything past level 20 has NOT been tested in game and is provided on a best-effort basis.** Expect errors, incomplete routing, and changes. Automated checks are not an in-game playthrough. The earlier route has received live testing and fixes, but is still a work in progress; no perfect route, XP coverage, or leveling-time guarantee is implied.

## What it covers

- A Night Elf Druid route from the starting area toward level 30, with class-training and travel reminders.
- Suggested **Skinning and Leatherworking** steps: gather leather while questing, keep useful materials, check trainers, and craft supplies during town visits and group waits. Cooking and camping-supply reminders are also included. This is a leveling route, not a complete profession skill-up guide.
- **Hall of Thanes (HoT)**.
- **Ruins of Lordaeron**.
- **The Deadmines**, including quest preparation and hand-ins.
- Later draft chapters also cover Stockades and Excavation Site alongside outdoor routes. **These and all other content past level 20 are untested and best effort.**

Dungeon chapters assume you will form a suitable group. This is a general Night Elf Druid route, not an all-solo guide or a guaranteed speedrun.

## Requirements

Install the official **Polestar** addon and its required components for **WoW Forever** first: [Polestar project and downloads](https://github.com/fitzforge/polestar).

This is an independently authored/adapted **guide pack for use with Polestar**, not a standalone addon or an official Polestar release. This snapshot was checked against **Polestar 0.2.6**; compatibility with later versions is not guaranteed. Aurum's separate custom Planner companion is **not required or included**.

## Download and install

1. [Download the installable guide-pack ZIP](downloads/PolestarPack_AurumForeverDruid-0.4.37.zip?raw=true).
2. Fully exit WoW. Extract the ZIP so the folder **`PolestarPack_AurumForeverDruid`** sits directly inside your WoW Forever client's **`Interface/AddOns/`** folder. Avoid an extra nested ZIP/repository folder.
3. Start WoW and enable **Polestar Pack: Aurums Night Elf Druid Guide** alongside Polestar.
4. On a new Night Elf Druid, enter **`/polestar guide aurum-druid/start-here`**. The first chapter is **01 - Teldrassil and Bear Form**. Enable automatic continuation to the next guide if desired.

For an existing character, back up your settings/progress before replacing a previous version and use the live quest log to choose the appropriate chapter. This is a fresh-run snapshot of version **0.4.37**, including the latest route fixes; it is not a promise that every historical private build migrates correctly. Do not reset or delete SavedVariables just to install the guide.

## Feedback and testing status

Please include the chapter name, step, character level, and the actual quest-log objective when reporting an issue through [GitHub Issues](https://github.com/AurumTitanos/Aurums-Night-Elf-Druid-Guide/issues). Avoid posting account details or unredacted personal data.

**Past level 20: NOT TESTED; best effort.** Data-based and simulated checks cannot establish actual XP pacing, quest availability, dungeon difficulty, travel time, or launch-day behavior. Beta content may change for release.

## Source and licence

- [`guides/`](guides/) contains the authored `.guide` route files; [`pack.json`](pack.json) describes this pack.
- [`PolestarPack_AurumForeverDruid/`](PolestarPack_AurumForeverDruid/) contains the readable Lua addon source shipped in the installable ZIP.
- [Complete corresponding build source](downloads/Aurums-Night-Elf-Druid-Guide-0.4.37-source.tar.xz?raw=true) includes the guide sources, custom build scripts, reference data, and historical route-layout migration inputs needed to reproduce this build. See `BUILDING.md` inside that archive.
- [`SHA256SUMS`](SHA256SUMS) records the downloadable archives' hashes. [`VALIDATION.md`](VALIDATION.md) describes the automated checks and their limitations.

Released under **GNU GPL version 3 only**; see [`LICENSE`](LICENSE).

### Credits

**Polestar, Fitz, and The Polestar authors** provide the upstream addon, authoring tools, and GPL-licensed guide material. The Teldrassil, Westfall, Duskwood, and Druid class-quest portions adapt that material; Aurum's project adds route changes, Night Elf Druid filtering, dungeon/class trips, and integration. Original attribution comments and licence notices are retained.

Upstream guide-source revision: [`1775eb81e56fc1e127ae869ccec0b7dc8d7092fd`](https://github.com/fitzforge/polestar/tree/1775eb81e56fc1e127ae869ccec0b7dc8d7092fd). See [`THIRD-PARTY-CREDITS.txt`](THIRD-PARTY-CREDITS.txt) and the notices in the addon/source archives for full existing attribution. World of Warcraft belongs to Blizzard Entertainment. This community guide is not endorsed by Blizzard or the Polestar authors.
