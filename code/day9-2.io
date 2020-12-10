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
        window = filecontents slice(0, windowsize) map(asNumber)

        pointer = 0
        nextvalue = windowsize
    )

    updatewindow := method(
        pointer = pointer + 1
        nextvalue = nextvalue + 1

        (filecontents at(nextvalue) == nil) ifTrue (
            increasewindow
            initloop
        ) ifFalse (
            window = filecontents slice(pointer, pointer + windowsize) map(asNumber)
        )
    )

    increasewindow := method(
        write("Increasing windowsize to ", windowsize + 1, "\n")
        windowsize = windowsize + 1
    )

    checkwindow := method(
        // Compare sum to result of previous result
        if(window sum == 756008079,
            window = window sort

            weakness := window first + window last
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
