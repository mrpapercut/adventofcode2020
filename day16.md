# Advent of Code 2020 Day 16: Ticket Translation
## Description
### Part 1
As you're walking to yet another connecting flight, you realize that one of the legs of your re-routed trip coming up is on a high-speed train. However, the train ticket you were given is in a language you don't understand. You should probably figure out what it says before you get to the train station after the next flight.

Unfortunately, you can't actually read the words on the ticket. You can, however, read the numbers, and so you figure out the fields these tickets must have and the valid ranges for values in those fields.

You collect the rules for ticket fields, the numbers on your ticket, and the numbers on other nearby tickets for the same train service (via the airport security cameras) together into a single document you can reference (your puzzle input).

The rules for ticket fields specify a list of fields that exist somewhere on the ticket and the valid ranges of values for each field. For example, a rule like class: 1-3 or 5-7 means that one of the fields in every ticket is named class and can be any value in the ranges 1-3 or 5-7 (inclusive, such that 3 and 5 are both valid in this field, but 4 is not).

Each ticket is represented by a single line of comma-separated values. The values are the numbers on the ticket in the order they appear; every ticket has the same format. For example, consider this ticket:
```
.--------------------------------------------------------.
| ????: 101    ?????: 102   ??????????: 103     ???: 104 |
|                                                        |
| ??: 301  ??: 302             ???????: 303      ??????? |
| ??: 401  ??: 402           ???? ????: 403    ????????? |
'--------------------------------------------------------'
```
Here, ? represents text in a language you don't understand. This ticket might be represented as 101,102,103,104,301,302,303,401,402,403; of course, the actual train tickets you're looking at are much more complicated. In any case, you've extracted just the numbers in such a way that the first number is always the same specific field, the second number is always a different specific field, and so on - you just don't know what each position actually means!

Start by determining which tickets are completely invalid; these are tickets that contain values which aren't valid for any field. Ignore your ticket for now.

For example, suppose you have the following notes:
```
class: 1-3 or 5-7
row: 6-11 or 33-44
seat: 13-40 or 45-50

your ticket:
7,1,14

nearby tickets:
7,3,47
40,4,50
55,2,20
38,6,12
```
It doesn't matter which position corresponds to which field; you can identify invalid nearby tickets by considering only whether tickets contain values that are not valid for any field. In this example, the values on the first nearby ticket are all valid for at least one field. This is not true of the other three nearby tickets: the values 4, 55, and 12 are are not valid for any field. Adding together all of the invalid values produces your ticket scanning error rate: 4 + 55 + 12 = 71.

Consider the validity of the nearby tickets you scanned. What is your ticket scanning error rate?

### Part 2
Now that you've identified which tickets contain invalid values, discard those tickets entirely. Use the remaining valid tickets to determine which field is which.

Using the valid ranges for each field, determine what order the fields appear on the tickets. The order is consistent between all tickets: if seat is the third field, it is the third field on every ticket, including your ticket.

For example, suppose you have the following notes:
```
class: 0-1 or 4-19
row: 0-5 or 8-19
seat: 0-13 or 16-19

your ticket:
11,12,13

nearby tickets:
3,9,18
15,1,5
5,14,9
```
Based on the nearby tickets in the above example, the first position must be row, the second position must be class, and the third position must be seat; you can conclude that in your ticket, class is 12, row is 11, and seat is 13.

Once you work out which field is which, look for the six fields on your ticket that start with the word departure. What do you get if you multiply those six values together?

## Language used
Pascal (Free/Turbo)

## Solutions:
### Part 1
```pas
program TicketTranslation;

uses
    Classes,
    RegExpr,
    SysUtils;

type
    TicketRule = record
        r_name: string;
        r_rule: string;
    end;

    Ticket = record
        t_values: array of integer;
    end;

var
    NewTicketRule: TicketRule;
    TicketRules: array of TicketRule;
    NewTicket: Ticket;
    YourTicket: Ticket;
    NearbyTickets: array of Ticket;
    RuleRanges: array of array[0..3] of integer;
    InvalidFields: array of integer;

(* Read file *)
procedure ReadFile(filename: string);
var
    re_rules: TRegExpr;
    re_ticket: TRegExpr;
    re_yourticket: TRegExpr;
    re_nearbyticket: TRegExpr;
    fh: text;
    line: string;
    ir: integer;
    it: integer;
    isYourTicket: boolean;
    splitLine: TStringArray;
    i: integer;

begin
    re_rules := TRegExpr.Create('^([a-z\s]+):\s([0-9\-\sor]+)$');
    re_ticket := TRegExpr.Create('^([\d,]+)$');
    re_yourticket := TRegExpr.Create('^your ticket:$');
    re_nearbyticket := TRegExpr.Create('^nearby tickets:$');

    ir := 0; // Index for rules
    it := 0; // Index for tickets
    isYourTicket := false;

    assign(fh, filename);
    reset(fh);

    while not eof(fh) do
    begin
        readln(fh, line);

        if line <> '' then
        begin
            if re_rules.Exec(line) then
            begin
                NewTicketRule.r_name := re_rules.Match[1];
                NewTicketRule.r_rule := re_rules.Match[2];

                SetLength(TicketRules, Length(TicketRules) + 1);
                TicketRules[ir] := NewTicketRule;

                inc(ir);
            end

            else if re_yourticket.Exec(line) then
            begin
                isYourTicket := true;
            end

            else if re_nearbyticket.Exec(line) then
            begin
                isYourTicket := false;
            end

            else if re_ticket.Exec(line) then
            begin
                splitLine := re_ticket.Match[1].Split(',');
                SetLength(NewTicket.t_values, Length(splitLine));

                for i := 0 to Length(splitLine) - 1 do
                begin
                    if splitLine[i] <> '' then
                    begin
                        NewTicket.t_values[i] := StrToInt(splitLine[i]);
                    end;
                end;

                if isYourTicket then
                begin
                    YourTicket := NewTicket;
                end
                else
                begin
                    SetLength(NearbyTickets, Length(NearbyTickets) + 1);
                    NearbyTickets[it] := NewTicket;

                    inc(it);
                end;
            end;
        end;
    end;

    re_rules.Free();
    re_ticket.Free();
    close(fh);
end;

(* Parse ticket rules *)
procedure ParseRules();
var
    i: integer;
    j: integer;
    re_ranges: TRegExpr;

begin
    re_ranges := TRegExpr.Create('([0-9]+)');

    for i := 0 to Length(TicketRules) - 1 do
    begin
        if re_ranges.Exec(TicketRules[i].r_rule) then
        begin
            j := 0;

            SetLength(RuleRanges, Length(RuleRanges) + 1);
            RuleRanges[i][j] := StrToInt(re_ranges.Match[1]);

            while re_ranges.ExecNext do
            begin
                j := j + 1;

                RuleRanges[i][j] := StrToInt(re_ranges.Match[1]);
            end;
        end;
    end;

    re_ranges.Free();
end;

(* Check if ticket matches rules *)
procedure CheckTickets();
var
    i: integer; // NearbyTickets index
    j: integer; // NearbyTickets t_values index
    k: integer; // RuleRanges index
    validFieldFound: boolean;

begin
    for i := 0 to Length(NearbyTickets) - 1 do
    begin
        for j := 0 to Length(NearbyTickets[i].t_values) - 1 do
        begin
            validFieldFound := false;

            for k := 0 to Length(RuleRanges) - 1 do
            begin
                if ((NearbyTickets[i].t_values[j] >= RuleRanges[k][0]) and (NearbyTickets[i].t_values[j] <= RuleRanges[k][1])) or ((NearbyTickets[i].t_values[j] >= RuleRanges[k][2]) and (NearbyTickets[i].t_values[j] <= RuleRanges[k][3])) then
                begin
                    validFieldFound := true;
                end;
            end;

            if validFieldFound <> true then
            begin
                SetLength(InvalidFields, Length(InvalidFields) + 1);
                InvalidFields[Length(InvalidFields) - 1] := NearbyTickets[i].t_values[j];
            end;
        end;
    end;
end;

(* Calculate sum of invalid fields *)
procedure CalculateSum();
var
    i, sum: integer;

begin
    sum := 0;
    for i := Low(invalidFields) to High(invalidFields) do sum := sum + invalidFields[i];

    writeln('Sum: ', sum);
end;

(* Main *)
begin
    ReadFile('./day16/day16.txt');
    ParseRules();
    CheckTickets();
    CalculateSum();
end.
```

### Part 2
```pas
program TicketTranslation;

uses
    Classes,
    RegExpr,
    SysUtils;

type
    RuleRange = array[0..3] of integer;

    TicketRule = record
        r_name: string;
        r_rule: string;
        r_ranges: RuleRange;
    end;

    Ticket = record
        t_values: array of integer;
    end;

    ValidField = record
        f_name: string;
        f_index: integer;
    end;

var
    NewTicketRule: TicketRule;
    TicketRules: array of TicketRule;
    NewTicket: Ticket;
    YourTicket: Ticket;
    NearbyTickets: array of Ticket;
    InvalidTicketIDs: array of integer;
    ValidTickets: array of Ticket;
    NewValidField: ValidField;
    ValidFields: array of ValidField;
    FieldPossibilities: array[0..19] of array of ValidField;
    MatchedFields: array[0..19] of string;

(* Check if element exists in array *)
operator in(i: integer; a: array of integer) Result: Boolean;
var
    b: Integer;

begin
    Result := false;
    for b in a do begin
        Result := i = b;
        if Result then Break;
    end;
end;

(* Read file *)
procedure ReadFile(filename: string);
var
    re_rules: TRegExpr;
    re_ticket: TRegExpr;
    re_yourticket: TRegExpr;
    re_nearbyticket: TRegExpr;
    fh: text;
    line: string;
    ir: integer;
    it: integer;
    isYourTicket: boolean;
    splitLine: TStringArray;
    i: integer;

begin
    re_rules := TRegExpr.Create('^([a-z\s]+):\s([0-9\-\sor]+)$');
    re_ticket := TRegExpr.Create('^([\d,]+)$');
    re_yourticket := TRegExpr.Create('^your ticket:$');
    re_nearbyticket := TRegExpr.Create('^nearby tickets:$');

    ir := 0; // Index for rules
    it := 0; // Index for tickets
    isYourTicket := false;

    assign(fh, filename);
    reset(fh);

    while not eof(fh) do
    begin
        readln(fh, line);

        if line <> '' then
        begin
            if re_rules.Exec(line) then
            begin
                NewTicketRule.r_name := re_rules.Match[1];
                NewTicketRule.r_rule := re_rules.Match[2];

                SetLength(TicketRules, Length(TicketRules) + 1);
                TicketRules[ir] := NewTicketRule;

                inc(ir);
            end

            else if re_yourticket.Exec(line) then
            begin
                isYourTicket := true;
            end

            else if re_nearbyticket.Exec(line) then
            begin
                isYourTicket := false;
            end

            else if re_ticket.Exec(line) then
            begin
                splitLine := re_ticket.Match[1].Split(',');
                SetLength(NewTicket.t_values, Length(splitLine));

                for i := 0 to Length(splitLine) - 1 do
                begin
                    if splitLine[i] <> '' then
                    begin
                        NewTicket.t_values[i] := StrToInt(splitLine[i]);
                    end;
                end;

                if isYourTicket then
                begin
                    YourTicket := NewTicket;
                end
                else
                begin
                    SetLength(NearbyTickets, Length(NearbyTickets) + 1);
                    NearbyTickets[it] := NewTicket;

                    inc(it);
                end;
            end;
        end;
    end;

    re_rules.Free();
    re_ticket.Free();
    close(fh);
end;

(* Parse ticket rules *)
procedure ParseRules();
var
    i: integer;
    j: integer;
    re_ranges: TRegExpr;

begin
    re_ranges := TRegExpr.Create('([0-9]+)');

    for i := 0 to Length(TicketRules) - 1 do
    begin
        if re_ranges.Exec(TicketRules[i].r_rule) then
        begin
            j := 0;

            TicketRules[i].r_ranges[j] := StrToInt(re_ranges.Match[1]);

            while re_ranges.ExecNext do
            begin
                j := j + 1;

                TicketRules[i].r_ranges[j] := StrToInt(re_ranges.Match[1]);
            end;
        end;
    end;

    re_ranges.Free();
end;

(* Check if ticket matches rules *)
procedure CheckTickets();
var
    i: integer; // NearbyTickets index
    j: integer; // NearbyTickets t_values index
    k: integer; // RuleRanges index
    validFieldFound: boolean;

begin
    for i := 0 to Length(NearbyTickets) - 1 do
    begin
        for j := 0 to Length(NearbyTickets[i].t_values) - 1 do
        begin
            validFieldFound := false;

            for k := 0 to Length(TicketRules) - 1 do
            begin
                if ((NearbyTickets[i].t_values[j] >= TicketRules[k].r_ranges[0]) and (NearbyTickets[i].t_values[j] <= TicketRules[k].r_ranges[1]))
                or ((NearbyTickets[i].t_values[j] >= TicketRules[k].r_ranges[2]) and (NearbyTickets[i].t_values[j] <= TicketRules[k].r_ranges[3])) then
                begin
                    validFieldFound := true;
                end;
            end;

            if validFieldFound <> true then
            begin
                SetLength(InvalidTicketIDs, Length(InvalidTicketIDs) + 1);
                InvalidTicketIDs[Length(InvalidTicketIDs) - 1] := i;
            end;
        end;
    end;
end;

(* Filter invalid tickets *)
procedure FilterInvalidTickets();
var
    i, j: integer;

begin
    j := 0; // ValidTickets index
    for i := 0 to Length(NearbyTickets) - 1 do
    begin
        if not (i in InvalidTicketIDs) then
        begin
            SetLength(ValidTickets, Length(ValidTickets) + 1);
            ValidTickets[j] := NearbyTickets[i];

            inc(j);
        end;
    end;
end;

(* Match rules to field *)
procedure MatchRules();
var
    i: integer; // Fields index
    j: integer; // Rules index
    k: integer; // Ticket index
    l: integer; // ValidFields index
    validCount: integer;

begin
    l := 0;

    for i := 0 to Length(ValidTickets[0].t_values) - 1 do // Assuming each ticket has an identical field-count
    begin
        for j := 0 to Length(TicketRules) - 1 do
        begin
            validCount := 0;
            for k := 0 to Length(ValidTickets) - 1 do
            begin
                if ((ValidTickets[k].t_values[i] >= TicketRules[j].r_ranges[0]) and (ValidTickets[k].t_values[i] <= TicketRules[j].r_ranges[1]))
                or ((ValidTickets[k].t_values[i] >= TicketRules[j].r_ranges[2]) and (ValidTickets[k].t_values[i] <= TicketRules[j].r_ranges[3])) then
                begin
                    validCount := validCount + 1;
                end;
            end;

            if validCount = Length(ValidTickets) then
            begin
                NewValidField.f_index := i;
                NewValidField.f_name := TicketRules[j].r_name;

                SetLength(ValidFields, Length(ValidFields) + 1);
                ValidFields[l] := NewValidField;

                inc(l);
            end;
        end;
    end;
end;

procedure SortFieldsByPossibilities();
var
    i, j: integer;
    temp: array of ValidField;

begin
    for i := Length(FieldPossibilities) - 1 DownTo 0 do
    begin
        for j := 1 to i do
        begin
            if (Length(FieldPossibilities[j - 1]) > Length(FieldPossibilities[j])) then
            begin
                SetLength(temp, Length(FieldPossibilities[j - 1]));
                temp := FieldPossibilities[j - 1];
                FieldPossibilities[j - 1] := FieldPossibilities[j];
                FieldPossibilities[j] := temp;
            end;
        end;
    end;
end;

procedure SeaveFields();
var
    i, j: integer;
    k: integer; // FieldPossibilities index
    foundField: boolean;

begin
    for i := 0 to Length(ValidTickets[0].t_values) - 1 do
    begin
        k := 0;

        for j := 0 to Length(ValidFields) - 1 do
        begin
            if ValidFields[j].f_index = i then
            begin
                SetLength(FieldPossibilities[i], Length(FieldPossibilities[i]) + 1);
                FieldPossibilities[ValidFields[j].f_index][k] := ValidFields[j];

                inc(k);
            end;
        end;
    end;

    SortFieldsByPossibilities();

    for i := 0 to Length(FieldPossibilities) - 1 do
    begin
        for j := 0 to Length(FieldPossibilities[i]) - 1 do
        begin
            foundField := false;

            for k := 0 to Length(MatchedFields) - 1 do
            begin
                if FieldPossibilities[i][j].f_name = MatchedFields[k] then
                begin
                    foundField := true;
                end;
            end;

            if foundField <> true then
            begin
                MatchedFields[FieldPossibilities[i][j].f_index] := FieldPossibilities[i][j].f_name;
            end;
        end;
    end;
end;

(* Main *)
var
    i: integer;
    product: int64;

begin
    ReadFile('./day16/day16.txt');
    ParseRules();
    CheckTickets();
    FilterInvalidTickets();

    writeln('# Valid tickets: ', Length(ValidTickets));
    MatchRules();
    SeaveFields();

    product := 1;
    for i := 0 to Length(MatchedFields) - 1 do
    begin
        if pos('departure', MatchedFields[i]) = 1 then
        begin
            writeln('Column ', i, ' is ', MatchedFields[i], '. On your ticket this value is ', YourTicket.t_values[i]);
            product := product * YourTicket.t_values[i];
        end;
    end;

    writeln('Total product of all values where rule starts with ''Departure'': ', product);
end.
```

## Source
[Part 1](./day16/day16-1.pas)
[Part 2](./day16/day16-2.pas)

## Usage
```bash
fpc ./day16/day16-1.pas -o./built/day16-1
./built/day16-1

fpc ./day16/day16-2.pas -o./built/day16-2
./built/day16-2
```
