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
