# Advent of Code 2020 Day 11: Seating System
## Description
### Part 1
Your plane lands with plenty of time to spare. The final leg of your journey is a ferry that goes directly to the tropical island where you can finally start your vacation. As you reach the waiting area to board the ferry, you realize you're so early, nobody else has even arrived yet!

By modeling the process people use to choose (or abandon) their seat in the waiting area, you're pretty sure you can predict the best place to sit. You make a quick map of the seat layout (your puzzle input).

The seat layout fits neatly on a grid. Each position is either floor (.), an empty seat (L), or an occupied seat (#). For example, the initial seat layout might look like this:
```
L.LL.LL.LL
LLLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLLL
L.LLLLLL.L
L.LLLLL.LL
```
Now, you just need to model the people who will be arriving shortly. Fortunately, people are entirely predictable and always follow a simple set of rules. All decisions are based on the number of occupied seats adjacent to a given seat (one of the eight positions immediately up, down, left, right, or diagonal from the seat). The following rules are applied to every seat simultaneously:

- If a seat is empty (L) and there are no occupied seats adjacent to it, the seat becomes occupied.
- If a seat is occupied (#) and four or more seats adjacent to it are also occupied, the seat becomes empty.
- Otherwise, the seat's state does not change.
Floor (.) never changes; seats don't move, and nobody sits on the floor.

After one round of these rules, every seat in the example layout becomes occupied:
```
#.##.##.##
#######.##
#.#.#..#..
####.##.##
#.##.##.##
#.#####.##
..#.#.....
##########
#.######.#
#.#####.##
```
After a second round, the seats with four or more occupied adjacent seats become empty again:
```
#.LL.L#.##
#LLLLLL.L#
L.L.L..L..
#LLL.LL.L#
#.LL.LL.LL
#.LLLL#.##
..L.L.....
#LLLLLLLL#
#.LLLLLL.L
#.#LLLL.##
```
This process continues for three more rounds:
```
#.##.L#.##
#L###LL.L#
L.#.#..#..
#L##.##.L#
#.##.LL.LL
#.###L#.##
..#.#.....
#L######L#
#.LL###L.L
#.#L###.##
```
```
#.#L.L#.##
#LLL#LL.L#
L.L.L..#..
#LLL.##.L#
#.LL.LL.LL
#.LL#L#.##
..L.L.....
#L#LLLL#L#
#.LLLLLL.L
#.#L#L#.##
```
```
#.#L.L#.##
#LLL#LL.L#
L.#.L..#..
#L##.##.L#
#.#L.LL.LL
#.#L#L#.##
..L.L.....
#L#L##L#L#
#.LLLLLL.L
#.#L#L#.##
```
At this point, something interesting happens: the chaos stabilizes and further applications of these rules cause no seats to change state! Once people stop moving around, you count 37 occupied seats.

Simulate your seating area by applying the seating rules repeatedly until no seats change state. How many seats end up occupied?

### Part 2
As soon as people start to arrive, you realize your mistake. People don't just care about adjacent seats - they care about the first seat they can see in each of those eight directions!

Now, instead of considering just the eight immediately adjacent seats, consider the first seat in each of those eight directions. For example, the empty seat below would see eight occupied seats:
```
.......#.
...#.....
.#.......
.........
..#L....#
....#....
.........
#........
...#.....
```
The leftmost empty seat below would only see one empty seat, but cannot see any of the occupied ones:
```
.............
.L.L.#.#.#.#.
.............
```
The empty seat below would see no occupied seats:
```
.##.##.
#.#.#.#
##...##
...L...
##...##
#.#.#.#
.##.##.
```
Also, people seem to be more tolerant than you expected: it now takes five or more visible occupied seats for an occupied seat to become empty (rather than four or more from the previous rules). The other rules still apply: empty seats that see no occupied seats become occupied, seats matching no rule don't change, and floor never changes.

Given the same starting layout as above, these new rules cause the seating area to shift around as follows:
```
L.LL.LL.LL
LLLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLLL
L.LLLLLL.L
L.LLLLL.LL
```
```
#.##.##.##
#######.##
#.#.#..#..
####.##.##
#.##.##.##
#.#####.##
..#.#.....
##########
#.######.#
#.#####.##
```
```
#.LL.LL.L#
#LLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLL#
#.LLLLLL.L
#.LLLLL.L#
```
```
#.L#.##.L#
#L#####.LL
L.#.#..#..
##L#.##.##
#.##.#L.##
#.#####.#L
..#.#.....
LLL####LL#
#.L#####.L
#.L####.L#
```
```
#.L#.L#.L#
#LLLLLL.LL
L.L.L..#..
##LL.LL.L#
L.LL.LL.L#
#.LLLLL.LL
..L.L.....
LLLLLLLLL#
#.LLLLL#.L
#.L#LL#.L#
```
```
#.L#.L#.L#
#LLLLLL.LL
L.L.L..#..
##L#.#L.L#
L.L#.#L.L#
#.L####.LL
..#.#.....
LLL###LLL#
#.LLLLL#.L
#.L#LL#.L#
```
```
#.L#.L#.L#
#LLLLLL.LL
L.L.L..#..
##L#.#L.L#
L.L#.LL.L#
#.LLLL#.LL
..#.L.....
LLL###LLL#
#.LLLLL#.L
#.L#LL#.L#
```
Again, at this point, people stop shifting around and the seating area reaches equilibrium. Once this occurs, you count 26 occupied seats.

Given the new visibility method and the rule change for occupied seats becoming empty, once equilibrium is reached, how many seats end up occupied?

## Language used
Kotlin

## Solutions:
### Part 1
```kotlin
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
```

### Part 2
```kotlin
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
```

## Source
[Part 1](./day11/day11-1.kt)
[Part 2](./day11/day11-2.kt)

## Usage
```bash
kotlinc ./day11/day11-1.kt -include-runtime -d day11-1.jar
java -jar ./day11-1.jar

kotlinc ./day11/day11-2.kt -include-runtime -d day11-2.jar
java -jar ./day11-2.jar
```
