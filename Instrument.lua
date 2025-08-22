Note= {}
Note.__index = Note

function Note:new(name,peripheral)
    local self = setmetatable({},Note)
    self.name = name
    self.relay = peripheral
    return self
end

function Note:play()
    if not self.relay then
        print("Note ".. self.name .. "not set")
        return
    end
    print("playing note " .. self.name)
    self.relay.setOutput("front",true)
end

function Note:stop()
    if not self.relay then
        print("Note ".. self.name .. "not set")
        return
    end
    self.relay.setOutput("front",false)
end

Instrument = {}
Instrument.__index = Instrument

function Instrument:new(name,peripherals,skip)
    local self = setmetatable({},Instrument)
    self.name = name
    self.notes = {}
    self.notePlayers = {}

    local note = 0
    for _,peri in ipairs(peripherals) do
        local notePlayer = Note:new(note + 1,peri)
        table.insert(self.notePlayers,notePlayer)
    end

    local notesCount = 0
    for _ in pairs(peripherals) do
        notesCount = notesCount + 1
    end

    local skipCount = 0
    if not skip then
        skipCount = ((128-notesCount)/2)
        print("No Skip Count passed, setting calculated center "..skipCount)
    else
        skipCount = skip
    end
    local idx = 1
    for note = 1,128 do
        if note <= skipCount then
            local notePlayer = Note:new(note)
            table.insert(self.notes,notePlayer)
            goto continue
        end
        if idx <= notesCount then
            local notePlayer = self.notePlayers[idx]
            notePlayer.name = note
            table.insert(self.notes,notePlayer)
            idx = idx + 1
        else
            local notePlayer = Note:new(note)
            table.insert(self.notes,notePlayer)
        end
        ::continue::
    end
    return self
end

function Instrument:play(note)
    self.notes[note]:play()
end

function Instrument:stop(note)
    self.notes[note]:stop()
end

return {Note = Note,Instrument = Instrument}

