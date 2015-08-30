load 'expression.rb'

def value_of(string)
  Expression.new(string).value
end

def test(str, number)
  result = value_of(str)
  if result != number
    raise "'#{str}' gives result #{result} not equal to #{number}"
  end
end


test('3*4+5', 17)
test('-4', -4)
test('3+4', 7)
test('4*5', 20)
test('3+3+4', 10)
test('6-3-1', 2)
test('3+4*5', 23)
test('5-7', -2)
test('10/5', 2)
test('4*-5', -20)
test('-4*5', -20)
test('-4*-5', 20)
test('10/5/4', 0.5)


puts "All tests completed."
