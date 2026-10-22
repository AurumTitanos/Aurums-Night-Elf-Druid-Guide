local _, pack = ...
if pack.migrationBlocked then return end
local P = Polestar
local function register()
 if P and P.Nav and P.Nav.RegisterCrossings then P.Nav.RegisterCrossings({ ["crossings"] = { { ["id"] = "aurum-lordamere-swim", ["a"] = { ["map"] = 1416, ["c"] = 0, ["wx"] = 585.3331700000001, ["wy"] = 181.33299999999997, ["r"] = 35 }, ["b"] = { ["map"] = 1420, ["c"] = 0, ["wx"] = 1457.625, ["wy"] = 5.770500000000084, ["r"] = 35 }, ["ab"] = "Swim north through Lordamere Lake in Aquatic Form", ["ba"] = "Swim south through Lordamere Lake in Aquatic Form" } } }) end
end
register()
if P and P.OnLogin then P.OnLogin(register) end
