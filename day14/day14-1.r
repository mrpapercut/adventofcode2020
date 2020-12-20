# install.packages('stringr')
# install.packages('bit64')
library('bit64')
library('stringr')

readfile <- function(filename) {
    filepath <- file.path(normalizePath('./'), filename)
    fh <- file(filepath, 'r')

    lines <- readLines(fh)
    close(fh)

    return(lines)
}

intToBitstring <- function(int) {
    # To list of bits
    bitlist <- as.integer(intToBits(int))
    # Reverse list
    bitlist <- rev(bitlist)
    # Join to string
    bitstr <- listToString(bitlist)
    # Pad to length 36
    bitstr <- str_pad(bitstr, 36, 'left', '0')

    return(bitstr)
}

bitstringToInt <- function(bitstring) {
    return(as.integer64.bitstring(bitstring))
}

listToString <- function(lst) {
    return(paste(unlist(lst), collapse = ''))
}

applyMask <- function(mask, memstr) {
    appliedMaskList <- vector(mode = 'list', length = 36)
    masklist <- strsplit(mask, '')
    memstrlist <- strsplit(memstr, '')

    j <- 1
    for (i in masklist[[1]]) {
        if (i == 'X') {
            appliedMaskList[j] = memstrlist[[1]][j]
        } else {
            appliedMaskList[j] = i
        }

        j <- j + 1
    }

    # List to bitstring
    bitstring <- listToString(appliedMaskList)

    return(bitstring)
}

inputcontents <- readfile('./day14/day14.txt')
memory <- vector(mode = 'list', length = 65535)
for (line in inputcontents) {
    if (substring(line, 0, 4) == 'mask') {
        mask <- substring(line, 8)
    } else {
        rgex <- str_match(line, "mem\\[([0-9]+)\\] = (.*)")
        mempos <- as.integer(rgex[2])
        memstr <- intToBitstring(rgex[3])
        appliedMask <- applyMask(mask, memstr)
        memory[mempos] <- list(as.integer64.bitstring(appliedMask))
    }
}

sum <- 0
for (mempos in memory) {
    if(!is.null(mempos) && !is.na(mempos)) {
        sum <- sum + mempos[1]
    }
}
print(sum)
