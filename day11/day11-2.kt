import java.io.File
import java.io.InputStream

class SeatingSystem {
    var inputLines = arrayOf<Array<String>>()

    fun readFile(filename: String) {
        val inputStream: InputStream = File(filename).inputStream()

        inputStream.bufferedReader().useLines {
            lines -> lines.forEach {
                line ->
                    var seats = arrayOf<String>();
                    line.split("").forEach {
                        if (it.length > 0) seats += it
                    };
                    this.inputLines += seats
            }
        }
    }

    fun inBounds(x: Int, y: Int): Boolean {
        return x >= 0 && y >= 0 && x < this.inputLines.size && y < this.inputLines[x].size
    }

    fun isSeat(x: Int, y: Int): Boolean {
        if (!this.inBounds(x, y)) return false

        return (this.inputLines[x][y] == "#" || this.inputLines[x][y] == "L")
    }

    fun findAdjacentSeats(x: Int, y: Int): Array<Array<Int>> {
        var adjacentSeats = arrayOf<Array<Int>>()

        // Seats to left
        for (iy in y downTo 0) {
            if (this.isSeat(x, iy) && !(iy == y)) {
                adjacentSeats += arrayOf(x, iy)
                break
            }
        }

        // Seats to right
        for (iy in y until this.inputLines[x].size) {
            if (this.isSeat(x, iy) && !(iy == y)) {
                adjacentSeats += arrayOf(x, iy)
                break
            }
        }

        // Seats to top
        for (ix in x downTo 0) {
            if (this.isSeat(ix, y) && !(ix == x)) {
                adjacentSeats += arrayOf(ix, y)
                break
            }
        }

        // Seats to bottom
        for (ix in x until this.inputLines.size) {
            if (this.isSeat(ix, y) && !(ix == x)) {
                adjacentSeats += arrayOf(ix, y)
                break
            }
        }

        // Seats to top-left
        if (x > 0 && y > 0) {
            var iycounter: Int = 0
            tlloop@ for (ix in (x - 1) downTo 0) {
                var iy: Int = y - (1 + iycounter)

                if (this.inBounds(ix, iy) && this.isSeat(ix, iy)) {
                    if (!(ix == x && iy == y)) {
                        adjacentSeats += arrayOf(ix, iy)
                        break@tlloop
                    }
                }

                iycounter++
            }
        }

        // Seats to top-right
        if (x > 0 && y < this.inputLines[x].size - 1) {
            var iycounter: Int = 0
            trloop@ for (ix in (x - 1) downTo 0) {
                var iy: Int = y + (1 + iycounter)

                if (this.inBounds(ix, iy) && this.isSeat(ix, iy)) {
                    if (!(ix == x && iy == y)) {
                        adjacentSeats += arrayOf(ix, iy)
                        break@trloop
                    }
                }

                iycounter++
            }
        }

        // Seats to bottom-left
        if (x < this.inputLines.size - 1 && y > 0) {
            var iycounter: Int = 0
            blloop@ for (ix in (x + 1) until this.inputLines.size) {
                var iy: Int = y - (1 + iycounter)

                if (this.inBounds(ix, iy) && this.isSeat(ix, iy)) {
                    if (!(ix == x && iy == y)) {
                        adjacentSeats += arrayOf(ix, iy)
                        break@blloop
                    }
                }

                iycounter++
            }
        }

        // Seats to bottom-right
        if (x < this.inputLines.size - 1 && y < this.inputLines[x].size - 1) {
            var iycounter: Int = 0
            brloop@ for (ix in (x + 1) until this.inputLines.size) {
                var iy: Int = y + (1 + iycounter)

                if (this.inBounds(ix, iy) && this.isSeat(ix, iy)) {
                    if (!(ix == x && iy == y)) {
                        adjacentSeats += arrayOf(ix, iy)
                        break@brloop
                    }
                }

                iycounter++
            }
        }

        return adjacentSeats
    }

    fun countOccupiedAdjacentSeats(adjacentSeats: Array<Array<Int>>): Int {
        var count = 0

        adjacentSeats.forEach {
            seat -> if (this.inputLines[seat[0]][seat[1]] == "#") count++
        }

        return count
    }

    fun walkSeats(): Int {
        var tempLayout = arrayOf<Array<String>>()
        var flippedSeats = 0

        for ((xindex, line) in this.inputLines.withIndex()) {
            var row = arrayOf<String>();
            for ((yindex, seat) in line.withIndex()) {
                if (seat == "L") {
                    val adjacentSeats = this.findAdjacentSeats(xindex, yindex)
                    if (this.countOccupiedAdjacentSeats(adjacentSeats) == 0) {
                        row += "#"
                        flippedSeats++
                    } else {
                        row += "L"
                    }
                } else if (seat == "#") {
                    val adjacentSeats = this.findAdjacentSeats(xindex, yindex)
                    if (this.countOccupiedAdjacentSeats(adjacentSeats) >= 5) {
                        row += "L"
                        flippedSeats++
                    } else {
                        row += "#"
                    }
                } else if (seat == ".") {
                    row += "."
                }
            }

            tempLayout += row
        }

        this.inputLines = tempLayout

        return flippedSeats
    }

    fun printSeatLayout() {
        for (line in this.inputLines) {
            for (seat in line) {
                print(seat)
            }
            print("\n")
        }
    }

    fun countAllOccupiedSeats(): Int {
        var count = 0

        for (line in this.inputLines) {
            for (seat in line) {
                if (seat == "#") count++
            }
        }

        return count
    }
}

fun main() {
    val seatingSystem = SeatingSystem()
    seatingSystem.readFile("./day11/day11.txt")

    while (true) {
        val flippedSeats = seatingSystem.walkSeats()
        // seatingSystem.printSeatLayout()
        // println("Flipped seats: $flippedSeats")

        if (flippedSeats == 0) break
    }
    println("Total occupied: ${seatingSystem.countAllOccupiedSeats()}")
}
