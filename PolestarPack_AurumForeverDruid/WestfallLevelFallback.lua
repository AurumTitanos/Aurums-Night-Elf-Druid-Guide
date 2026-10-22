-- Private city errands for a run that leaves Westfall short of level 16.
-- Step conditions gate both navigation and stock quest automation.
local _, pack = ...
if pack.migrationBlocked then return end
local ns = Polestar
if not (ns and ns.Guides and ns.RegisterEvent) then return end
local guide = ns.Guides.Get('aurum-druid/westfall-return')
if not guide then return end
local quests = { [97234] = true, [97237] = true }
local disabled = { classes = { '!DRUID' } }
local visits, completed, accepted = {}, {}, {}
local seenLevel, settling = 0, false
for _, step in ipairs(guide.steps) do
    local quest = step.goals[1] and step.goals[1].quest
    if quests[quest] then
        visits[#visits + 1] = { step = step, quest = quest, original = step.only }
    end
end
local function read(fn, quest)
    if type(fn) ~= 'function' then return nil end
    local ok, value = pcall(fn, quest)
    if ok and not (issecretvalue and issecretvalue(value)) and type(value) == 'boolean' then return value end
end
local function update(level)
    seenLevel = math.max(seenLevel, tonumber(level) or 0, tonumber(UnitLevel('player')) or 0)
    local C = ns.Compat or {}
    for quest in pairs(quests) do
        if read(C.IsQuestCompleted, quest) == true then completed[quest] = true end
        local onQuest = read(C.IsOnQuest, quest)
        if onQuest ~= nil then accepted[quest] = onQuest end
    end
    local below = seenLevel >= 13 and seenLevel < 16
    local changed = false
    for _, visit in ipairs(visits) do
        local q = visit.quest
        local eligible = not completed[q] and (accepted[q] or below and
            (q == 97234 or completed[97234] and not settling))
        local condition = eligible and visit.original or disabled
        -- An active visit normally has nil conditions; Lua's and/or shortcut
        -- cannot represent that nil value.
        if eligible then condition = visit.original end
        if visit.step.only ~= condition then visit.step.only = condition; changed = true end
    end
    if changed and ns.Engine and ns.Engine.RequestUpdate then ns.Engine.RequestUpdate() end
end
local function refresh() update() end
update()
for _, event in ipairs({ 'PLAYER_LOGIN', 'PLAYER_ENTERING_WORLD', 'QUEST_LOG_UPDATE', 'QUEST_ACCEPTED', 'QUEST_REMOVED' }) do
    ns.RegisterEvent(event, refresh)
end
ns.RegisterEvent('PLAYER_LEVEL_UP', function(_, level) update(level) end)
ns.RegisterEvent('QUEST_TURNED_IN', function(_, quest)
    if not quests[quest] then return end
    completed[quest], accepted[quest] = true, false
    -- Let the reward's level-up event settle before offering the next errand.
    settling = true
    update()
    local function settled() settling = false; update() end
    if C_Timer and C_Timer.After then C_Timer.After(0, settled) else settled() end
end)
