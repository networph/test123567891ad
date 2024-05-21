-- Create the PlaySound library
local PlaySound = {}

-- Predefined sound sequence
PlaySound.First = "3333907347,8679627751"

-- Function to play a single sound
function PlaySound:playSound(Id, Volume, Pitch)
    -- Create a new Sound object
    local sound = Instance.new("Sound", game:GetService("SoundService"))
    local pitchSound = Instance.new("PitchShiftSoundEffect", sound)
    
    -- Set the Sound object's properties
    sound.SoundId = "rbxassetid://" .. Id
    sound.Volume = Volume
    pitchSound.Octave = Pitch
    sound.PlayOnRemove = true

    -- Destroying the sound object plays the sound due to PlayOnRemove property
    sound:Destroy()
end

-- Function to play a list of sounds with delays
function PlaySound:playSounds(soundIds, Volume, Pitch)
    local soundList = string.split(soundIds, ",")
    
    for _, soundId in ipairs(soundList) do
        self:playSound(soundId, Volume, Pitch)
    end
end

-- Return the PlaySound library
return PlaySound
