# Advent of Code 2020 Day 19: Monster Messages
## Description
### Part 1
You land in an airport surrounded by dense forest. As you walk to your high-speed train, the Elves at the Mythical Information Bureau contact you again. They think their satellite has collected an image of a sea monster! Unfortunately, the connection to the satellite is having problems, and many of the messages sent back from the satellite have been corrupted.

They sent you a list of the rules valid messages should obey and a list of received messages they've collected so far (your puzzle input).

The rules for valid messages (the top part of your puzzle input) are numbered and build upon each other. For example:
```
0: 1 2
1: "a"
2: 1 3 | 3 1
3: "b"
```
Some rules, like 3: "b", simply match a single character (in this case, b).

The remaining rules list the sub-rules that must be followed; for example, the rule 0: 1 2 means that to match rule 0, the text being checked must match rule 1, and the text after the part that matched rule 1 must then match rule 2.

Some of the rules have multiple lists of sub-rules separated by a pipe (|). This means that at least one list of sub-rules must match. (The ones that match might be different each time the rule is encountered.) For example, the rule 2: 1 3 | 3 1 means that to match rule 2, the text being checked must match rule 1 followed by rule 3 or it must match rule 3 followed by rule 1.

Fortunately, there are no loops in the rules, so the list of possible matches will be finite. Since rule 1 matches a and rule 3 matches b, rule 2 matches either ab or ba. Therefore, rule 0 matches aab or aba.

Here's a more interesting example:
```
0: 4 1 5
1: 2 3 | 3 2
2: 4 4 | 5 5
3: 4 5 | 5 4
4: "a"
5: "b"
```
Here, because rule 4 matches a and rule 5 matches b, rule 2 matches two letters that are the same (aa or bb), and rule 3 matches two letters that are different (ab or ba).

Since rule 1 matches rules 2 and 3 once each in either order, it must match two pairs of letters, one pair with matching letters and one pair with different letters. This leaves eight possibilities: aaab, aaba, bbab, bbba, abaa, abbb, baaa, or babb.

Rule 0, therefore, matches a (rule 4), then any of the eight options from rule 1, then b (rule 5): aaaabb, aaabab, abbabb, abbbab, aabaab, aabbbb, abaaab, or ababbb.

The received messages (the bottom part of your puzzle input) need to be checked against the rules so you can determine which are valid and which are corrupted. Including the rules and the messages together, this might look like:
```
0: 4 1 5
1: 2 3 | 3 2
2: 4 4 | 5 5
3: 4 5 | 5 4
4: "a"
5: "b"

ababbb
bababa
abbbab
aaabbb
aaaabbb
```
Your goal is to determine the number of messages that completely match rule 0. In the above example, ababbb and abbbab match, but bababa, aaabbb, and aaaabbb do not, producing the answer 2. The whole message must match all of rule 0; there can't be extra unmatched characters in the message. (For example, aaaabbb might appear to match rule 0 above, but it has an extra unmatched b on the end.)

How many messages completely match rule 0?

### Part 2
As you look over the list of messages, you realize your matching rules aren't quite right. To fix them, completely replace rules 8: 42 and 11: 42 31 with the following:
```
8: 42 | 42 8
11: 42 31 | 42 11 31
```
This small change has a big impact: now, the rules do contain loops, and the list of messages they could hypothetically match is infinite. You'll need to determine how these changes affect which messages are valid.

Fortunately, many of the rules are unaffected by this change; it might help to start by looking at which rules always match the same set of values and how those rules (especially rules 42 and 31) are used by the new versions of rules 8 and 11.

(Remember, you only need to handle the rules you have; building a solution that could handle any hypothetical combination of rules would be significantly more difficult.)

For example:
```
42: 9 14 | 10 1
9: 14 27 | 1 26
10: 23 14 | 28 1
1: "a"
11: 42 31
5: 1 14 | 15 1
19: 14 1 | 14 14
12: 24 14 | 19 1
16: 15 1 | 14 14
31: 14 17 | 1 13
6: 14 14 | 1 14
2: 1 24 | 14 4
0: 8 11
13: 14 3 | 1 12
15: 1 | 14
17: 14 2 | 1 7
23: 25 1 | 22 14
28: 16 1
4: 1 1
20: 14 14 | 1 15
3: 5 14 | 16 1
27: 1 6 | 14 18
14: "b"
21: 14 1 | 1 14
25: 1 1 | 1 14
22: 14 14
8: 42
26: 14 22 | 1 20
18: 15 15
7: 14 5 | 1 21
24: 14 1

abbbbbabbbaaaababbaabbbbabababbbabbbbbbabaaaa
bbabbbbaabaabba
babbbbaabbbbbabbbbbbaabaaabaaa
aaabbbbbbaaaabaababaabababbabaaabbababababaaa
bbbbbbbaaaabbbbaaabbabaaa
bbbababbbbaaaaaaaabbababaaababaabab
ababaaaaaabaaab
ababaaaaabbbaba
baabbaaaabbaaaababbaababb
abbbbabbbbaaaababbbbbbaaaababb
aaaaabbaabaaaaababaa
aaaabbaaaabbaaa
aaaabbaabbaaaaaaabbbabbbaaabbaabaaa
babaaabbbaaabaababbaabababaaab
aabbbbbaabbbaaaaaabbbbbababaaaaabbaaabba
```
Without updating rules 8 and 11, these rules only match three messages: bbabbbbaabaabba, ababaaaaaabaaab, and ababaaaaabbbaba.

However, after updating rules 8 and 11, a total of 12 messages match:
```
bbabbbbaabaabba
babbbbaabbbbbabbbbbbaabaaabaaa
aaabbbbbbaaaabaababaabababbabaaabbababababaaa
bbbbbbbaaaabbbbaaabbabaaa
bbbababbbbaaaaaaaabbababaaababaabab
ababaaaaaabaaab
ababaaaaabbbaba
baabbaaaabbaaaababbaababb
abbbbabbbbaaaababbbbbbaaaababb
aaaaabbaabaaaaababaa
aaaabbaabbaaaaaaabbbabbbaaabbaabaaa
aabbbbbaabbbaaaaaabbbbbababaaaaabbaaabba
```
After updating rules 8 and 11, how many messages completely match rule 0?

## Language used
Euphoria

## Solutions:
### Part 1
```ex
include std/console.e
include std/convert.e
include std/sequence.e
include std/sort.e
include std/regex.e as re
include std/text.e
include std/wildcard.e

procedure testregex()
    sequence reparts = {}
    sequence rp1 = "([A-Za-z]+)"
    sequence rp2 = "([0-9]+)"

    reparts = append(reparts, rp1)
    reparts = append(reparts, rp2)

    sequence reparts2 = join(reparts)

    regex r = re:new(reparts2)

    sequence strtomatch = "John 2355"

    object res = re:find(r, strtomatch)
    for i = 1 to length(res) do
        display(strtomatch[res[i][1]..res[i][2]])
    end for

    display("abc" & "def")
end procedure

function readFile(sequence filename)
    sequence contents = {}

    integer fh = open(filename, "r")

    if fh = -1 then
        puts(2, "Couldn't open file")
    else
        while 1 do
            object line = gets(fh)
            if atom(line) then
                exit
            end if

            contents = append(contents, line[1..length(line) - 1]) -- Remove newline at end
        end while
    end if

    return contents
end function

function getRuleById(sequence rules, integer id)
    integer idx = 0
    for i = 1 to length(rules) do
        if equal(rules[i][1], id) then
            idx = i
        end if
    end for

    return idx
end function

function sortRulesById(object a, object b)
    return compare(a[1], b[1])
end function

function parseRules(sequence filename)
    sequence filecontents = readFile(filename)
    sequence rules = {}
    regex r = re:new("^([0-9]+): (.*)$")

    for i = 1 to length(filecontents) do
        object res = re:find(r, filecontents[i])
        sequence parsedRule = {to_integer(filecontents[i][res[2][1]..res[2][2]]), filecontents[i][res[3][1]..res[3][2]]}
        parsedRule[2] = remove_all('"', parsedRule[2])

        rules = append(rules, parsedRule)
    end for

    rules = custom_sort(routine_id("sortRulesById"), rules)

    return rules
end function

function loopRules(sequence rules, sequence rulevals, sequence regexp = "")
    sequence tmp_regexp = ""

    for i = 1 to length(rulevals) do
        integer ruleno = to_integer(rulevals[i])
        integer ruleid = getRuleById(rules, ruleno)

        if equal(rules[ruleid][2], "a") or equal(rules[ruleid][2], "b") then
            tmp_regexp = tmp_regexp & rules[ruleid][2]
        else
            sequence ruleopts = stdseq:split(rules[ruleid][2], " | ")
            sequence subregexes = {}
            for j = 1 to length(ruleopts) do
                subregexes = append(subregexes, loopRules(rules, stdseq:split(ruleopts[j]), regexp))
            end for

            tmp_regexp = tmp_regexp & "(" & join(subregexes, "|") & ")"
        end if
    end for

    regexp = regexp & tmp_regexp

    return regexp
end function

function createRegexp(sequence rules)
    integer rule0 = getRuleById(rules, 0)

    sequence rule0vals = stdseq:split(rules[rule0][2])
    sequence regexp = ""

    regexp = "^" & loopRules(rules, rule0vals) & "$"

    return regexp
end function

function countMatches(sequence regexp, sequence values)
    integer count = 0

    regex r = re:new(regexp)

    for i = 1 to length(values) do
        if re:is_match(r, values[i]) then
            count = count + 1
        end if
    end for

    return count
end function

procedure main()
    sequence rulesfile = "./day19/day19-rules.txt"
    sequence valuesfile = "./day19/day19-values.txt"

    sequence values = readFile(valuesfile)

    sequence parsedRules = parseRules(rulesfile)
    sequence createdRegexp = createRegexp(parsedRules)

    display(countMatches(createdRegexp, values))
end procedure

main()
```

### Part 2
```ex
include std/console.e
include std/convert.e
include std/sequence.e
include std/sort.e
include std/regex.e as re
include std/text.e
include std/wildcard.e

procedure testregex()
    sequence reparts = {}
    sequence rp1 = "([A-Za-z]+)"
    sequence rp2 = "([0-9]+)"

    reparts = append(reparts, rp1)
    reparts = append(reparts, rp2)

    sequence reparts2 = join(reparts)

    regex r = re:new(reparts2)

    sequence strtomatch = "John 2355"

    object res = re:find(r, strtomatch)
    for i = 1 to length(res) do
        display(strtomatch[res[i][1]..res[i][2]])
    end for

    display("abc" & "def")
end procedure

function readFile(sequence filename)
    sequence contents = {}

    integer fh = open(filename, "r")

    if fh = -1 then
        puts(2, "Couldn't open file")
    else
        while 1 do
            object line = gets(fh)
            if atom(line) then
                exit
            end if

            contents = append(contents, line[1..length(line) - 1]) -- Remove newline at end
        end while
    end if

    return contents
end function

function getRuleById(sequence rules, integer id)
    integer idx = 0
    for i = 1 to length(rules) do
        if equal(rules[i][1], id) then
            idx = i
        end if
    end for

    return idx
end function

function sortRulesById(object a, object b)
    return compare(a[1], b[1])
end function

function parseRules(sequence filename)
    sequence filecontents = readFile(filename)
    sequence rules = {}
    regex r = re:new("^([0-9]+): (.*)$")

    for i = 1 to length(filecontents) do
        object res = re:find(r, filecontents[i])
        sequence parsedRule = {to_integer(filecontents[i][res[2][1]..res[2][2]]), filecontents[i][res[3][1]..res[3][2]]}
        parsedRule[2] = remove_all('"', parsedRule[2])

        if equal(parsedRule[1], 8) then
            parsedRule[2] = "42 | 42 42 | 42 42 42 | 42 42 42 42 | 42 42 42 42 42"
        elsif equal(parsedRule[1], 11) then
            parsedRule[2] = "42 31 | 42 42 31 31 | 42 42 42 31 31 31 | 42 42 42 42 31 31 31 31 | 42 42 42 42 42 31 31 31 31 31"
        end if

        rules = append(rules, parsedRule)
    end for

    rules = custom_sort(routine_id("sortRulesById"), rules)

    return rules
end function

function loopRules(sequence rules, sequence rulevals, sequence regexp = "")
    sequence tmp_regexp = ""

    for i = 1 to length(rulevals) do
        integer ruleno = to_integer(rulevals[i])
        integer ruleid = getRuleById(rules, ruleno)

        if equal(rules[ruleid][2], "a") or equal(rules[ruleid][2], "b") then
            tmp_regexp = tmp_regexp & rules[ruleid][2]
        else
            sequence ruleopts = stdseq:split(rules[ruleid][2], " | ")
            sequence subregexes = {}
            for j = 1 to length(ruleopts) do
                subregexes = append(subregexes, loopRules(rules, stdseq:split(ruleopts[j]), regexp))
            end for

            tmp_regexp = tmp_regexp & "(" & join(subregexes, "|") & ")"
        end if
    end for

    regexp = regexp & tmp_regexp

    return regexp
end function

function createRegexp(sequence rules)
    integer rule0 = getRuleById(rules, 0)

    sequence rule0vals = stdseq:split(rules[rule0][2])
    sequence regexp = ""

    regexp = "^" & loopRules(rules, rule0vals) & "$"

    return regexp
end function

function countMatches(sequence regexp, sequence values)
    integer count = 0

    regex r = re:new(regexp)

    for i = 1 to length(values) do
        if re:is_match(r, values[i]) then
            count = count + 1
        end if
    end for

    return count
end function

procedure main()
    sequence rulesfile = "./day19/day19-rules.txt"
    sequence valuesfile = "./day19/day19-values.txt"

    sequence values = readFile(valuesfile)

    sequence parsedRules = parseRules(rulesfile)
    sequence createdRegexp = createRegexp(parsedRules)

    display(countMatches(createdRegexp, values))
end procedure

main()
```

## Source
[Part 1](./day19/day19-1.ex)
[Part 2](./day19/day19-2.ex)

## Usage
```ps1
C:\Euphoria\bin\eui.exe .\day19\day19-1.ex

C:\Euphoria\bin\eui.exe .\day19\day19-2.ex
```
