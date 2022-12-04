input = File.read('04.input').split("\n").map(&:strip)

# problem 1

puts (input.filter do |line|
  a, b = line.split(',')
  a1, a2 = a.split('-')
  b1, b2 = b.split('-')
  a1 = a1.to_i
  a2 = a2.to_i
  b1 = b1.to_i
  b2 = b2.to_i

  (a1 <= b1 && b2 <= a2) || (b1 <= a1 && a2 <= b2)
end).count

# problem 2

puts (input.filter do |line|
  a, b = line.split(',')
  a1, a2 = a.split('-')
  b1, b2 = b.split('-')
  a1 = a1.to_i
  a2 = a2.to_i
  b1 = b1.to_i
  b2 = b2.to_i

  (b1 <= a1 && a1 <= b2) || (a1 <= b1 && b1 <= a2)
end).count
