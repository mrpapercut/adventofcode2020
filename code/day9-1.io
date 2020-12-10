EncodingError := Object clone do(
    fields ::= list("windowsize", "inputfile", "filecontents", "window", "pointer", "nextvalue")

    init := method(
        fields foreach(key, 
            if (self hasSlot(key) not,
                self newSlot(key, nil)
            ) 
        )
    )

    readfile := method(
        fh := File with(inputfile)
        fh openForReading

        filecontents = fh readLines
        fh close
    )

    initloop := method(
        window = filecontents slice(0, windowsize)

        pointer = 0
        nextvalue = windowsize
    )

    updatewindow := method(
        pointer = pointer + 1
        nextvalue = nextvalue + 1
        window = filecontents slice(pointer, pointer + windowsize)
    )

    checkwindow := method(
        window foreach(i, value,
            window foreach(j, comparingvalue,
                // Don't compare the same values
                if (i == j, continue)

                // If sum of 2 values equals the next value behind window, the next value is fine
                if (value asNumber + comparingvalue asNumber == filecontents at(nextvalue) asNumber,
                    return true
                )
            )
        )

        // If no possible combination was found, print next value
        filecontents at(nextvalue) println

        return false
    )
)

encodingError := EncodingError clone 
encodingError setWindowsize(25)
encodingError setInputfile("./input/day9.txt")

encodingError readfile()
encodingError initloop()

while(encodingError checkwindow(),
    encodingError updatewindow()
)
