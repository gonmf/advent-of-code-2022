input = File.read('21.input').split("\n").map(&:strip)

# problem 1

monkeys = {}

input.each do |line|
  line.sub(':', '').split(' ')

  id, num_or_a, oper, b = line.sub(':', '').split(' ')

  if oper
    monkeys[id] = [oper, num_or_a, b]
  else
    monkeys[id] = num_or_a.to_i
  end
end

original_monkeys = monkeys.dup

def solve(monkeys, id)
  return monkeys[id] if monkeys[id].is_a?(Integer)

  oper, a, b = monkeys[id]

  ret = if oper == '+'
          solve(monkeys, a) + solve(monkeys, b)
        elsif oper == '-'
          solve(monkeys, a) - solve(monkeys, b)
        elsif oper == '*'
          solve(monkeys, a) * solve(monkeys, b)
        else
          solve(monkeys, a) / solve(monkeys, b)
        end

  monkeys[id] = ret
end

puts solve(monkeys, 'root')

# problem 2

# Find the equation we need to solve, by finding which side can already be reduced to an integer
root_key_1 = original_monkeys['root'][1]
root_key_2 = original_monkeys['root'][2]

v1 = monkeys[root_key_1]
v2 = monkeys[root_key_2]

monkeys = original_monkeys.dup
monkeys['humn'] = 0
solve(monkeys, 'root')

v1_2 = monkeys[root_key_1]
v2_2 = monkeys[root_key_2]

if v1 != v1_2
  diff_key = root_key_1
  same_val = v2_2
else
  diff_key = root_key_2
  same_val = v1_2
end

monkeys = original_monkeys.dup

def reduce(monkeys, id)
  return 'humn' if id == 'humn'
  return monkeys[id] if monkeys[id].is_a?(Integer)

  oper = monkeys[id][0]
  a = reduce(monkeys, monkeys[id][1])
  b = reduce(monkeys, monkeys[id][2])

  if a.is_a?(Integer) && b.is_a?(Integer)
    if oper == '+'
      a + b
    elsif oper == '-'
      a - b
    elsif oper == '*'
      a * b
    else
      a / b
    end
  else
    [oper, a, b]
  end
end

def solve_equality(left, right)
  oper, a, b = right
  if oper == 'humn'
    return [left, right]
  end

  if oper == '+'
    if a.is_a?(Integer)
      solve_equality(left - a, b)
    elsif b.is_a?(Integer)
      solve_equality(left - b, a)
    else
      throw 'unsolvable'
    end
  elsif oper == '-'
    if a.is_a?(Integer)
      solve_equality(a - left, b)
    elsif b.is_a?(Integer)
      solve_equality(left + b, a)
    else
      throw 'unsolvable'
    end
  elsif oper == '*'
    if a.is_a?(Integer)
      solve_equality(left / a, b)
    elsif b.is_a?(Integer)
      solve_equality(left / b, a)
    else
      throw 'unsolvable'
    end
  elsif oper == '/'
    if b.is_a?(Integer)
      solve_equality(left * b, a)
    else
      throw 'unsolvable'
    end
  end
end

to_solve = reduce(monkeys, diff_key)
puts solve_equality(same_val, to_solve).first
