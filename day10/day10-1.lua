AdapterArray = {}
AdapterArray.__index = AdapterArray 

function AdapterArray:init()
    local this = {}
    setmetatable(this, AdapterArray)

    return this
end

function AdapterArray:readFile(filename)
    local file = io.open(filename, 'r')
    self.inputlines = {}

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
    local in1 = 1
    local in3 = 1
    for i = 1, #self.inputlines do
        if (i + 1 <= #self.inputlines) then
            if (self.inputlines[i + 1] - self.inputlines[i] == 1) then
                in1 = in1 + 1
            else
                in3 = in3 + 1
            end
        end
    end

    print('Step 1:', in1)
    print('Step 3:', in3)
    print('Sum:', in1 * in3)
end

aa = AdapterArray:init()
aa:readFile('./day10/day10.txt')
aa:sortInput()
aa:calculateSteps()
