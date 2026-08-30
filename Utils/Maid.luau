local Maid = {}
Maid.__index = Maid

function Maid.new()
    local self = setmetatable({}, Maid)
    self._tasks = {}
    return self
end

function Maid:GiveTask(task)
    if not task then return end
    local taskId = #self._tasks + 1
    self._tasks[taskId] = task
    return taskId
end

function Maid:DoCleaning()
    local tasks = self._tasks
    for index, task in pairs(tasks) do
        if typeof(task) == "RBXScriptConnection" then
            task:Disconnect()
        elseif typeof(task) == "function" then
            task()
        elseif typeof(task) == "table" and type(task.Destroy) == "function" then
            task:Destroy()
        elseif typeof(task) == "Instance" then
            task:Destroy()
        end
        tasks[index] = nil
    end
end

function Maid:Destroy()
    self:DoCleaning()
end

return Maid
