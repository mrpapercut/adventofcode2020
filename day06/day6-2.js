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
    var wsh = WScript.CreateObject('WScript.Shell');
    var fso = WScript.CreateObject('Scripting.FileSystemObject');

    var absFilepath = fso.BuildPath(wsh.CurrentDirectory, Filename);

    if (! fso.FileExists(absFilepath)) {
        WScript.Echo('File not found: ' + absFilepath);
        return false;
    }

    var fileObj = fso.GetFile(absFilepath);

    // https://docs.microsoft.com/en-us/previous-versions/windows/internet-explorer/ie-developer/windows-scripting/hwfw5c59(v=vs.84)
    var ForReading = 1;
    var Formatting = -2;
    var ts = fileObj.OpenAsTextStream(ForReading, Formatting);
    var fileContents = ts.ReadAll();
    ts.Close();

    return fileContents;
}

function CustomCustoms() {
    var inputContents = ReadFile('./day06/day6.txt');
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
