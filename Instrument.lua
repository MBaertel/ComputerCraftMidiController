NotePlayer = {}
NotePlayer.__index = NotePlayer

function NotePlayer:new(name,peripheral)
    local self = setmetatable({},NotePlayer)
    self.name = name
    self.relay = peripheral
    return self
end

function NotePlayer:play()
    self.relay.setOutput("front",true)
end

function NotePlayer:stop()
    self.relay.setOutput("front",false)
end

Organ = {}
Organ.__index = Organ

function Organ:new(name,peripherals)
    local self = setmetatable({},Organ)
    self.name = name
    self.steps = {}
    self.currentStep = 0
    self.stepDuration = 0.5

    local baseNotes = {"F#","G","G#","A","A#","B","C","C#","D","D#","E","F","F#"}
    self.notePlayers = {}

    local i = 0
    for octave = 1,3 do
        for _,note in ipairs(baseNotes) do
            local noteName = note .. octave
            local relay = peripherals[i]
            local notePlayer = NotePlayer:new(note .. octave,relay)
            self.notePlayers[noteName] = notePlayer
            i = i + 1
        end
    end
    return self
end

function Organ:add(noteName,duration)
    for i = self.currentStep, self.currentStep + duration - 1 do
        if not self.steps[i] then
            self.steps[i] = {}
        end
        table.insert(self.steps[i],noteName)
    end
    return self
end

function Organ:step()
    self.currentStep = self.currentStep + 1
    return self
end

function Organ:setSpeed(duration)
    self.stepDuration = duration
    return self
end

function Organ:play()
    local allNotes = {}
    for _,notePlayer in pairs(self.notePlayers) do
        table.insert(allNotes, notePlayer)
    end

    for stepIndex,stepNotes in ipairs(self.steps) do
        for _,note in ipairs(allNotes) do
            local playing = false
            for _,n in ipairs(stepNotes) do
                if n == note.name then
                    playing = true
                    break
                end
            end
            if playing then
                note.play(note)
            else
                note.stop(note)
            end
        end
        sleep(self.stepDuration)
    end
end

