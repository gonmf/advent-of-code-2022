input = File.read('24.input').split("\n")

# problem 1

def next_pos(map, x, y, b)
  if b == '^'
    y = y - 1
    y = map.count - 2 if y == 0
  elsif b == 'v'
    y = y + 1
    y = 1 if y == map.count - 1
  elsif b == '<'
    x = x - 1
    x = map[0].count - 2 if x == 0
  else
    x = x + 1
    x = 1 if x == map[0].count - 1
  end

  [x, y]
end

def blizzard_move(map)
  moving = []

  map.each do |y, row|
    row.each do |x, v|
      if v.is_a?(Array)
        v.each do |b|
          next_x, next_y = next_pos(map, x, y, b)
          moving.push([b, next_x, next_y])
        end
        map[y][x] = []
      end
    end
  end

  moving.each do |move|
    b, x, y = move
    map[y][x] = (map[y][x] + [b]).sort
  end

  map
end

def valid_and_empty?(map, x, y)
  x > 0 && y >= 0 && x < map[0].count - 1 && y < map.count && map.dig(y, x) == []
end

def path(map, start_pos, end_pos)
  start_x, start_y = start_pos

  visited = {}
  visited[start_y] = {}
  visited[start_y][start_x] = true
  minutes = 0

  while true
    minutes += 1
    map = blizzard_move(map)
    next_visited = {}

    visited.each do |y, row|
      row.each do |x, v|
        next unless v

        opts = [
          [x, y],
          [x + 1, y],
          [x - 1, y],
          [x, y + 1],
          [x, y - 1]
        ].filter { |v| valid_and_empty?(map, v[0], v[1]) }

        opts.each do |move|
          return [minutes, map] if move == end_pos

          next_x, next_y = move

          next_visited[next_y] ||= {}
          next_visited[next_y][next_x] = true
        end
      end
    end

    visited = next_visited
  end
end

map = {}

input.each.with_index do |row, y|
  map[y] = {}

  row.chars.each.with_index do |c, x|
    if ['<', '^', '>', 'v'].include?(c)
      map[y][x] = [c]
    elsif c == '#'
      map[y][x] = '#'
    else
      map[y][x] = []
    end
  end
end

start_x = 1
start_y = 0
end_x = map[0].count - 2
end_y = map.count - 1

minutes, map = path(map, [start_x, start_y], [end_x, end_y])
puts minutes

# problem 2

minutes2, map = path(map, [end_x, end_y], [start_x, start_y])
minutes3, = path(map, [start_x, start_y], [end_x, end_y])
puts minutes + minutes2 + minutes3
