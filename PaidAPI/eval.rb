
# Break up string into an array of integer-strings and "other" characters (operators and parens).
# Don't try to handle integer minus - regexp could, but would be very hard-to-maintain code.
# Should be O(n) with sane implementation of regex and scan. Might should precompile the regex
# but this is only called once per input string.
def tokenize(string)
  string.scan(/[+*\/()-]|\d+/)
end

# Count from current pos to balanced closing paren. Return value of enclosed
# expression (via recursive call) and position of closing paren.
# This is O(n^2) for deeply nested parens; that would be avoidable by eval'ing
# sub-parens as soon as they're seen, but that would complexify the code a bit.
def eval_parens(tokens, current_pos)
  paren_count = 1
  start_sub = current_pos + 1
  while paren_count != 0
    current_pos += 1
    case tokens[current_pos]
      when '('
        paren_count += 1
      when ')'
        paren_count -= 1
    end
  end
  return eval_tokens(tokens[start_sub...current_pos]), current_pos
end

# Integer math? floating point math? infinite precision math? Return
# the right kind of object here.
def string_to_number(string)
  string.to_f
end

# Scans and cleans up () and unary minus, returning a new array. This is O(n) except
# for the cost of building a dynamic array incrementally in Ruby (n log n?) - could
# reduce to O(n) by preallocating the array (it'll be <= length of original) or
# modifying original in place (uglier code).
def handle_parens_unary_minus(tokens)
  handled = []
  current_pos = 0
  minus_is_unary = true
  while current_pos < tokens.length
#    puts "handled #{handled}, cp #{current_pos}, miu #{minus_is_unary}, tokens remain #{tokens[current_pos..-1]}"
    case tokens[current_pos]
      when '('
        last_value, current_pos = eval_parens(tokens, current_pos)
        handled.push(last_value)
        minus_is_unary = false
      when '+', '-', '*', '/'
        if (minus_is_unary)
          minus_is_unary = false
          if tokens[current_pos] == '-'
            handled.push(-string_to_number(tokens[current_pos+1]))
            current_pos += 1
          else
            raise "Oops, unexpected operator #{tokens[current_pos]}"
          end
        else
          minus_is_unary = true
          handled.push(tokens[current_pos])
        end
      else
        handled.push(string_to_number(tokens[current_pos]))
        minus_is_unary = false
    end
    current_pos += 1
  end
  handled
end

# Scans a list of numbers, +, and -, accumulating and returning the result.
def handle_plus_minus(tokens)
  last_value = 0
  last_op = '+'
  tokens.each do |token|
    case token
      when '+', '-'
        last_op = token
      else
        last_value = (last_op == '+') ? last_value + token : last_value - token
    end
  end
  last_value
end

# Scans a list of numbers, *, /, +, -, building a new array with the * and / evaluated.
# Again, O(n) except for dynamic array cost.
def handle_times_divide(tokens)
#  puts "HTD called with tokens #{tokens}"
  result = [tokens[0]]
  pending_op = nil
  tokens[1..-1].each do |token|
    case token
      when '+', '-'
        result.push(token)
      when '*', '/'
        pending_op = token
      else
        case pending_op
          when '*'
            result[-1] *= token
          when '/'
            result[-1] /= token
          else
            result.push(token)
        end
        pending_op = nil
    end
  end
  result
end

# Scans the list of tokens (numbers and operator chars) and handles the
# operator chars in stages. Called recursively to handle parens. Cost is
# sum of costs of subsidiary functions - thus, max/worst cost of any of
# them (in this code, O(n^2)).
def eval_tokens(tokens)
  handle_plus_minus(handle_times_divide(handle_parens_unary_minus(tokens)))
end

def value_of(string)
#  puts " * * VO #{string}"
  eval_tokens(tokenize(string))
end

