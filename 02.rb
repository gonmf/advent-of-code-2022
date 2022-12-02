input = File.read('02.input').split("\n").map(&:strip)

# problem 1

total_score = 0

map = {
  'C X' => 7,
  'A Y' => 8,
  'B Z' => 9,
  'A X' => 4,
  'B Y' => 5,
  'C Z' => 6,
  'B X' => 1,
  'C Y' => 2,
  'A Z' => 3,
}

puts input.map { |l| map[l] }.sum

# problem 2

total_score = 0

map = {
  'A X' => 3,
  'A Y' => 4,
  'A Z' => 8,
  'B X' => 1,
  'B Y' => 5,
  'B Z' => 9,
  'C X' => 2,
  'C Y' => 6,
  'C Z' => 7,
}

puts input.map { |l| map[l] }.sum

