# Advent of Code 2020 Day 6: Custom Customs
## Description
### Part 1
As your flight approaches the regional airport where you'll switch to a much larger plane, customs declaration forms are distributed to the passengers.

The form asks a series of 26 yes-or-no questions marked a through z. All you need to do is identify the questions for which anyone in your group answers "yes". Since your group is just you, this doesn't take very long.

However, the person sitting next to you seems to be experiencing a language barrier and asks if you can help. For each of the people in their group, you write down the questions for which they answer "yes", one per line. For example:

abcx
abcy
abcz
In this group, there are 6 questions to which anyone answered "yes": a, b, c, x, y, and z. (Duplicate answers to the same question don't count extra; each question counts at most once.)

Another group asks for your help, then another, and eventually you've collected answers from every group on the plane (your puzzle input). Each group's answers are separated by a blank line, and within each group, each person's answers are on a single line. For example:
```
abc

a
b
c

ab
ac

a
a
a
a

b
```
This list represents answers from five groups:

- The first group contains one person who answered "yes" to 3 questions: a, b, and c.
- The second group contains three people; combined, they answered "yes" to 3 questions: a, b, and c.
- The third group contains two people; combined, they answered "yes" to 3 questions: a, b, and c.
- The fourth group contains four people; combined, they answered "yes" to only 1 question, a.
- The last group contains one person who answered "yes" to only 1 question, b.
- In this example, the sum of these counts is 3 + 3 + 3 + 1 + 1 = 11.

For each group, count the number of questions to which anyone answered "yes". What is the sum of those counts?

### Part 2
As you finish the last group's customs declaration, you notice that you misread one word in the instructions:

You don't need to identify the questions to which anyone answered "yes"; you need to identify the questions to which everyone answered "yes"!

Using the same example as above:
```
abc

a
b
c

ab
ac

a
a
a
a

b
```
This list represents answers from five groups:

- In the first group, everyone (all 1 person) answered "yes" to 3 questions: a, b, and c.
- In the second group, there is no question to which everyone answered "yes".
- In the third group, everyone answered yes to only 1 question, a. Since some people did not answer "yes" to b or c, they don't count.
- In the fourth group, everyone answered yes to only 1 question, a.
- In the fifth group, everyone (all 1 person) answered "yes" to 1 question, b.
- In this example, the sum of these counts is 3 + 0 + 1 + 1 + 1 = 6.

For each group, count the number of questions to which everyone answered "yes". What is the sum of those counts?

## Language used
WScript

## Solutions:
### Part 1
```js
// Array.prototype.indexOf polyfill:
if ( typeof(Array.prototype.indexOf) === 'undefined' ) {
    Array.prototype.indexOf = function(item, start) {
        var length = this.length
        start = typeof(start) !== 'undefined' ? start : 0
        for (var i = start; i < length; i++) {
            if (this[i] === item) return i
        }
        return -1
    }
}

function ReadFile(Filename) {
    var fso = WScript.CreateObject('Scripting.FileSystemObject');

    if (! fso.FileExists(Filename)) {
        WScript.Echo('File not found: ' + Filename);
        return false;
    }

    var fileObj = fso.GetFile(Filename);

    // https://docs.microsoft.com/en-us/previous-versions/windows/internet-explorer/ie-developer/windows-scripting/hwfw5c59(v=vs.84)
    var ForReading = 1;
    var Formatting = -2;
    var ts = fileObj.OpenAsTextStream(ForReading, Formatting);
    var fileContents = ts.ReadAll();
    ts.Close();

    return fileContents;
}

function CustomCustoms() {
    var inputContents = ReadFile('./input/day6.txt');
    var groups = inputContents.split('\n\n');
    var totalTally = [];

    for (var i = 0; i < groups.length; i++) {
        var answers = groups[i].split('\n');
        var tally = [];

        for (var j = 0; j < answers.length; j++) {
            var answer = answers[j].split('');
            for (var k = 0; k < answer.length; k++) {
                if (tally.indexOf(answer[k]) === -1) {
                    tally.push(answer[k]);
                }
            }
        }

        totalTally.push(tally.length);
    }

    var totalSum = 0;
    for (var i = 0; i < totalTally.length; i++) {
        totalSum += totalTally[i];
    }

    return totalSum;
}

WScript.Echo(CustomCustoms());
```
### Part 2
```js
// Array.prototype.indexOf polyfill:
if (typeof(Array.prototype.indexOf) === 'undefined') {
    Array.prototype.indexOf = function(item, start) {
        var length = this.length
        start = typeof(start) !== 'undefined' ? start : 0
        for (var i = start; i < length; i++) {
            if (this[i] === item) return i
        }
        return -1
    }
}

function ReadFile(Filename) {
    var fso = WScript.CreateObject('Scripting.FileSystemObject');

    if (! fso.FileExists(Filename)) {
        WScript.Echo('File not found: ' + Filename);
        return false;
    }

    var fileObj = fso.GetFile(Filename);

    // https://docs.microsoft.com/en-us/previous-versions/windows/internet-explorer/ie-developer/windows-scripting/hwfw5c59(v=vs.84)
    var ForReading = 1;
    var Formatting = -2;
    var ts = fileObj.OpenAsTextStream(ForReading, Formatting);
    var fileContents = ts.ReadAll();
    ts.Close();

    return fileContents;
}

function CustomCustoms() {
    var inputContents = ReadFile('./input/day6.txt');
    var groups = inputContents.split('\n\n');
    var totalTally = [];

    for (var i = 0; i < groups.length; i++) {
        var answers = groups[i].split('\n');

        if (answers.length === 1) {
            // If only 1 person answered, all answers are answered by everyone
            totalTally.push(answers[0].length);
        } else {
            // Array with all possibilities
            var possibilities = 'abcdefghijklmnopqrstuvwxyz'.split('');

            // Store obj
            var answeredPossibilities = {}

            // For each answer, incr counter of answer
            for (var j = 0; j < answers.length; j++) {
                var answer = answers[j].split('');

                for (var k = 0; k < answer.length; k++) {
                    if (answeredPossibilities.hasOwnProperty(answer[k])) {
                        answeredPossibilities[answer[k]]++;
                    } else {
                        answeredPossibilities[answer[k]] = 1;
                    }
                }
            }

            // Find total answers with counter equal to answers.length
            var tally = 0;
            for (var n in answeredPossibilities) {
                if (answeredPossibilities[n] === answers.length) tally++;
            }

            totalTally.push(tally);
        }
    }

    var totalSum = 0;
    for (var i = 0; i < totalTally.length; i++) {
        totalSum += totalTally[i];
    }

    return totalSum;
}

WScript.Echo(CustomCustoms());
```

## Source
[Part 1](./code/day6-1.js)
[Part 2](./code/day6-2.js)
