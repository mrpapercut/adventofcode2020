# Day 5: Binary Boarding

function getupperhalf(numrange)
    return [ceil((numrange[1] + numrange[2]) / 2), numrange[2]]
end

function getlowerhalf(numrange)
    return [numrange[1], floor((numrange[1] + numrange[2]) / 2)]
end

function parsepass(boardpass)
    rowsrange = [0, 127]
    for char in boardpass[1:7]
        if char == 'F'
            rowsrange = getlowerhalf(rowsrange)
        elseif char == 'B'
            rowsrange = getupperhalf(rowsrange)
        end
    end
    row = rowsrange[1]

    columnsrange = [0, 7]
    for char in boardpass[8:10]
        if char == 'L'
            columnsrange = getlowerhalf(columnsrange)
        elseif char == 'R'
            columnsrange = getupperhalf(columnsrange)
        end
    end
    column = columnsrange[1]

    seatid = row * 8 + column

    return Dict(
        "row" => row,
        "column" => column,
        "seatid" => seatid
    )
end

# Read file line by line
seatids = []
for boardpass in eachline(joinpath(@__DIR__, "../input/day5.txt"))
    if length(boardpass) == 10
        parsedpass = parsepass(boardpass)
        global seatids = [seatids; trunc(Int, parsedpass["seatid"])]
    end
end
seatids = sort(seatids)

# Fill another array with all possible seat ids, and calculate missing one (excluding first and last ids)
allseatids = []
for row = 0:127
    for column = 0:7
        global allseatids = [allseatids; row * 8 + column]
    end
end

for seatid = allseatids
    index = findfirst(isequal(seatid), seatids)
    if (index == nothing && findfirst(isequal(seatid - 1), seatids) != nothing && findfirst(isequal(seatid + 1), seatids) != nothing)
        println(string("Your seat ID: ", seatid))
    end
end
