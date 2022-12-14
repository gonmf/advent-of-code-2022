input = File.read('14.input').split("\n").map(&:strip)

# problem 1

def draw_line(a, b, map, max_y)
  ax, ay = a.split(',')
  bx, by = b.split(',')
  ax = ax.to_i
  ay = ay.to_i
  bx = bx.to_i
  by = by.to_i

  ([ax, bx].min..[ax, bx].max).each do |x|
    ([ay, by].min..[ay, by].max).each do |y|
      map[x] ||= {}
      map[x][y] = '#'

      max_y = y if max_y.nil? || y > max_y
    end
  end

  max_y
end

def add_sand(x, y, map, max_y)
  while true
    return false if y > max_y

    if map.dig(x, y + 1).nil?
      y += 1
    elsif map.dig(x - 1, y + 1).nil?
      x -= 1
      y += 1
    elsif map.dig(x + 1, y + 1).nil?
      x += 1
      y += 1
    else
      map[x] ||= {}
      map[x][y] = 'o'
      return true
    end
  end
end

map = {}
map2 = {}
max_y = nil

input.each do |line|
  pts = line.split(' -> ')

  (1...pts.count).each do |i|
    max_y = draw_line(pts[i - 1], pts[i], map, max_y)
    draw_line(pts[i - 1], pts[i], map2, max_y)
  end
end

original_map = map2#.dup

count = 0

while add_sand(500, 0, map, max_y) do
  count += 1
end

puts count

# problem 2

def add_sand(x, y, map, floor)
  return false if map.dig(x, y)

  while true
    if map.dig(x, y + 1).nil? && y + 1 < floor
      y += 1
    elsif map.dig(x - 1, y + 1).nil? && y + 1 < floor
      x -= 1
      y += 1
    elsif map.dig(x + 1, y + 1).nil? && y + 1 < floor
      x += 1
      y += 1
    else
      map[x] ||= {}
      map[x][y] = 'o'
      return true
    end
  end
end

count = 0

while add_sand(500, 0, original_map, max_y + 2) do
  count += 1
end

puts count
