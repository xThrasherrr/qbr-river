local keys = { ['G'] = 0x760A9C6F, ['S'] = 0xD27782E3, ['W'] = 0x8FD015D8, ['H'] = 0x24978A28, ['G'] = 0x5415BE48, ["ENTER"] = 0xC7B5340A, ['E'] = 0xDFF812F9,["BACKSPACE"] = 0x156F7119 }
local WaterTypes = {
    [1] =  {["name"] = "Sea of Coronado",       ["waterhash"] = -247856387, ["watertype"] = "lake"},
    [2] =  {["name"] = "San Luis River",        ["waterhash"] = -1504425495, ["watertype"] = "river"},
    [3] =  {["name"] = "Lake Don Julio",        ["waterhash"] = -1369817450, ["watertype"] = "lake"},
    [4] =  {["name"] = "Flat Iron Lake",        ["waterhash"] = -1356490953, ["watertype"] = "lake"},
    [5] =  {["name"] = "Upper Montana River",   ["waterhash"] = -1781130443, ["watertype"] = "river"},
    [6] =  {["name"] = "Owanjila",              ["waterhash"] = -1300497193, ["watertype"] = "lake"},
    [7] =  {["name"] = "Hawks Eye Creek",       ["waterhash"] = -1276586360, ["watertype"] = "creek"},
    [8] =  {["name"] = "Little Creek River",    ["waterhash"] = -1410384421, ["watertype"] = "river"},
    [9] =  {["name"] = "Dakota River",          ["waterhash"] = 370072007, ["watertype"] = "river"},
    [10] =  {["name"] = "Beartooth Beck",       ["waterhash"] = 650214731, ["watertype"] = "river"},
    [11] =  {["name"] = "Lake Isabella",        ["waterhash"] = 592454541, ["watertype"] = "lake"},
    [12] =  {["name"] = "Cattail Pond",         ["waterhash"] = -804804953, ["watertype"] = "pond"},
    [13] =  {["name"] = "Deadboot Creek",       ["waterhash"] = 1245451421, ["watertype"] = "creek"},
    [14] =  {["name"] = "Spider Gorge",         ["waterhash"] = -218679770, ["watertype"] = "creek"},
    [15] =  {["name"] = "O'Creagh's Run",       ["waterhash"] = -1817904483, ["watertype"] = "lake"},
    [16] =  {["name"] = "Moonstone Pond",       ["waterhash"] = -811730579, ["watertype"] = "pond"},
    [17] =  {["name"] = "Kamassa River",        ["waterhash"] = -1229593481, ["watertype"] = "river"},
    [18] =  {["name"] = "Elysian Pool",         ["waterhash"] = -105598602, ["watertype"] = "lake"},
    [19] =  {["name"] = "Heartland Overflow",   ["waterhash"] = 1755369577, ["watertype"] = "lake"},
    [20] =  {["name"] = "Bayou NWA",            ["waterhash"] = -557290573, ["watertype"] = "swamp"},
    [21] =  {["name"] = "Lannahechee River",    ["waterhash"] = -2040708515, ["watertype"] = "river"},
    [22] =  {["name"] = "Calmut Ravine",        ["waterhash"] = 231313522, ["watertype"] = "lake"},
    [23] =  {["name"] = "Ringneck Creek",       ["waterhash"] = 2005774838, ["watertype"] = "creek"},
    [24] =  {["name"] = "Stillwater Creek",     ["waterhash"] = -1287619521, ["watertype"] = "creek"},
    [25] =  {["name"] = "Lower Montana River",  ["waterhash"] = -1308233316, ["watertype"] = "river"},
    [26] =  {["name"] = "Aurora Basin",         ["waterhash"] = -196675805, ["watertype"] = "lake"},
    [27] =  {["name"] = "Arroyo De La Vibora",  ["waterhash"] = -49694339, ["watertype"] = "river"},
    [28] =  {["name"] = "Whinyard Strait",      ["waterhash"] = -261541730, ["watertype"] = "creek"},
    [29] =  {["name"] = "Hot Springs",          ["waterhash"] = 1175365009, ["watertype"] = "pond"},
    [30] =  {["name"] = "Barrow Lagoon",        ["waterhash"] = 795414694, ["watertype"] = "lake"},
    [31] =  {["name"] = "Dewberry Creek",       ["waterhash"] = 469159176, ["watertype"] = "creek"},
    [32] =  {["name"] = "Cairn Lake",           ["waterhash"] = -1073312073, ["watertype"] = "pond"},
    [33] =  {["name"] = "Mattlock Pond",        ["waterhash"] = 301094150, ["watertype"] = "pond"},
    [34] =  {["name"] = "Southfield Flats",     ["waterhash"] = -823661292, ["watertype"] = "pond"},
    --[35] =  {["name"] = "Bahia De La Paz",      ["waterhash"] = -1168459546, ["watertype"] = "ocean"}, -- Disabled Ocean Water
}
local WashOff = false
local DrinkWater = false

--menu

local function RemoveOptions()
    if DrinkWater and WashOff then
        exports['qbr-radialmenu']:RemoveOption(WashOff)
        exports['qbr-radialmenu']:RemoveOption(DrinkWater)
        WashOff = nil
        DrinkWater = nil
    end
end

local function AddOptions()
    if not DrinkWater and not WashOff then
        DrinkWater = exports['qbr-radialmenu']:AddOption({
            id = 'drink',
            title = 'Drink Water',
            icon = 'water',
            type = 'client',
            event = 'qbr-river:Drink',
            shouldClose = true
        })
        WashOff = exports['qbr-radialmenu']:AddOption({
            id = 'wash',
            title = 'Wash Off',
            icon = 'soap',
            type = 'client',
            event = 'qbr-river:Wash',
            shouldClose = true
        })
    end
end

CreateThread(function()
	while true do
		Wait(1)
        local coords = GetEntityCoords(PlayerPedId())
        local Water = Citizen.InvokeNative(0x5BA7A68A346A5A91,coords.x+3, coords.y+3, coords.z)
        local playerPed = PlayerPedId()
        for k,v in pairs(WaterTypes) do 
            if Water == WaterTypes[k]["waterhash"]  then
                if IsPedOnFoot(PlayerPedId()) then
                    if IsEntityInWater(PlayerPedId()) then
                        AddOptions()
                    else
                        RemoveOptions()
                    end
                end   
            end
        end
    end
end)

RegisterNetEvent('qbr-river:Wash', function()
    StartWash("amb_misc@world_human_wash_face_bucket@ground@male_a@idle_d", "idle_l")
end)

RegisterNetEvent('qbr-river:Drink', function()
    local playerPed = PlayerPedId()
    Wait(0)
    ClearPedTasksImmediately(PlayerPedId())
    TaskStartScenarioInPlace(playerPed, GetHashKey('WORLD_HUMAN_BUCKET_DRINK_GROUND'), -1, true, false, false, false)
    Wait(17000)
    TriggerServerEvent("QBCore:Server:SetMetaData", "thirst", exports['qbr-core']:GetPlayerData().metadata["thirst"] + 30)
    ClearPedTasks(PlayerPedId())
end)

StartWash = function(dic, anim)
    LoadAnim(dic)
    TaskPlayAnim(PlayerPedId(), dic, anim, 1.0, 8.0, 5000, 0, 0.0, false, false, false)
    Wait(5000)
    ClearPedTasks(PlayerPedId())
    Citizen.InvokeNative(0x6585D955A68452A5, PlayerPedId())
    Citizen.InvokeNative(0x9C720776DAA43E7E, PlayerPedId())
    Citizen.InvokeNative(0x8FE22675A5A45817, PlayerPedId())
end

LoadAnim = function(dic)
    RequestAnimDict(dic)

    while not (HasAnimDictLoaded(dic)) do
        Wait(0)
    end
end

function whenKeyJustPressed(key)
    if Citizen.InvokeNative(0x580417101DDB492F, 0, key) then
        return true
    else
        return false
    end
end
