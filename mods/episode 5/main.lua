local mod = RegisterMod("Tutorial Mod", 1)

local POLLEN_ITEM_ID = Isaac.GetItemIdByName("Pollen")
local POLLEN_POISON_CHANCE = 0.4
local POLLEN_POISON_LENGTH = 3
local ONE_INTERVAL_OF_POISON = 20

local game = Game()

function mod:PollenNewRoom()
    local playerCount = game:GetNumPlayers()

    for playerIndex = 0, playerCount - 1 do
        local player = Isaac.GetPlayer(playerIndex)
        local copyCount = player:GetCollectibleNum(POLLEN_ITEM_ID)

        if copyCount > 0 then
            local rng = player:GetCollectibleRNG(POLLEN_ITEM_ID)

            local entities = Isaac.GetRoomEntities()
            for _, entity in ipairs(entities) do
                if entity:IsActiveEnemy() and entity:IsVulnerableEnemy() then
                    if rng:RandomFloat() < POLLEN_POISON_CHANCE then
                        entity:AddPoison(
                            EntityRef(player),
                            POLLEN_POISON_LENGTH + (ONE_INTERVAL_OF_POISON * copyCount),
                            player.Damage
                        )
                    end
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.PollenNewRoom)