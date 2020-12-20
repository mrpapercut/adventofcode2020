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
