# Advent of Code 2020 Day 18: Operation Order
## Description
### Part 1
As you look out the window and notice a heavily-forested continent slowly appear over the horizon, you are interrupted by the child sitting next to you. They're curious if you could help them with their math homework.

Unfortunately, it seems like this "math" follows different rules than you remember.

The homework (your puzzle input) consists of a series of expressions that consist of addition (+), multiplication (*), and parentheses ((...)). Just like normal math, parentheses indicate that the expression inside must be evaluated before it can be used by the surrounding expression. Addition still finds the sum of the numbers on both sides of the operator, and multiplication still finds the product.

However, the rules of operator precedence have changed. Rather than evaluating multiplication before addition, the operators have the same precedence, and are evaluated left-to-right regardless of the order in which they appear.

For example, the steps to evaluate the expression `1 + 2 * 3 + 4 * 5 + 6` are as follows:
```
1 + 2 * 3 + 4 * 5 + 6
  3   * 3 + 4 * 5 + 6
      9   + 4 * 5 + 6
         13   * 5 + 6
             65   + 6
                 71
```
Parentheses can override this order; for example, here is what happens if parentheses are added to form 1 + (2 * 3) + (4 * (5 + 6)):
```
1 + (2 * 3) + (4 * (5 + 6))
1 +    6    + (4 * (5 + 6))
     7      + (4 * (5 + 6))
     7      + (4 *   11   )
     7      +     44
            51
```
Here are a few more examples:

- `2 * 3 + (4 * 5)` becomes 26.
- `5 + (8 * 3 + 9 + 3 * 4 * 3)` becomes 437.
- `5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))` becomes 12240.
- `((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2` becomes 13632.
Before you can help with the homework, you need to understand it yourself. Evaluate the expression on each line of the homework; what is the sum of the resulting values?

### Part 2
You manage to answer the child's questions and they finish part 1 of their homework, but get stuck when they reach the next section: advanced math.

Now, addition and multiplication have different precedence levels, but they're not the ones you're familiar with. Instead, addition is evaluated before multiplication.

For example, the steps to evaluate the expression 1 + 2 * 3 + 4 * 5 + 6 are now as follows:
```
1 + 2 * 3 + 4 * 5 + 6
  3   * 3 + 4 * 5 + 6
  3   *   7   * 5 + 6
  3   *   7   *  11
     21       *  11
         231
```
Here are the other examples from above:

- `1 + (2 * 3) + (4 * (5 + 6))` still becomes 51.
- `2 * 3 + (4 * 5)` becomes 46.
- `5 + (8 * 3 + 9 + 3 * 4 * 3)` becomes 1445.
- `5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))` becomes 669060.
- `((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2` becomes 23340.
What do you get if you add up the results of evaluating the homework problems using these new rules?

## Language used
Ruby

## Solutions:
### Part 1
```rb
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
```

### Part 2
```rb
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
```

## Source
[Part 1](./day18/day18-1.rb)
[Part 2](./day18/day18-2.rb)

## Usage
```bash
ruby ./day18/day18-1.rb

ruby ./day18/day18-2.rb
```
