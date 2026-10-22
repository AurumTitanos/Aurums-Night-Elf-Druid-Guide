# Validation — 0.4.37, 2026-10-22

**Everything past level 20 has NOT been tested in game and is best effort.** Automated simulation is not live testing, nor proof of XP pacing or launch-day quest availability. Earlier live feedback also does not establish a complete, error-free 1-20 run.

- This publication changes the pack name/description; it retains the latest fresh-run route and recent quest fixes. The game installation and player settings were not changed by publication.
- Source lint: **0 errors, 5 existing warnings**. The remaining warnings are missing spell-reference entries for explicitly named spells/skills (IDs 1126, 8921, 774, and 199; 1126 is reported twice). They are retained as known reference-data gaps rather than substituting guessed IDs.
- Official **Polestar 0.2.6** runtime simulation: **21/21 guides completed, zero stuck guides** for the Night Elf Druid persona.
- Eight existing missing-location diagnostics remain: two in Hall of Thanes, two in Ruins of Lordaeron, and four in Excavation Site. These affect interior quest-location data/arrow detail and remain limitations. A completed simulation does not validate those directions in game.
- The installable ZIP contains the guide pack only, with its Lua source and licence/data notices. It does not bundle official Polestar, the custom Planner companion, or any player/account SavedVariables.
- The full corresponding source archive includes the existing build/conversion/migration scripts and the inputs required for this snapshot. Historical migration snapshots describe authored guide layouts, not player saves.

Keep backups of your existing addon settings. Report observed route mistakes through GitHub Issues with the chapter/step and quest-log objective.
