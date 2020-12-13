-- Looks up value in table
function hasValue(tbl, value)
    for i = 1, #tbl do
        if tbl[i] == value then
            return true
        end
    end

    return false
end

AdapterArray = {}
AdapterArray.__index = AdapterArray

function AdapterArray:init()
    local this = {}
    setmetatable(this, AdapterArray)

    return this
end

function AdapterArray:readFile(filename)
    local file = io.open(filename, 'r')
    self.inputlines = {0}

    local i = 1
    for line in file:lines() do
        self.inputlines[i] = math.floor(line)
        i = i + 1
    end
end

function AdapterArray:sortInput()
    table.sort(self.inputlines)
end

function AdapterArray:calculateSteps()
    self.inputlines[#self.inputlines + 1] = self.inputlines[#self.inputlines] + 3

    local seq = {1, 1, 2, 4, 7}

    local multiplier = 1
    local currentRun = 2
    for _, value in pairs(self.inputlines) do
        if (hasValue(self.inputlines, value + 1)) then
            currentRun = currentRun + 1
        else
            multiplier = multiplier * seq[currentRun]
            currentRun = 1
        end
    end

    print(multiplier)
end

aa = AdapterArray:init()
aa:readFile('./day10/day10.txt')
aa:sortInput()
aa:calculateSteps()
