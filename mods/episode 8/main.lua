local mod = RegisterMod("My Mod", 1)

local RAIN_CLOUD_VARIANT = Isaac.GetEntityVariantByName("Sad Rain Cloud")

function mod:OnRainCloudInit(cloud)
    local player = Isaac.GetPlayer(0)

    cloud.SpriteOffset = Vector(0, -20)

    cloud.Position = player.Position
    cloud:FollowParent(player)
end

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, mod.OnRainCloudInit, RAIN_CLOUD_VARIANT)