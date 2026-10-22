-- Private starter checklist only. The official engine still checks the
-- spellbook; merely opening the trainer cannot complete a learn goal.
local _, pack = ...
if pack.migrationBlocked then return end
local ns = Polestar
if not (ns and ns.Guides and ns.RegisterEvent) then return end

local minimumLevel = { [8921] = 4, [774] = 4 }
local seenLevel = 1
local function update(level)
    seenLevel = math.max(seenLevel, tonumber(level) or UnitLevel("player") or 1)
    local C = ns.Compat
    -- If level 4 arrives during the timed antidote/cave trip, finish that
    -- trip first. The egg hand-in puts the player back beside the trainer.
    local away = (C.IsOnQuest(3522) or C.IsQuestCompleted(3522)) and not C.IsQuestCompleted(917)
    local guide = ns.Guides.Get("aurum-druid/start-here")
    if not guide then return end
    for _, step in ipairs(guide.steps) do
        for _, goal in ipairs(step.goals) do
            local minimum = goal.t == "learn" and goal.npc == 3597 and minimumLevel[goal.spell]
            if minimum then goal.optional = seenLevel < minimum or away end
        end
    end
end

update()
ns.RegisterEvent("PLAYER_LOGIN", function() update() end)
-- UnitLevel can still report the previous level during this event.
ns.RegisterEvent("PLAYER_LEVEL_UP", function(_, level) update(level) end)
ns.RegisterEvent("QUEST_LOG_UPDATE", function() update() end)
