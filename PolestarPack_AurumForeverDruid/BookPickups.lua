local _, pack = ...
pack.bookQuests = { [203754] = 79091, [203755] = 79092, [208860] = 79093, [209845] = 78142, [209848] = 78146, [209849] = 78147 }
pack.bookGuides = { "aurum-druid/westfall-return", "aurum-druid/westfall-deadmines", "aurum-druid/future-pickups", "aurum-druid/excavation-site", "aurum-druid/duskwood-finale" }
-- Private book stops: bags satisfy collection through the stock engine.
-- A positively confirmed one-time hand-in makes recollection unnecessary.
local _, pack = ...
if pack.migrationBlocked then return end
local ns = Polestar
if not (ns and ns.Guides and ns.RegisterEvent and pack.bookQuests) then return end
local handedIn, knownQuests = {}, {}
for _, quest in pairs(pack.bookQuests) do knownQuests[quest] = true end

local function update()
    local C = ns.Compat
    if C and type(C.IsQuestCompleted) == 'function' then
        for quest in pairs(knownQuests) do
            local ok, done = pcall(C.IsQuestCompleted, quest)
            if ok and not (issecretvalue and issecretvalue(done)) and done == true then handedIn[quest] = true end
        end
    end
    for _, guideId in ipairs(pack.bookGuides) do
        local guide = ns.Guides.Get(guideId)
        if guide then
            for _, step in ipairs(guide.steps) do
                for _, goal in ipairs(step.goals) do
                    local quest = goal.t == 'collect' and not goal.quest and pack.bookQuests[goal.item]
                    if quest then goal.optional = handedIn[quest] == true end
                end
            end
        end
    end
end

update()
ns.RegisterEvent('PLAYER_LOGIN', update)
ns.RegisterEvent('PLAYER_ENTERING_WORLD', update)
ns.RegisterEvent('QUEST_LOG_UPDATE', update)
ns.RegisterEvent('QUEST_TURNED_IN', function(_, quest)
    if knownQuests[quest] then handedIn[quest] = true; update() end
end)
