function TutorialMod:RenderLineTwo()
    Isaac.RenderText("2 Greetings world!", 100, 115, 1, 1, 1, 1)
end

TutorialMod:AddCallback(ModCallbacks.MC_POST_RENDER, TutorialMod.RenderLineTwo)