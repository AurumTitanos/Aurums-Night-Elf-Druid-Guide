-- Private guide revision migration. Exact known fingerprints only; stock core is untouched.
local _, pack = ...
local P, data = _G.Polestar, pack.migrationData
local function copy(v)
  if type(v) ~= 'table' then return v end
  local out = {}; for k, item in pairs(v) do out[k] = copy(item) end; return out
end
local function same(a, b)
  if type(a) ~= 'table' or #a ~= #b then return false end
  for i = 1, #b do if a[i] ~= b[i] then return false end end; return true
end
local function matches(shape, keys, expected)
  return expected and shape == expected.shape and same(keys, expected.keys)
end
-- Startup map/log data may be unavailable. Recover an arrival only from
-- positive evidence on this recognized old layout; never defer the migration
-- until after the stock engine has restored its in-memory tabs and pins.
local function arrivedFor(recovery)
  local C = P and P.Compat
  if not (C and type(C.GetPlayerMapPosition) == 'function' and type(C.IsOnQuest) == 'function') then return false end
  local ok, map = pcall(C.GetPlayerMapPosition)
  if not ok or (issecretvalue and issecretvalue(map)) or type(map) ~= 'number' then return false end
  local allowed = false; for _, expected in ipairs(recovery.maps or {}) do if map == expected then allowed = true; break end end
  if not allowed then return false end
  local read, held = pcall(C.IsOnQuest, recovery.quest)
  if not read or (issecretvalue and issecretvalue(held)) or held ~= true then return false end
  -- An active class quest in its home city also describes the outbound trip.
  -- The return crossing needs its completed objective as additional evidence.
  if recovery.ready then
    if type(C.IsQuestReadyForTurnIn) ~= 'function' then return false end
    local checked, ready = pcall(C.IsQuestReadyForTurnIn, recovery.quest)
    if not checked or (issecretvalue and issecretvalue(ready)) or ready ~= true then return false end
  end
  return true
end
local function pastXpBuffer(recovery, pin)
  local ok, level = pcall(function() return UnitLevel and UnitLevel('player') end)
  if not ok or (issecretvalue and issecretvalue(level)) or type(level) ~= 'number' or level < recovery.level then return false end
  if pin and type(pin.step) == 'number' and pin.step >= recovery.fromStep then return true end
  local C = P and P.Compat
  if not (C and type(C.IsQuestCompleted) == 'function') then return false end
  for _, quest in ipairs(recovery.afterQuests) do
    local read, done = pcall(C.IsQuestCompleted, quest)
    if not read or (issecretvalue and issecretvalue(done)) or done ~= true then return false end
  end
  return true
end
local function pastOpening(before)
  if before.pin and type(before.pin.step) == 'number' and before.pin.step > 1 then return true end
  for _, field in ipairs({'manual', 'skipped'}) do
    for key, value in pairs(before[field] or {}) do
      local step = type(key) == 'number' and key or type(key) == 'string' and tonumber(key:match('^(%d+):'))
      if value and step and step > 1 then return true end
    end
  end
  return false
end
local function migrate()
  local s = P.CharState()
  local savedShapes, savedKeys = s.shapes or {}, s.stepKeys or {}
  local tasks, blocked = {}, {}
  for id, rule in pairs(data.guides) do
    local shape, keys = savedShapes[id], savedKeys[id]
    if not matches(shape, keys, rule.new) then
      local found
      for _, candidate in ipairs(rule.historical or {}) do
        if matches(shape, keys, candidate.old) then found = candidate; break end
      end
      if found then tasks[#tasks+1] = { id=id, rule=found }
      elseif shape ~= nil or keys ~= nil or s.manual[id] or s.skipped[id] or (s.pins and s.pins[id]) then blocked[#blocked+1] = id end
    end
  end
  if #blocked > 0 then
    pack.migrationBlocked = true; table.sort(blocked)
    P.Print('Aurum progress preserved: an unknown saved guide layout needs review before the private pack can open: ' .. table.concat(blocked, ', '))
    return
  end
  if #tasks == 0 then return end
  local manual, skipped, pins, shapes, keys = copy(s.manual), copy(s.skipped), copy(s.pins or {}), copy(savedShapes), copy(savedKeys)
  local snapshots, xpBufferRecovered = {}, {}
  -- Clear all changed source rows first, before any reviewed cross-guide move.
  for _, task in ipairs(tasks) do manual[task.id], skipped[task.id], pins[task.id] = nil, nil, nil end
  local function move(field, source, id, rule)
    local function bookMove(key)
      for _, move in ipairs(rule.bookMoves or {}) do if move.from == key then return move end end
    end
    local function put(key, target, value, whole)
      local book = bookMove(key)
      -- A whole old step needed only its required errands; it does not
      -- certify that an optional book was collected. Explicit book ticks do.
      if book and whole and field == manual then return end
      local dest, destKey = id, target
      if type(target) == 'table' then dest, destKey = target.guide, target.key end
      -- Required goals cannot use the engine's optional-goal skip. Preserve
      -- the user's old book dismissal as a skip of its dedicated new step.
      if book and field == skipped then dest, destKey = book.guide, book.step end
      field[dest] = field[dest] or {}; field[dest][destKey] = value
    end
    for k, value in pairs(source or {}) do
      local target = type(k) == 'number' and rule.stepMap[k] or rule.goalMap[k]
      if target then
        put(k, target, value, type(k) == 'number')
      elseif type(k) == 'number' then
        -- A split/moved step preserves only the original goals, never new work.
        local prefix = k .. ':'
        for oldKey, to in pairs(rule.goalMap) do
          if oldKey:sub(1, #prefix) == prefix then
            put(oldKey, to, value, true)
          end
        end
      end
    end
  end
  for _, task in ipairs(tasks) do
    local id, rule = task.id, task.rule
    snapshots[id] = { shape=savedShapes[id], keys=copy(savedKeys[id]), manual=copy(s.manual[id]), skipped=copy(s.skipped[id]), pin=copy(s.pins and s.pins[id]) }
    move(manual, s.manual[id], id, rule); move(skipped, s.skipped[id], id, rule)
    for _, bypass in ipairs(rule.travelBypass or {}) do
      local from = tonumber(bypass.from:match('^(%d+):'))
      local before = snapshots[id]
      if before.manual and (before.manual[bypass.from] or before.manual[from])
        or before.skipped and (before.skipped[bypass.from] or before.skipped[from]) then
        skipped[id] = skipped[id] or {}; skipped[id][bypass.to] = true
      end
    end
    local pin = s.pins and s.pins[id]
    if pin and rule.pinMap[pin.step] then
      pins[id] = { step=rule.pinMap[pin.step], done=pin.done and rule.stepMap[pin.step] ~= nil and not (rule.pinReset and rule.pinReset[pin.step]) or false }
      -- A view pinned in the old fighting loop must not bypass a new level
      -- checkpoint on reload. Keep the original pin in the rollback snapshot.
      local guard = data.guides[id].levelGuard
      local ok, level = pcall(function() return UnitLevel and UnitLevel('player') end)
      if guard and ok and not (issecretvalue and issecretvalue(level)) and type(level) == 'number'
        and level > 0 and level < guard.level and pins[id].step >= guard.step then
        pins[id] = { step=guard.resume, done=false }
      end
    end
    for _, recovery in ipairs(rule.arrivalRecovery or {}) do
      local target = rule.goalMap[recovery.goal]
      if type(target) == 'table' and target.guide == id and type(target.key) == 'string' and arrivedFor(recovery) then
        local targetStep = tonumber(target.key:match('^(%d+):'))
        -- Keep an explicit skip as a skip rather than converting it to a tick.
        if not (skipped[id] and (skipped[id][target.key] or skipped[id][targetStep])) then
          manual[id] = manual[id] or {}; manual[id][target.key] = true
        end
        local sourceStep = tonumber(recovery.goal:match('^(%d+):'))
        if type(recovery.resume) == 'number' and pin and pin.step == sourceStep
          and (not pins[id] or pins[id].step <= recovery.resume) then
          pins[id] = { step=recovery.resume, done=false }
        end
      end
    end
    if rule.addedBindRecovery and pastOpening(snapshots[id]) then
      skipped[id] = skipped[id] or {}
      skipped[id][rule.addedBindRecovery.step] = true
    end
    if rule.xpBufferRecovery and pastXpBuffer(rule.xpBufferRecovery, pin) then
      skipped[id] = skipped[id] or {}
      for _, step in ipairs(rule.xpBufferRecovery.steps) do skipped[id][step] = true end
      xpBufferRecovered[id] = true
    end
    shapes[id], keys[id] = data.guides[id].new.shape, copy(data.guides[id].new.keys)
  end
  -- Cross-guide goals may land in a chapter the character has never opened.
  -- Stamp its destination layout now so stock reconciliation retains them.
  for id, rule in pairs(data.guides) do
    if manual[id] or skipped[id] or pins[id] then
      shapes[id], keys[id] = rule.new.shape, copy(rule.new.keys)
    end
  end
  -- The complete plan is prepared before changing any progress table.
  s.aurumGuideRevisions = s.aurumGuideRevisions or {}
  s.aurumGuideRevisions[data.revision] = s.aurumGuideRevisions[data.revision] or {before=snapshots}
  s.aurumGuideRevisions[data.revision].xpBufferRecovered = xpBufferRecovered
  s.aurumStockMigration = s.aurumStockMigration or {version=data.version,before={}}
  for id, old in pairs(snapshots) do if not s.aurumStockMigration.before[id] then s.aurumStockMigration.before[id] = old end end
  s.manual, s.skipped, s.pins, s.shapes, s.stepKeys = manual, skipped, pins, shapes, keys
end
if not P or type(P.CharState) ~= 'function' or not data or (P.IsLoggedIn and P.IsLoggedIn()) then
  pack.migrationBlocked = true
  if P then P.Print('Restart/reload to load the private Aurum guide revision before guide tabs open.') end
else migrate() end

-- Completed quest flags can arrive after addon loading. Retry only this
-- revision's recognized migrations, once, when the stock engine also reads
-- the quest log. Never infer completion or reopen an old saved layout.
local function recoverXpBuffer()
  if pack.migrationBlocked then return end
  local s = P.CharState()
  local revision = s.aurumGuideRevisions and s.aurumGuideRevisions[data.revision]
  if not revision then return end
  for id, before in pairs(revision.before or {}) do
    local current = data.guides[id]
    if current and not (revision.xpBufferRecovered and revision.xpBufferRecovered[id])
      and matches(s.shapes[id], s.stepKeys[id], current.new) then
      for _, rule in ipairs(current.historical or {}) do
        if rule.xpBufferRecovery and matches(before.shape, before.keys, rule.old)
          and pastXpBuffer(rule.xpBufferRecovery, before.pin) then
          s.skipped[id] = s.skipped[id] or {}
          for _, step in ipairs(rule.xpBufferRecovery.steps) do s.skipped[id][step] = true end
          revision.xpBufferRecovered = revision.xpBufferRecovered or {}
          revision.xpBufferRecovered[id] = true
          break
        end
      end
    end
  end
end
if not pack.migrationBlocked and P and P.RegisterEvent then
  P.RegisterEvent('QUEST_LOG_UPDATE', recoverXpBuffer)
  P.RegisterEvent('PLAYER_ENTERING_WORLD', recoverXpBuffer)
end
