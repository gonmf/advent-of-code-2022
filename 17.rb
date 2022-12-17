
input = File.read('17.input').split("\n").map(&:strip)

# problem 1

shapes = [
  [
    ['#', '#', '#', '#']
  ],
  [
    ['.', '#', '.'],
    ['#', '#', '#'],
    ['.', '#', '.']
  ],
  [
    ['.', '.', '#'],
    ['.', '.', '#'],
    ['#', '#', '#']
  ],
  [
    ['#'],
    ['#'],
    ['#'],
    ['#']
  ],
  [
    ['#', '#'],
    ['#', '#']
  ]
]

def can_move_to(map, shape, x, y)
  shape.each.with_index do |row, s_y|
    return false if y + s_y >= 0

    row.each.with_index do |v, s_x|
      next if v != '#'

      if map.dig(y + s_y, x + s_x) == '#'
        return false
      end
    end
  end

  true
end

def persist_to(map, shape, x, y)
  shape.each.with_index do |row, s_y|
    row.each.with_index do |v, s_x|
      next if v != '#'

      map[y + s_y] ||= {}
      map[y + s_y][x + s_x] = '#'
    end
  end
end

jets = input[0].chars

goal = 2022
map = {}
i = 0
j = 0

while i < goal
  shape = shapes[i % shapes.count]

  x = 2
  y = map.any? ? (map.keys.min || 0) - 3 - shape.count : -4

  while true
    jet = jets[j % jets.count]

    if jet == '>' &&
      if x < 7 - shape[0].count
        next_x = x + 1
      else
        next_x = x
      end
    elsif jet == '<'
      if x > 0
        next_x = x - 1
      else
        next_x = x
      end
    end

    if can_move_to(map, shape, next_x, y)
      x = next_x
    else
      next_x = x
    end

    next_y = y + 1

    j += 1

    if can_move_to(map, shape, next_x, next_y)
      x = next_x
      y = next_y
    else
      persist_to(map, shape, x, y)
      break
    end
  end

  i += 1
end

puts -map.keys.min

# problem 2

map = {}
i = 0
j = 0

pattern_pieces = nil
pattern_depth = nil

while true
  shape = shapes[i % shapes.count]

  x = 2
  y = map.any? ? (map.keys.min || 0) - 3 - shape.count : -4

  while true
    jet = jets[j % jets.count]

    if jet == '>' &&
      if x < 7 - shape[0].count
        next_x = x + 1
      else
        next_x = x
      end
    elsif jet == '<'
      if x > 0
        next_x = x - 1
      else
        next_x = x
      end
    end

    if can_move_to(map, shape, next_x, y)
      x = next_x
    else
      next_x = x
    end

    next_y = y + 1

    j += 1
    if (j % jets.count) == 0
      if pattern_pieces.nil?
        pattern_pieces = i
        pattern_depth = -map.keys.min
      else
        pattern_pieces = i - pattern_pieces
        pattern_depth = -map.keys.min - pattern_depth
        i = nil
        break
      end
    end

    if can_move_to(map, shape, next_x, next_y)
      x = next_x
      y = next_y
    else
      persist_to(map, shape, x, y)
      break
    end
  end

  break if i.nil?
  i += 1
end

goal = 1000000000000
map = {}
i = 0
j = 0
depth_to_add = 0

while i < goal
  shape = shapes[i % shapes.count]

  x = 2
  y = map.any? ? (map.keys.min || 0) - 3 - shape.count : -4

  while true
    jet = jets[j % jets.count]

    if jet == '>' &&
      if x < 7 - shape[0].count
        next_x = x + 1
      else
        next_x = x
      end
    elsif jet == '<'
      if x > 0
        next_x = x - 1
      else
        next_x = x
      end
    end

    if can_move_to(map, shape, next_x, y)
      x = next_x
    else
      next_x = x
    end

    next_y = y + 1

    j += 1
    if (j % jets.count) == 0
      mul = ((goal - i) / pattern_pieces).to_i
      i += mul * pattern_pieces
      depth_to_add += mul * pattern_depth
    end

    if can_move_to(map, shape, next_x, next_y)
      x = next_x
      y = next_y
    else
      persist_to(map, shape, x, y)
      break
    end
  end

  i += 1
end

puts -map.keys.min + depth_to_add
