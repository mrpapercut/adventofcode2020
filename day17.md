# Advent of Code 2020 Day 17: Conway Cubes
## Description
### Part 1
As your flight slowly drifts through the sky, the Elves at the Mythical Information Bureau at the North Pole contact you. They'd like some help debugging a malfunctioning experimental energy source aboard one of their super-secret imaging satellites.

The experimental energy source is based on cutting-edge technology: a set of Conway Cubes contained in a pocket dimension! When you hear it's having problems, you can't help but agree to take a look.

The pocket dimension contains an infinite 3-dimensional grid. At every integer 3-dimensional coordinate (x,y,z), there exists a single cube which is either active or inactive.

In the initial state of the pocket dimension, almost all cubes start inactive. The only exception to this is a small flat region of cubes (your puzzle input); the cubes in this region start in the specified active (#) or inactive (.) state.

The energy source then proceeds to boot up by executing six cycles.

Each cube only ever considers its neighbors: any of the 26 other cubes where any of their coordinates differ by at most 1. For example, given the cube at x=1,y=2,z=3, its neighbors include the cube at x=2,y=2,z=2, the cube at x=0,y=2,z=3, and so on.

During a cycle, all cubes simultaneously change their state according to the following rules:

- If a cube is active and exactly 2 or 3 of its neighbors are also active, the cube remains active. Otherwise, the cube becomes inactive.
- If a cube is inactive but exactly 3 of its neighbors are active, the cube becomes active. Otherwise, the cube remains inactive.
The engineers responsible for this experimental energy source would like you to simulate the pocket dimension and determine what the configuration of cubes should be at the end of the six-cycle boot process.

For example, consider the following initial state:
```
.#.
..#
###
```
Even though the pocket dimension is 3-dimensional, this initial state represents a small 2-dimensional slice of it. (In particular, this initial state defines a 3x3x1 region of the 3-dimensional space.)

Simulating a few cycles from this initial state produces the following configurations, where the result of each cycle is shown layer-by-layer at each given z coordinate (and the frame of view follows the active cells in each cycle):
```
Before any cycles:

z=0
.#.
..#
###


After 1 cycle:

z=-1
#..
..#
.#.

z=0
#.#
.##
.#.

z=1
#..
..#
.#.


After 2 cycles:

z=-2
.....
.....
..#..
.....
.....

z=-1
..#..
.#..#
....#
.#...
.....

z=0
##...
##...
#....
....#
.###.

z=1
..#..
.#..#
....#
.#...
.....

z=2
.....
.....
..#..
.....
.....


After 3 cycles:

z=-2
.......
.......
..##...
..###..
.......
.......
.......

z=-1
..#....
...#...
#......
.....##
.#...#.
..#.#..
...#...

z=0
...#...
.......
#......
.......
.....##
.##.#..
...#...

z=1
..#....
...#...
#......
.....##
.#...#.
..#.#..
...#...

z=2
.......
.......
..##...
..###..
.......
.......
.......
```
After the full six-cycle boot process completes, 112 cubes are left in the active state.

Starting with your given initial configuration, simulate six cycles. How many cubes are left in the active state after the sixth cycle?

### Part 2
For some reason, your simulated results don't match what the experimental energy source engineers expected. Apparently, the pocket dimension actually has four spatial dimensions, not three.

The pocket dimension contains an infinite 4-dimensional grid. At every integer 4-dimensional coordinate (x,y,z,w), there exists a single cube (really, a hypercube) which is still either active or inactive.

Each cube only ever considers its neighbors: any of the 80 other cubes where any of their coordinates differ by at most 1. For example, given the cube at `x=1,y=2,z=3,w=4`, its neighbors include the cube at `x=2,y=2,z=3,w=3`, the cube at `x=0,y=2,z=3,w=4`, and so on.

The initial state of the pocket dimension still consists of a small flat region of cubes. Furthermore, the same rules for cycle updating still apply: during each cycle, consider the number of active neighbors of each cube.

For example, consider the same initial state as in the example above. Even though the pocket dimension is 4-dimensional, this initial state represents a small 2-dimensional slice of it. (In particular, this initial state defines a 3x3x1x1 region of the 4-dimensional space.)

Simulating a few cycles from this initial state produces the following configurations, where the result of each cycle is shown layer-by-layer at each given z and w coordinate:
```
Before any cycles:

z=0, w=0
.#.
..#
###


After 1 cycle:

z=-1, w=-1
#..
..#
.#.

z=0, w=-1
#..
..#
.#.

z=1, w=-1
#..
..#
.#.

z=-1, w=0
#..
..#
.#.

z=0, w=0
#.#
.##
.#.

z=1, w=0
#..
..#
.#.

z=-1, w=1
#..
..#
.#.

z=0, w=1
#..
..#
.#.

z=1, w=1
#..
..#
.#.


After 2 cycles:

z=-2, w=-2
.....
.....
..#..
.....
.....

z=-1, w=-2
.....
.....
.....
.....
.....

z=0, w=-2
###..
##.##
#...#
.#..#
.###.

z=1, w=-2
.....
.....
.....
.....
.....

z=2, w=-2
.....
.....
..#..
.....
.....

z=-2, w=-1
.....
.....
.....
.....
.....

z=-1, w=-1
.....
.....
.....
.....
.....

z=0, w=-1
.....
.....
.....
.....
.....

z=1, w=-1
.....
.....
.....
.....
.....

z=2, w=-1
.....
.....
.....
.....
.....

z=-2, w=0
###..
##.##
#...#
.#..#
.###.

z=-1, w=0
.....
.....
.....
.....
.....

z=0, w=0
.....
.....
.....
.....
.....

z=1, w=0
.....
.....
.....
.....
.....

z=2, w=0
###..
##.##
#...#
.#..#
.###.

z=-2, w=1
.....
.....
.....
.....
.....

z=-1, w=1
.....
.....
.....
.....
.....

z=0, w=1
.....
.....
.....
.....
.....

z=1, w=1
.....
.....
.....
.....
.....

z=2, w=1
.....
.....
.....
.....
.....

z=-2, w=2
.....
.....
..#..
.....
.....

z=-1, w=2
.....
.....
.....
.....
.....

z=0, w=2
###..
##.##
#...#
.#..#
.###.

z=1, w=2
.....
.....
.....
.....
.....

z=2, w=2
.....
.....
..#..
.....
.....
```
After the full six-cycle boot process completes, 848 cubes are left in the active state.

Starting with your given initial configuration, simulate six cycles in a 4-dimensional space. How many cubes are left in the active state after the sixth cycle?

## Language used
D

## Solutions:
### Part 1
```d
module day17.day17_1;

import std.array;
import std.conv;
import std.file;
import std.stdio;
import std.string;
import std.typecons;

immutable int STARTING_WIDTH    = 8;
immutable int STARTING_HEIGHT   = 8;
immutable int STARTING_DEPTH    = 1;

immutable int TOTAL_ROUNDS      = 6;

immutable int MAX_WIDTH         = STARTING_WIDTH + (TOTAL_ROUNDS * 2) + 2;
immutable int MAX_HEIGHT        = STARTING_HEIGHT + (TOTAL_ROUNDS * 2) + 2;
immutable int MAX_DEPTH         = STARTING_DEPTH + (TOTAL_ROUNDS * 2) + 2;

alias neighbor_grid = Typedef!int[][][];
alias active_grid = Typedef!bool[][][];

neighbor_grid [MAX_WIDTH][MAX_HEIGHT][MAX_DEPTH] neighbors;
active_grid [MAX_WIDTH][MAX_HEIGHT][MAX_DEPTH] active;

auto update_neighborhood(neighbor_grid neighbors, int w, int h, int d) {
    for (int x = w - 1; x < w + 2; x++) {
        for (int y = h - 1; y < h + 2; y++) {
            for (int z = d - 1; z < d + 2; z++) {
                if (x == w && y == h && z == d) {
                    continue;
                }

                neighbors[x][y][z] += 1;
            }
        }
    }
}

auto update_neighbors(active_grid active, neighbor_grid neighbors) {
    for (int w = 0; w < MAX_WIDTH; w++) {
        for (int h = 0; h < MAX_HEIGHT; h++) {
            for (int d = 0; d < MAX_DEPTH; d++) {
                if (active[w][h][d]) {
                    update_neighborhood(neighbors, w, h, d);
                }
            }
        }
    }
}

auto walk_grid(active_grid current, active_grid previous, neighbor_grid neighbors) {
    int active_neighbors = 0;

    update_neighbors(previous, neighbors);

    // Loop
    for (int w = 0; w < MAX_WIDTH; w++) {
        for (int h = 0; h < MAX_HEIGHT; h++) {
            for (int d = 0; d < MAX_DEPTH; d++) {
                active_neighbors = to!int(neighbors[w][h][d]);

                if (previous[w][h][d]) {
                    if (active_neighbors == 2 || active_neighbors == 3) { // Stays active
                        current[w][h][d] = true;
                    } else { // Becomes inactive
                        current[w][h][d] = false;
                    }
                } else if (active_neighbors == 3) {
                    // Becomes active
                    current[w][h][d] = true;
                } else {
                    // Stays inactive
                    current[w][h][d] = false;
                }
            }
        }
    }
}

int count_active(active_grid current) {
    int total = 0;

    // Loop
    for (int w = 0; w < MAX_WIDTH; w++) {
        for (int h = 0; h < MAX_HEIGHT; h++) {
            for (int d = 0; d < MAX_DEPTH; d++) {
                if (current[w][h][d]) total++;
            }
        }
    }

    return total;
}

auto read_file(const char[] filename) {
    string[] arr;

    File file = File(filename, "r");

    while (!file.eof()) {
        const string line = chomp(file.readln());
        arr ~= line;
    }

    return arr;
}

void main(string[] args) {
    string[] contents = read_file("./day17/day17.txt");

    neighbor_grid neighbors = new neighbor_grid(MAX_WIDTH, MAX_HEIGHT, MAX_DEPTH);
    active_grid active_a = new active_grid(MAX_WIDTH, MAX_HEIGHT, MAX_DEPTH);
    active_grid active_b = new active_grid(MAX_WIDTH, MAX_HEIGHT, MAX_DEPTH);

    int y = 0;
    for (int i = 0; i < contents.length; i++) {
        auto chars = contents[i].split("");

        for (int x = 0; x < STARTING_WIDTH; x++) {
            if (chars[x] == "#") {
                active_b[x + TOTAL_ROUNDS + 1][y + TOTAL_ROUNDS + 1][TOTAL_ROUNDS + 1] = true;
            }
        }

        y++;
    }

    bool tock = true;
    for (int round = 0; round < TOTAL_ROUNDS; round++) {
        neighbors = new neighbor_grid(MAX_WIDTH, MAX_HEIGHT, MAX_DEPTH);

        if (tock) {
            walk_grid(active_a, active_b, neighbors);
        } else {
            walk_grid(active_b, active_a, neighbors);
        }

        tock = !tock;
    }

    writeln("Solution: ", count_active(tock ? active_b : active_a));
}
```

### Part 2
```d
module day17.day17_2;

import std.array;
import std.conv;
import std.file;
import std.stdio;
import std.string;
import std.typecons;

immutable int STARTING_WIDTH    = 8;
immutable int STARTING_HEIGHT   = 8;
immutable int STARTING_DEPTH    = 1;
immutable int STARTING_TIME     = 1;

immutable int TOTAL_ROUNDS      = 6;

immutable int MAX_WIDTH         = STARTING_WIDTH + (TOTAL_ROUNDS * 2) + 2;
immutable int MAX_HEIGHT        = STARTING_HEIGHT + (TOTAL_ROUNDS * 2) + 2;
immutable int MAX_DEPTH         = STARTING_DEPTH + (TOTAL_ROUNDS * 2) + 2;
immutable int MAX_TIME          = STARTING_TIME + (TOTAL_ROUNDS * 2) + 2;

alias neighbor_grid = Typedef!int[][][][];
alias active_grid = Typedef!bool[][][][];

neighbor_grid [MAX_WIDTH][MAX_HEIGHT][MAX_DEPTH][MAX_TIME] neighbors;
active_grid [MAX_WIDTH][MAX_HEIGHT][MAX_DEPTH][MAX_TIME] active;

/*
Loop:
    for (int w = 0; w < MAX_WIDTH; ++w) {
        for (int h = 0; h < MAX_HEIGHT; ++h) {
            for (int d = 0; d < MAX_DEPTH; ++d) {

            }
        }
    }
*/

auto update_neighborhood(neighbor_grid neighbors, int w, int h, int d, int t) {
    for (int x = w - 1; x < w + 2; x++) {
        for (int y = h - 1; y < h + 2; y++) {
            for (int z = d - 1; z < d + 2; z++) {
                for (int a = t - 1; a < t + 2; a++) {
                    if (x == w && y == h && z == d && a == t) {
                        continue;
                    }

                    neighbors[x][y][z][a] += 1;
                }
            }
        }
    }
}

auto update_neighbors(active_grid active, neighbor_grid neighbors) {
    for (int w = 0; w < MAX_WIDTH; w++) {
        for (int h = 0; h < MAX_HEIGHT; h++) {
            for (int d = 0; d < MAX_DEPTH; d++) {
                for (int t = 0; t < MAX_TIME; t++) {
                    if (active[w][h][d][t]) {
                        update_neighborhood(neighbors, w, h, d, t);
                    }
                }
            }
        }
    }
}

auto walk_grid(active_grid current, active_grid previous, neighbor_grid neighbors) {
    int active_neighbors = 0;

    update_neighbors(previous, neighbors);

    // Loop
    for (int w = 0; w < MAX_WIDTH; w++) {
        for (int h = 0; h < MAX_HEIGHT; h++) {
            for (int d = 0; d < MAX_DEPTH; d++) {
                for (int t = 0; t < MAX_TIME; t++) {
                    active_neighbors = to!int(neighbors[w][h][d][t]);

                    if (previous[w][h][d][t]) {
                        if (active_neighbors == 2 || active_neighbors == 3) { // Stays active
                            current[w][h][d][t] = true;
                        } else { // Becomes inactive
                            current[w][h][d][t] = false;
                        }
                    } else if (active_neighbors == 3) {
                        // Becomes active
                        current[w][h][d][t] = true;
                    } else {
                        // Stays inactive
                        current[w][h][d][t] = false;
                    }
                }
            }
        }
    }
}

int count_active(active_grid current) {
    int total = 0;

    // Loop
    for (int w = 0; w < MAX_WIDTH; w++) {
        for (int h = 0; h < MAX_HEIGHT; h++) {
            for (int d = 0; d < MAX_DEPTH; d++) {
                for (int t = 0; t < MAX_TIME; t++) {
                    if (current[w][h][d][t]) total++;
                }
            }
        }
    }

    return total;
}

auto read_file(const char[] filename) {
    string[] arr;

    File file = File(filename, "r");

    while (!file.eof()) {
        const string line = chomp(file.readln());
        arr ~= line;
    }

    return arr;
}

void main(string[] args) {
    string[] contents = read_file("./day17/day17.txt");

    neighbor_grid neighbors = new neighbor_grid(MAX_WIDTH, MAX_HEIGHT, MAX_DEPTH, MAX_TIME);
    active_grid active_a = new active_grid(MAX_WIDTH, MAX_HEIGHT, MAX_DEPTH, MAX_TIME);
    active_grid active_b = new active_grid(MAX_WIDTH, MAX_HEIGHT, MAX_DEPTH, MAX_TIME);

    int y = 0;
    for (int i = 0; i < contents.length; i++) {
        auto chars = contents[i].split("");

        for (int x = 0; x < STARTING_WIDTH; x++) {
            if (chars[x] == "#") {
                active_b[x + TOTAL_ROUNDS + 1][y + TOTAL_ROUNDS + 1][TOTAL_ROUNDS + 1][TOTAL_ROUNDS + 1] = true;
            }
        }

        y++;
    }

    bool tock = true;
    for (int round = 0; round < TOTAL_ROUNDS; round++) {
        neighbors = new neighbor_grid(MAX_WIDTH, MAX_HEIGHT, MAX_DEPTH, MAX_TIME);

        if (tock) {
            walk_grid(active_a, active_b, neighbors);
        } else {
            walk_grid(active_b, active_a, neighbors);
        }

        tock = !tock;
    }

    writeln("Solution: ", count_active(tock ? active_b : active_a));
}
```

## Source
[Part 1](./day17/day17_1.d)
[Part 2](./day17/day17_2.d)

## Usage
```bash
source ~/dlang/dmd-2.094.2/activate

# Note: Filename uses _ instead of - because DMD complains when filename contains -

dmd -of=./built/day17_1 ./day17/day17_1.d
./built/day17_1

dmd -of=./built/day17_2 ./day17/day17_2.d
./built/day17_2
```
