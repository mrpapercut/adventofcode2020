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
