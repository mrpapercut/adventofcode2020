class OperationOrder
    def initialize(filename)
        @filename = filename
        @filecontents = IO.readlines(@filename);

        @digits = '0123456789'.split('')
        @operators = '+-*/'.split('')
        @lbracket = '('
        @rbracket = ')'
    end

    def evalInput()
        totalsum = 0

        @filecontents.each do |expr|
            puts("Expression: #{expr}")
            res = self.evaluate(expr)
            puts(res)
            totalsum += res
        end

        return totalsum
    end

    def findMatchingBracket(expr, startIndex = 0)
        i = startIndex + 1
        bc = 0 # Bracket counter
        endIndex = nil

        while i < expr.length do
            if expr[i] == @lbracket
                bc += 1
            elsif expr[i] == @rbracket
                if bc == 0
                    endIndex = i
                else
                    bc -= 1
                end
            end

            i += 1
        end

        return endIndex
    end

    def evaluate(expr)
        acc = 0
        op = '+'

        expr = expr.delete(' ')
        exprarr = expr.split('')

        idx = 0
        while idx < exprarr.length
            token = exprarr[idx]

            if @digits.include?(token)
                val = Integer(token)
                acc = self.evalExpr(acc, val, op)
            elsif @operators.include?(token)
                op = token
            elsif @lbracket == token
                endIndex = self.findMatchingBracket(exprarr, idx)
                subexpr = expr[idx + 1..endIndex - 1]
                val = self.evaluate(subexpr)
                acc = self.evalExpr(acc, val, op)
                idx = endIndex
            elsif @rbracket == token
                break;
            end

            idx += 1
        end

        return acc
    end

    def evalExpr(d1, d2, op)
        e = 0

        case op
        when '+'
            e = Integer(d1) + Integer(d2)
        when '*'
            e = Integer(d1) * Integer(d2)
        end

        return e
    end
end

oo = OperationOrder.new('./day18/day18.txt')

puts("Total sum: #{oo.evalInput()}")

=begin
expressions = {
    # own examples
    '79' => '1 + ((1 + 1) * (3)) + (4 * (5 + 6 + 7))',
    '7' => '1 + ((1 + 1) * 3)',
    '3' => '1 + (1 + 1)',
    '9' => '1 + 2 * 3',
    '44' => '(4 * (5 + 6))',
    '71' => '1 + 2 * 3 + 4 * 5 + 6',
    # challenge examples
    '26' => '2 * 3 + (4 * 5)',
    '437' => '5 + (8 * 3 + 9 + 3 * 4 * 3)',
    '12240' => '5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))',
    '13632' => '((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2'
}

expressions.each do |value, expr|
    puts("Initial expression: #{expr} should evaluate to #{value}")
    res = oo.evaluate(expr)
    if (res == Integer(value))
        puts("#{res}\n\n\n")
    else
        puts("Total should be #{value}, is #{res}\n\n\n")
    end
end
=end
