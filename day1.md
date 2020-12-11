# Advent of Code 2020 Day 1: Report Repair
## Description
### Part 1
After saving Christmas five years in a row, you've decided to take a vacation at a nice resort on a tropical island. Surely, Christmas will go on without you.

The tropical island has its own currency and is entirely cash-only. The gold coins used there have a little picture of a starfish; the locals just call them stars. None of the currency exchanges seem to have heard of them, but somehow, you'll need to find fifty of these coins by the time you arrive so you can pay the deposit on your room.

To save your vacation, you need to get all fifty stars by December 25th.

Collect stars by solving puzzles. Two puzzles will be made available on each day in the Advent calendar; the second puzzle is unlocked when you complete the first. Each puzzle grants one star. Good luck!

Before you leave, the Elves in accounting just need you to fix your expense report (your puzzle input); apparently, something isn't quite adding up.

Specifically, they need you to find the two entries that sum to 2020 and then multiply those two numbers together.

For example, suppose your expense report contained the following:
```
1721
979
366
299
675
1456
```
In this list, the two entries that sum to 2020 are 1721 and 299. Multiplying them together produces 1721 * 299 = 514579, so the correct answer is 514579.

Of course, your expense report is much larger. Find the two entries that sum to 2020; what do you get if you multiply them together?

### Part 2
The Elves in accounting are thankful for your help; one of them even offers you a starfish coin they had left over from a past vacation. They offer you a second one if you can find three numbers in your expense report that meet the same criteria.

Using the above example again, the three entries that sum to 2020 are 979, 366, and 675. Multiplying them together produces the answer, 241861950.

In your expense report, what is the product of the three entries that sum to 2020?

## Language used
Javascript

## Solutions:
### Part 1:
```js
const fs = require('fs').promises;
const path = require('path');

const ReportRepair = async () => { 
    const inputlist = await fs.readFile(path.resolve(__dirname, './day1.txt'), 'utf8');

    const values = inputlist.split('\n').map(c => parseInt(c, 10));
    let matched = 0;
    for (let i in values) {
        for (let j in values) {
            if (values[i] + values[j] === 2020) {
                matched = values[i] * values[j];
                console.log(matched);

                return;
            }
        }
    }
};

ReportRepair();
```

### Part 2:
```js
const fs = require('fs').promises;
const path = require('path');

const ReportRepair = async () => { 
    const inputlist = await fs.readFile(path.resolve(__dirname, './day1.txt'), 'utf8');

    const values = inputlist.split('\n').map(c => parseInt(c, 10));
    for (let i in values) {
        for (let j in values) {
            for (let k in values) {
                if (values[i] + values[j] + values[k] === 2020) {
                    matched = values[i] * values[j] * values[k];
                    console.log(matched);
    
                    return;
                }
            }
        }
    }
};

ReportRepair();
```

## Source
[Part 1](./day01/day1-1.js)
[Part 2](./day01/day1-2.js)

## Usage
```bash
node ./day01/day1-1.js

node ./day01/day1-2.js
```
