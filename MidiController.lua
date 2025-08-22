-- MidiEvent class
local MidiEvent = {}
MidiEvent.__index = MidiEvent

function MidiEvent:new(
    eventType,
    channel,
    note,
    time
)
    local self = setmetatable({},MidiEvent)
    self.note = note;
    self.channel = channel;
    self.time = time;
    self.type = eventType
    return self
end

-- MidiController class
local MidiController = {}
MidiController.__index = MidiController

function MidiController:new()
    local self = setmetatable({},MidiController)
    self.ticks_per_second = 24;
    self.events = {}
    self.instruments = {}
    return self;
end

function MidiController:setInstrument(channel,instrument)
    self.instruments[channel] = instrument
end

function MidiController:setTickRate(ticks_per_second)
    self.ticks_per_second = ticks_per_second
end

function MidiController:addEvent(midiEvent)
    local tick = midiEvent.time
    self.events[tick] = self.events[tick] or {}
    local tickTable = self.events[tick]
    table.insert(tickTable,midiEvent)
end

function MidiController:addTrack(midiTrack)
    local absTime = 0
    local note = 0
    for _,event in ipairs(midiTrack) do
        if event.delta then
            absTime = absTime + event.delta
        elseif event.time then
            absTime = event.time
        else
            error("Event must have time or delta")
        end

        if event.note then
            note = event.note
        elseif event.midi
            note = event.midi
        else
            error("Event must have note or midi")
        end

        local midiEvent = MidiEvent:new(
            event.type,
            event.channel,
            event.note,
            absTime)
        self:addEvent(midiEvent)
    end
end

function MidiController:play()
    local max_tick = 0
    for tick,_ in pairs(self.events) do
        if tick > max_tick then max_tick = tick end
    end

    local tick_duration = 1 / self.ticks_per_second

    for tick = 1,max_tick do
        local tick_events = self.events[tick] or {}
        for _,e in ipairs(tick_events) do
            local instrument = self.instruments[e.channel]
            if not instrument then
                goto continue
            end

            if e.type == "note_on" then
                instrument:play(e.note)
            end

            if e.type == "note_off" then
                instrument:stop(e.note)
            end
            ::continue::
        end
        sleep(tick_duration)
    end
end

return { MidiController = MidiController}


