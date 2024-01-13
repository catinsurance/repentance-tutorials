function TutorialMod:RenderLineThree()
    Isaac.RenderText("3 Salutations world!", 100, 130, 1, 1, 1, 1)
end

TutorialMod:AddCallback(ModCallbacks.MC_POST_RENDER, TutorialMod.RenderLineThree)