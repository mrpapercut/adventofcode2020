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
