local mod = RegisterMod("My Mod", 1)
local sfx = SFXManager()
local music = MusicManager()

local SOUND_GORP = Isaac.GetSoundIdByName("Gorp")
local MUSIC_CHOCOBO = Isaac.GetMusicIdByName("Chocobo")

function mod:PlaySoundsOnHotkey()
    -- Play sound
    if Input.IsButtonTriggered(Keyboard.KEY_T, 0) then
        sfx:Play(SOUND_GORP)
    end

    -- Play music
    if Input.IsButtonTriggered(Keyboard.KEY_G, 0) then
        music:Crossfade(MUSIC_CHOCOBO)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.PlaySoundsOnHotkey)