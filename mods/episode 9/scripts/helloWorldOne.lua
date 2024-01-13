function TutorialMod:RenderLineOne()
    Isaac.RenderText("1 Hello world!", 100, 100, 1, 1, 1, 1)
end

TutorialMod:AddCallback(ModCallbacks.MC_POST_RENDER, TutorialMod.RenderLineOne)