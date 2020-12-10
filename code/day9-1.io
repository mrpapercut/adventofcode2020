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
        fh := File with(self inputfile)
        fh openForReading

        self filecontents = fh readLines
        fh close
    )

    initloop := method(
        self window := self filecontents slice(0, self windowsize)

        self pointer = 0
        self nextvalue := self windowsize
    )

    updatewindow := method(
        self pointer := self pointer + 1
        self nextvalue := self nextvalue + 1
        self window := self filecontents slice(self pointer, self pointer + self windowsize)
    )

    checkwindow := method(
        self window foreach(i, value,
            self window foreach(j, comparingvalue,
                // Don't compare the same values
                if (i == j, continue)

                // If sum of 2 values equals the next value behind window, the next value is fine
                if (value asNumber + comparingvalue asNumber == self filecontents at(self nextvalue) asNumber,
                    return true
                )
            )
        )

        // If no possible combination was found, print next value
        self filecontents at(self nextvalue) println

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
