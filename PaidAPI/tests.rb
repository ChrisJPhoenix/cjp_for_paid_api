load 'expression.rb'

def test(a, b)
  result = Expression.new(a).value
  if result != b
    raise "'#{a}' gives result #{result} not equal to #{b}"
  end
end


test('3*4+5', 17)
test('-4', -4)
test('3+4', 7)
test('4*5', 20)
test('3+4*5', 23)
test('5-7', -2)
test('10/5', 2)
test('10/5/4', 0.5)
test('4*-5', -20)
test('-4*5', -20)
test('-4*-5', 20)


puts "All tests completed."
