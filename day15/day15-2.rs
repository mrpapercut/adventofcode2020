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
