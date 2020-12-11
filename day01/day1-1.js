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
