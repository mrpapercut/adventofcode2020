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

    fun findAdjacentSeats(x: Int, y: Int): Array<Array<Int>> {
        var adjacentSeats = arrayOf<Array<Int>>()

        val xpossibilities = arrayOf(x - 1, x, x + 1)
        val ypossibilities = arrayOf(y - 1, y, y + 1)

        xpossibilities.forEach {
            xpos -> if (xpos >= 0 && xpos < this.inputLines.size) {
                ypossibilities.forEach {
                    ypos -> if (ypos >= 0 && ypos < this.inputLines[0].size) {
                        if (!(xpos == x && ypos == y)) adjacentSeats += arrayOf(xpos, ypos)
                    };
                }
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
                    if (this.countOccupiedAdjacentSeats(adjacentSeats) >= 4) {
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

        if (flippedSeats == 0) break
    }
    println("Total occupied: ${seatingSystem.countAllOccupiedSeats()}")
}
