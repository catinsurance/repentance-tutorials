local mod = RegisterMod("My Mod", 1)
local itemConfig = Isaac.GetItemConfig()

local ITEM_ID = Isaac.GetItemIdByName("Friend Frankie")
local CONFIG_FRANKIE = itemConfig:GetCollectible(ITEM_ID)
local FAMILIAR_VARIANT = Isaac.GetEntityVariantByName("Friend Frankie")
local RNG_SHIFT_INDEX = 35

local SHOOTING_TICK_COOLDOWN = 10
local TEAR_SPEED = 10
local TEAR_SCALE = 0.8
local TEAR_DAMAGE = 3

---@param player EntityPlayer
function mod:EvaluateCache(player)
    local effects = player:GetEffects()
    local count = effects:GetCollectibleEffectNum(ITEM_ID) + player:GetCollectibleNum(ITEM_ID)
    local rng = RNG()
    local seed = math.max(Random(), 1)
    rng:SetSeed(seed, RNG_SHIFT_INDEX)

    player:CheckFamiliar(FAMILIAR_VARIANT, count, rng, CONFIG_FRANKIE)
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.EvaluateCache, CacheFlag.CACHE_FAMILIARS)

---@param familiar EntityFamiliar
function mod:HandleInit(familiar)
    familiar:AddToFollowers()
end

mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, mod.HandleInit, FAMILIAR_VARIANT)

---@param familiar EntityFamiliar
function mod:HandleUpdate(familiar)
    local sprite = familiar:GetSprite()
    local player = familiar.Player

    local fireDirection = player:GetFireDirection()
    local direction
    local shootAnim
    local doFlip = false

    if fireDirection == Direction.LEFT then
        direction = Vector(-1, 0)
        shootAnim = "FloatShootSide"
        doFlip = true
    elseif fireDirection == Direction.RIGHT then
        direction = Vector(1, 0)
        shootAnim = "FloatShootSide"
    elseif fireDirection == Direction.DOWN then
        direction = Vector(0, 1)
        shootAnim = "FloatShootDown"
    elseif fireDirection == Direction.UP then
        direction = Vector(0, -1)
        shootAnim = "FloatShootUp"
    end

    if direction ~= nil and familiar.FireCooldown == 0 then
        local velocity = direction * TEAR_SPEED + player:GetTearMovementInheritance(direction)
        local tear = Isaac.Spawn(
            EntityType.ENTITY_TEAR,
            TearVariant.BLUE,
            0,
            familiar.Position,
            velocity,
            familiar
        ):ToTear()

        tear.Scale = TEAR_SCALE
        tear.CollisionDamage = TEAR_DAMAGE

        familiar.FireCooldown = SHOOTING_TICK_COOLDOWN

        sprite.FlipX = doFlip
        sprite:Play(shootAnim, true)
    end

    if sprite:IsFinished() then
        sprite:Play("FloatDown")
    end

    familiar:FollowParent()
    familiar.FireCooldown = math.max(familiar.FireCooldown - 1, 0)
end

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, mod.HandleUpdate, FAMILIAR_VARIANT)