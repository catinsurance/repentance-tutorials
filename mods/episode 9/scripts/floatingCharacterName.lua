---@param player EntityPlayer
function TutorialMod:RenderHoveringText(player)
    local position = Isaac.WorldToScreen(player.Position) + Vector(-15, -45)
    Isaac.RenderText(player:GetName(), position.X, position.Y, 1, 1, 1, 1)
end

TutorialMod:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, TutorialMod.RenderHoveringText)