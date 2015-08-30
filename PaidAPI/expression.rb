# Parses and stores an expression as a tree-like object; can evaluate the tree.

class Expression
  def initialize(string)
    @string = string
    parse(string)
  end

  # I can't handle unary minus properly yet.
  # Unary minus needs precedence higher than * or / but binary minus is lower. I should use an RE
  # to separate out the unary-minus integers - easily done, search for - with operator or ^ in
  # front of it. But I'm running out of time, and my code structure would have to change.

  # And chained operators 10/5/4 don't work yet.
  # I should have thought through the order of evaluation before I started coding. The
  # way I build the tree, 6-3-1 evaluates 3-1 first. I should start from the right hand side
  # but there's no "rsplit" so I could reverse the string and split, or do all the splits at
  # once and reassemble... and I have 5 minutes left.

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

