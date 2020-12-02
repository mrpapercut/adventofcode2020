const values = '<input list>'; // ./input/day1.txt
for (let i in values) {
  for (let j in values) {
    for (let k in values) {
      if (values[i] + values[j] + values[k] === 2020) console.log(values[i], values[j], values[k])
    }
  }
}