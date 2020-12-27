include std/console.e
include std/convert.e
include std/sequence.e
include std/sort.e
include std/regex.e as re
include std/text.e
include std/wildcard.e

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
