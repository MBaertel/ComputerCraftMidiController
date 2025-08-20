Note= {}
Note.__index = Note

function Note:new(name,peripheral)
    local self = setmetatable({},Note)
    self.name = name
    self.relay = peripheral
    return self
end

function Note:play()
    self.relay.setOutput("front",true)
end

function Note:stop()
    self.relay.setOutput("front",false)
end

Instrument = {}
Instrument.__index = Instrument

function Instrument:new(name,peripherals)
    local self = setmetatable({},Instrument)
    self.name = name
    self.notes = {}

    local notesCount = 0
    for _ in pairs(peripherals) do
        notesCount = notesCount + 1
    end

    for note = 0,127 do
        local idx = math.floor(note* notesCount / 128) + 1
        local notePlayer = Note:new(note + 1,peripherals[idx])
        table.insert(self.notes,notePlayer)
    end
    return self
end

function Instrument:play(note)
    self.notes[note]:play()
end

function Instrument:stop(note)
    self.notes[note]:stop()
end

