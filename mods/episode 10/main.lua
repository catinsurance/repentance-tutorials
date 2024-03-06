local mod = RegisterMod("My Mod", 1)

local ID = Isaac.GetEntityTypeByName("Level 2 Roundy")
local game = Game()

local BULLET_SPEED = 6

---@param roundy EntityNPC
function mod:RoundyInit(roundy)
    roundy:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK)
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, mod.RoundyInit, ID)

---@param roundy EntityNPC
function mod:RoundyUpdate(roundy)
    local sprite = roundy:GetSprite()
    local target = roundy:GetPlayerTarget()

    if roundy.State == NpcState.STATE_INIT then
        if sprite:IsFinished("Appear") then
            roundy.State = NpcState.STATE_MOVE
            sprite:Play("DigIn")
        end
    end

    if roundy.State == NpcState.STATE_MOVE then
        if sprite:IsFinished("DigIn") then
            local room = game:GetRoom()
            local newPosition = room:GetRandomPosition(roundy.Size)
            roundy.Position = newPosition
            sprite:Play("DigOut")
            roundy.State = NpcState.STATE_ATTACK
        end
    end

    if roundy.State == NpcState.STATE_ATTACK then
        if sprite:IsEventTriggered("Shoot") then
            local params = ProjectileParams()
            params.BulletFlags = ProjectileFlags.SMART

            local velocity = (target.Position - roundy.Position):Normalized() * BULLET_SPEED

            roundy:FireProjectiles(roundy.Position, velocity, 0, params)
        end

        if sprite:IsFinished("DigOut") then
            roundy:Kill()
            local shockwave = Isaac.Spawn(
                EntityType.ENTITY_EFFECT,
                EffectVariant.SHOCKWAVE,
                0,
                roundy.Position,
                Vector.Zero,
                roundy
            )

            shockwave.Parent = roundy
        end
    end
end

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.RoundyUpdate, ID)