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
