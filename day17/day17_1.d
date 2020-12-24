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
