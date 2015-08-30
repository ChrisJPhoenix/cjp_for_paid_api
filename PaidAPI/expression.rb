# Parses and stores an expression as a tree-like object; can evaluate the tree.

class Expression
  def initialize(string)
    @string = string
    parse(string)
  end

  # I can't handle unary minus properly yet. And chained operators 10/5/4 don't work yet.

  # Assuming n is the length of the string:

  # string.split is O(n) (for short RE's). If I split the string equally the runtime would be O(n log(n)).
  # Since I split from the left into only 2 pieces (and then stop) a string like 2+2+2+2+2 will not be O(n^2)
  # but only O(n). Since there are only a few precedences, and thus a few passes through the string,
  # I'm going to say this whole tree-formation process is O(n).
  def parse(string)
    left, right = string.split(/[\+-]/, 2)
    if right
      if left == '' # unary -
        @integer = - right.to_i
      else
        @operator = string[left.length]
        @children = [Expression.new(left), Expression.new(right)]
      end
    else
      left, right = string.split(/[*\/]/, 2)
      if right
        @operator = string[left.length]
        @children = [Expression.new(left), Expression.new(right)]
      else # just a number
        @integer = left.to_i
      end
    end
  end

  # The number of nodes is proportional to the length of the string, since every node consumes at least
  # one character. Time to evaluate the value of each node is constant (not counting time to evaluate children)
  # so time to calculate value of an expression is O(n).
  def value
    case @operator
      when '+'
        return @children[0].value + @children[1].value
      when '-'
        return @children[0].value - @children[1].value
      when '*'
        return @children[0].value * @children[1].value
      when '/'
        return @children[0].value / @children[1].value
      else
        return @integer
    end
  end
end

