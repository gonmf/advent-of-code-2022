input = File.read('01.input').split("\n").map(&:strip)

# problem 1

most_calories = 0
current_calories = 0

input.each do |line|
  if line.size == 0
    most_calories = [current_calories, most_calories].max

    current_calories = 0
  else
    current_calories += line.to_i
  end
end

puts most_calories

# problem 2

calories = []
current_calories = 0

input.each do |line|
  if line.size == 0
    calories.push(current_calories)

    current_calories = 0
  else
    current_calories += line.to_i
  end
end

puts calories.sort.last(3).sum
