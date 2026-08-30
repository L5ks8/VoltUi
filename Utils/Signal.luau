local Signal = {}
Signal.__index = Signal

function Signal.new()
    local self = setmetatable({}, Signal)
    self._bindableEvent = Instance.new("BindableEvent")
    return self
end

function Signal:Connect(callback)
    return self._bindableEvent.Event:Connect(function(...)
        callback(...)
    end)
end

function Signal:Fire(...)
    self._bindableEvent:Fire(...)
end

function Signal:Wait()
    return self._bindableEvent.Event:Wait()
end

function Signal:Destroy()
    if self._bindableEvent then
        self._bindableEvent:Destroy()
        self._bindableEvent = nil
    end
end

return Signal
