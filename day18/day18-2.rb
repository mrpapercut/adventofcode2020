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
        mult = 1

        expr = expr.delete(' ')
        exprarr = expr.split('')

        idx = 0
        while idx < exprarr.length
            token = exprarr[idx]

            if @digits.include?(token)
                val = Integer(token)
                acc += val * mult
            elsif '*' == token
                mult = acc
                acc = 0
            elsif @lbracket == token
                endIndex = self.findMatchingBracket(exprarr, idx)
                subexpr = expr[idx + 1..endIndex - 1]
                val = self.evaluate(subexpr)
                acc += val * mult
                idx = endIndex
            elsif @rbracket == token
                break;
            end

            idx += 1
        end

        return acc
    end
end

oo = OperationOrder.new('./day18/day18.txt')

puts("Total sum: #{oo.evalInput()}")

=begin
expressions = {
    # challenge examples
    '231' => '1 + 2 * 3 + 4 * 5 + 6',
    '51' => '1 + (2 * 3) + (4 * (5 + 6))',
    '46' => '2 * 3 + (4 * 5)',
    '1445' => '5 + (8 * 3 + 9 + 3 * 4 * 3)',
    '669060' => '5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))',
    '23340' => '((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2'
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
