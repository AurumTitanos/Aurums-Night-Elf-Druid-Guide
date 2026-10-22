# Testing status — 0.4.37

Checked **2026-10-22** with **Polestar 0.2.6**.

**Everything past level 20 has NOT been tested in game and is best effort.**
I'm testing the earlier chapters as I play; a complete 1–20 run has not yet
been validated either.

## Automated checks

- Source lint: **0 errors, 5 warnings**. The reference data is missing entries
  for explicitly named spells/skills: 1126, 8921, 774 and 199. Spell 1126 is
  reported twice.
- Runtime simulation: **21/21 chapters completed, zero stuck guides**, using
  a Night Elf Druid test character.
- Eight missing-location diagnostics remain: two in Hall of Thanes, two in
  Ruins of Lordaeron and four in Excavation Site. Interior directions and
  arrow detail in those locations still need checking in game.

Passing simulation doesn't establish real XP pacing, quest availability,
dungeon difficulty or launch-day behavior. Report problems through
[GitHub Issues](https://github.com/AurumTitanos/Aurums-Night-Elf-Druid-Guide/issues)
with the chapter, step and quest-log objective.

## Downloads

The install ZIP contains the guide pack, readable Lua and license/data notices.
Install Polestar separately; the Planner companion is optional.

The source archive includes the scripts and inputs needed to rebuild 0.4.37.
Historical migration inputs describe guide layouts, not character saves.
