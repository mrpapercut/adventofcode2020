# Advent of Code 2020 Day 15: Rambunctious Recitation
## Description
### Part 1
You catch the airport shuttle and try to book a new flight to your vacation island. Due to the storm, all direct flights have been cancelled, but a route is available to get around the storm. You take it.

While you wait for your flight, you decide to check in with the Elves back at the North Pole. They're playing a memory game and are ever so excited to explain the rules!

In this game, the players take turns saying numbers. They begin by taking turns reading from a list of starting numbers (your puzzle input). Then, each turn consists of considering the most recently spoken number:

- If that was the first time the number has been spoken, the current player says 0.
- Otherwise, the number had been spoken before; the current player announces how many turns apart the number is from when it was previously spoken.
So, after the starting numbers, each turn results in that player speaking aloud either 0 (if the last number is new) or an age (if the last number is a repeat).

For example, suppose the starting numbers are 0,3,6:

- Turn 1: The 1st number spoken is a starting number, 0.
- Turn 2: The 2nd number spoken is a starting number, 3.
- Turn 3: The 3rd number spoken is a starting number, 6.
- Turn 4: Now, consider the last number spoken, 6. Since that was the first time the number had been spoken, the 4th number spoken is 0.
- Turn 5: Next, again consider the last number spoken, 0. Since it had been spoken before, the next number to speak is the difference between the turn number when it was last - spoken (the previous turn, 4) and the turn number of the time it was most recently spoken before then (turn 1). Thus, the 5th number spoken is 4 - 1, 3.
- Turn 6: The last number spoken, 3 had also been spoken before, most recently on turns 5 and 2. So, the 6th number spoken is 5 - 2, 3.
- Turn 7: Since 3 was just spoken twice in a row, and the last two turns are 1 turn apart, the 7th number spoken is 1.
- Turn 8: Since 1 is new, the 8th number spoken is 0.
- Turn 9: 0 was last spoken on turns 8 and 4, so the 9th number spoken is the difference between them, 4.
- Turn 10: 4 is new, so the 10th number spoken is 0.
(The game ends when the Elves get sick of playing or dinner is ready, whichever comes first.)

Their question for you is: what will be the 2020th number spoken? In the example above, the 2020th number spoken will be 436.

Here are a few more examples:

- Given the starting numbers 1,3,2, the 2020th number spoken is 1.
- Given the starting numbers 2,1,3, the 2020th number spoken is 10.
- Given the starting numbers 1,2,3, the 2020th number spoken is 27.
- Given the starting numbers 2,3,1, the 2020th number spoken is 78.
- Given the starting numbers 3,2,1, the 2020th number spoken is 438.
- Given the starting numbers 3,1,2, the 2020th number spoken is 1836.

Given your starting numbers, what will be the 2020th number spoken?

### Part 2
Impressed, the Elves issue you a challenge: determine the 30000000th number spoken. For example, given the same starting numbers as above:

- Given 0,3,6, the 30000000th number spoken is 175594.
- Given 1,3,2, the 30000000th number spoken is 2578.
- Given 2,1,3, the 30000000th number spoken is 3544142.
- Given 1,2,3, the 30000000th number spoken is 261214.
- Given 2,3,1, the 30000000th number spoken is 6895259.
- Given 3,2,1, the 30000000th number spoken is 18.
- Given 3,1,2, the 30000000th number spoken is 362.
Given your starting numbers, what will be the 30000000th number spoken?

## Language used
Rust

## Solutions:
### Part 1
```rust
use std::env;

// Need to declare rounds as const because
// you can't initialize variable-length arrays
const ROUNDS: usize = 2020;

fn parse_input(input: &String) -> Vec<i32> {
    let mut startpos = Vec::new();

    for i in input.split(",") {
        startpos.push(i.parse::<i32>().unwrap());
    }

    return startpos;
}

fn find_indexes(array: &[i32], val: i32) -> Vec<usize> {
    let mut indexes = Vec::new();

    for (i, &value) in array.iter().enumerate() {
        if value == val {
            indexes.push(i);
        }
    }

    return indexes;
}

fn run_game(start_positions: Vec<i32>) -> [i32; ROUNDS] {
    // Initialize array of length ROUNDS, prefilled with zeros
    let mut values:[i32;ROUNDS] = [0; ROUNDS];

    // Keep track of current round
    let mut cur_round: usize = 0;
    println!("Will run {} rounds on {:?}", ROUNDS, start_positions);

    // Loop through starting positions
    for pos in &start_positions {
        values[cur_round] = *pos;

        cur_round = cur_round + 1;
    }

    // Run the game until <ROUNDS>-rounds
    while cur_round < ROUNDS {
        let last_entry = values[cur_round as usize - 1];

        let indexes = find_indexes(&values[0..((cur_round - 1) as usize)], last_entry);

        if indexes.len() == 0 {
            values[cur_round] = 0;
        } else {
            // println!("Current round: {}, last_entry: {}, indexes: {:?}", cur_round, last_entry, indexes);
            values[cur_round] = (cur_round - 1) as i32 - indexes[indexes.len() - 1] as i32;
        }

        cur_round = cur_round + 1;
    }

    return values;
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let start_positions = parse_input(&args[1]);

    let results = run_game(start_positions);
    println!("Last result: {}", results[results.len() - 1]);
}
```

### Part 2
```rust
use std::env;
use std::collections::HashMap;

fn parse_input(input: &String) -> Vec<i32> {
    let mut startpos = Vec::new();

    for i in input.split(",") {
        startpos.push(i.parse::<i32>().unwrap());
    }

    return startpos;
}

#[derive(Debug)]
struct RoundOccurrence {
    pub last_seen: usize,
    pub prev_seen: usize,
}

fn run_game(start_positions: Vec<i32>, rounds: usize) -> HashMap<i32, RoundOccurrence> {
    let mut values = HashMap::new();

    // Keep track of previous and new entry
    let mut last_entry = -1;
    let mut new_entry: i32;

    // Keep track of current round
    let mut cur_round: usize = 1;

    // Loop through starting positions
    for pos in &start_positions {
        values.insert(*pos, RoundOccurrence {last_seen: cur_round, prev_seen: 0});

        last_entry = *pos;
        cur_round = cur_round + 1;
    }

    // Run the game until n-rounds
    while cur_round <= rounds {
        // If last_entry didn't exist in the arr before
        if values.contains_key(&last_entry) {
            if values[&last_entry].last_seen == cur_round - 1 && values[&last_entry].prev_seen == 0 {
                new_entry = 0;
            } else {
                if (cur_round - 1) == values[&last_entry].last_seen {
                    new_entry = 1;
                } else {
                    new_entry = (cur_round - 1 - values[&last_entry].last_seen) as i32;
                }

                // Update existing to current
                values.insert(last_entry, RoundOccurrence {last_seen: cur_round - 1, prev_seen: values[&last_entry].last_seen});
            }

        } else {
            new_entry = 0;
            values.insert(last_entry, RoundOccurrence {last_seen: cur_round - 1, prev_seen: 0});
        }

        last_entry = new_entry;
        cur_round = cur_round + 1;
    }

    println!("{}", last_entry);

    return values;
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let start_positions = parse_input(&args[1]);

    let rounds = 30000000;

    run_game(start_positions, rounds);
}
```

## Source
[Part 1](./day15/day15-1.rs)
[Part 2](./day15/day15-2.rs)

## Usage
```bash
rustc -o ./built/day15-1 ./day15-1.rs
./built/day15-1 0,13,16,17,1,10,6

rustc -o ./built/day15-2 ./day15-2.rs
./built/day15-2 0,13,16,17,1,10,6
```
