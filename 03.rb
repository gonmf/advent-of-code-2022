input = File.read('03.input').split("\n").map(&:strip)

# problem 1

total = 0

input.each do |line|
  p1 = line[0...(line.size / 2)]
  p2 = line[(line.size / 2)...line.size]

  common = p1.chars & p2.chars

  total += common.map { |c| (c < 'a') ? (c.ord - 'A'.ord + 27) : (c.ord - 'a'.ord + 1) }.sum
end

puts total

# problem 2

total = 0

input.each_slice(3) do |group|
  l1, l2, l3 = group

  c = (l1.chars & l2.chars & l3.chars)[0]

  total += c < 'a' ? (c.ord - 'A'.ord + 27) : (c.ord - 'a'.ord + 1)
end

puts total
