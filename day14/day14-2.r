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
        if (i == '0') {
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

addressesFromMask <- function(mask) {
    xcount <- str_count(mask, 'X')
    replacelist <- expand.grid(rep(list(list(0, 1)), xcount))
    fmt_mask = str_replace_all(mask, 'X', '%s')

    addresses <- list()
    for (i in 1:nrow(replacelist)) {
        fmt_addr <- do.call(sprintf, c(list(fmt_mask), replacelist[i, ]))
        addresses <- c(addresses, list(fmt_addr))
    }

    return(addresses)
}

inputcontents <- readfile('./day14/day14.txt')
memory <- vector(mode = 'list')
for (line in inputcontents) {
    if (substring(line, 0, 4) == 'mask') {
        mask <- substring(line, 8)
    } else {
        rgex <- str_match(line, "mem\\[([0-9]+)\\] = (.*)")
        mempos <- intToBitstring(rgex[2])
        memval <- as.integer64(rgex[3])
        appliedMask <- applyMask(mask, mempos)
        memaddresses <- addressesFromMask(appliedMask)
        for (memaddr in memaddresses) {
            memory[memaddr] <- list(memval)
        }
    }
}

sum <- 0
for (mempos in memory) {
    if(!is.null(mempos) && !is.na(mempos)) {
        sum <- sum + mempos[1]
    }
}
print(sum)
