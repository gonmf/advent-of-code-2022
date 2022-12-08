input = File.read('08.input').split("\n").map(&:strip)

map = input.map { |l| l.chars.map(&:to_i) }

# problem 1

def visible(map, i, j)
  return true if i == 0 || j == 0 || i == map.count - 1 || j == map[0].count - 1
  return true if map.first(i).map { |l| l[j] }.max < map[i][j]
  return true if map.last(map.count - i - 1).map { |l| l[j] }.max < map[i][j]
  return true if map[i].first(j).max < map[i][j]
  return true if map[i].last(map[0].count - j - 1).max < map[i][j]
end

count = 0
i = 0
while i < map.count
  j = 0

  while j < map[0].count
    count += 1 if visible(map, i, j)

    j += 1
  end
  i += 1
end

puts count

# problem 2

def score_row(viewer, row)
  score = 0

  row.each do |v|
    score += 1

    break if viewer <= v
  end

  score
end

def scenic_score(map, i, j)
  score_row(map[i][j], map.first(i).map { |l| l[j] }.reverse) *
    score_row(map[i][j], map.last(map.count - i - 1).map { |l| l[j] }) *
    score_row(map[i][j], map[i].first(j).reverse) *
    score_row(map[i][j], map[i].last(map[0].count - j - 1))
end

map = input.map { |l| l.chars.map(&:to_i) }

top_score = 0
i = 0
while i < map.count
  j = 0

  while j < map[0].count
    score = scenic_score(map, i, j)
    top_score = score if score > top_score

    j += 1
  end
  i += 1
end

puts top_score
