input = File.read('05.input').split("\n").map(&:strip)

# problem 1

header = true
stacks = {}

input.each do |line|
  if line.size == 0
    header = false
    next
  end

  if header
    stacks[stacks.count + 1] = line.chars
    next
  end

  _, move_count, _, from, _, to = line.split(' ')

  move_count = move_count.to_i
  from = from.to_i
  to = to.to_i

  moved = stacks[from].last(move_count)
  stacks[to] = stacks[to] + moved.reverse
  stacks[from] = stacks[from].first(stacks[from].count - move_count)
end

puts (1..stacks.count).to_a.map { |n| stacks[n].last }.join

# problem 1

header = true
stacks = {}

input.each do |line|
  if line.size == 0
    header = false
    next
  end

  if header
    stacks[stacks.count + 1] = line.chars
    next
  end

  _, move_count, _, from, _, to = line.split(' ')

  move_count = move_count.to_i
  from = from.to_i
  to = to.to_i

  moved = stacks[from].last(move_count)
  stacks[to] = stacks[to] + moved
  stacks[from] = stacks[from].first(stacks[from].count - move_count)
end

puts (1..stacks.count).to_a.map { |n| stacks[n].last }.join
