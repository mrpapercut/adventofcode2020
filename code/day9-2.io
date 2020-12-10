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
        self window := self filecontents slice(0, self windowsize) map(asNumber)

        self pointer = 0
        self nextvalue := self windowsize
    )

    updatewindow := method(
        self pointer := self pointer + 1
        self nextvalue := self nextvalue + 1

        (self filecontents at(self nextvalue) == nil) ifTrue (
            self increasewindow
            self initloop
        ) ifFalse (
            self window := self filecontents slice(self pointer, self pointer + self windowsize) map(asNumber)
        )
    )

    increasewindow := method(
        write("Increasing windowsize to ", self windowsize + 1, "\n")
        self windowsize := self windowsize + 1
    )

    checkwindow := method(
        // Compare sum to result of previous result
        if(self window sum == 756008079,
            self window := self window sort
            
            weakness := self window first + self window last
            weakness println

            return true
        )

        return false
    )
)

encodingError := EncodingError clone 
encodingError setWindowsize(2)
encodingError setInputfile("./input/day9.txt")

encodingError readfile
encodingError initloop

while(encodingError checkwindow not,
    encodingError updatewindow
)
