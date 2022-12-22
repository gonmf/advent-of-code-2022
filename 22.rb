input = File.read('22.input').split("\n")

# problem 1

reading_map = true
map = {}
map2 = {}
start_x = nil
max_y = 0
max_x = 0
path = []

input.each.with_index do |line, y|
  break if line.strip.size == 0

  line.chars.each.with_index do |c, x|
    map[y] ||= {}
    map[y][x] = c
    map2[y] ||= {}
    map2[y][x] = c
    start_x ||= x if c == '.'
    max_x = [max_x, x + 1].max
  end

  max_y = y + 1
end

s = ''
input.last.chars.each do |c|
  if %w[L R].include?(c)
    path.push(s.to_i) if s
    s = ''
    path.push(c)
  else
    s += c
  end
end

path.push(s.to_i) if s

def rotate_dir(dir, r)
  if dir == '>'
    if r == 'L'
      '^'
    else
      'v'
    end
  elsif dir == 'v'
    if r == 'L'
      '>'
    else
      '<'
    end
  elsif dir == '<'
    if r == 'L'
      'v'
    else
      '^'
    end
  else
    if r == 'L'
      '<'
    else
      '>'
    end
  end
end

def next_coord(map, max_x, max_y, x, y, dir)
  if dir == '^'
    y -= 1
    y = max_y - 1 if y < 0
  elsif dir == 'v'
    y += 1
    y = 0 if y >= max_y
  elsif dir == '<'
    x -= 1
    x = max_x - 1 if x < 0
  else
    x += 1
    x = 0 if x >= max_x
  end

  c = map.dig(y, x)
  return nil if c == '#'
  return [x, y] if c == '.'
  next_coord(map, max_x, max_y, x, y, dir)
end

def move(map, max_x, max_y, path, x, y, dir)
  path.each do |instruction|
    if %w[L R].include?(instruction)
      dir = rotate_dir(dir, instruction)
    else
      while instruction > 0
        next_x, next_y = next_coord(map, max_x, max_y, x, y, dir)
        if next_y
          x = next_x
          y = next_y
          instruction -= 1
        else
          break
        end
      end
    end
  end

  facing = dir == '>' ? 0 : dir == 'v' ? 1 : dir == '<' ? 2 : 3

  (y + 1) * 1000 + (x + 1) * 4 + facing
end

puts move(map, max_x, max_y, path, start_x, 0, '>')

# problem 2

def quadrant(max_x, max_y, x, y)
  face_size = max_x > max_y ? max_x / 4 : max_y / 4

  y_tri = y / face_size
  x_tri = x / face_size
  [x_tri, y_tri]
end

def rotate_coord(max_x, max_y, x, y)
  x, y = [y, -x]

  [x % max_x, y % max_y]
end

def draw_simplified_cube(map, max_x, max_y, prev_x, prev_y, prev_dir, x, y, dir)
  factor = max_x > 50 ? 10 : 1
  max_x /= factor
  max_y /= factor
  prev_x /= factor
  prev_y /= factor
  x /= factor
  y /= factor

  (0...max_y).each do |y2|
    puts ((0...max_x).map do |x2|
      if y2 == prev_y && x2 == prev_x
        prev_dir
      elsif y2 == y && x2 == x
        dir
      else
        (map.dig(y2 * factor, x2 * factor) || ' ') != ' ' ? '.' : ' '
      end
    end).join
  end

  puts '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
end

def _rotate_2d(face_size, x, y)
  c = (face_size - 1) / 2.0

  x, y = [x - c, y - c]
  x, y = [-y, x]
  x, y = [(x + c).to_i, (y + c).to_i]

  [x, y]
end

def rotate_2d(face_size, x, y)
  x_i = (x / face_size)
  y_i = (y / face_size)

  x, y = _rotate_2d(face_size, x - x_i * face_size, y - y_i * face_size)

  [x + x_i * face_size, y + y_i * face_size]
end

def next_coord2(map, face_size, max_x, max_y, x, y, dir, memo)
  x_tri, y_tri = quadrant(max_x, max_y, x, y)
  prev_dir = dir
  prev_x = x
  prev_y = y

  if dir == '^'
    y -= 1
    y = max_y - 1 if y < 0
  elsif dir == 'v'
    y += 1
    y = 0 if y >= max_y
  elsif dir == '<'
    x -= 1
    x = max_x - 1 if x < 0
  else
    x += 1
    x = 0 if x >= max_x
  end

  x_tri2, y_tri2 = quadrant(max_x, max_y, x, y)
  if (x_tri2 != x_tri || y_tri2 != y_tri)
    x_tri2, y_tri2 = quadrant(max_x, max_y, x, y)

    if memo[[[x_tri, y_tri], [x_tri2, y_tri2]]]
      memo[[[x_tri, y_tri], [x_tri2, y_tri2]]].each do |s|
        if s.include?(',')
          q_x, q_y = s.split(',')
          x = x % face_size + q_x.to_i * face_size
          y = y % face_size + q_y.to_i * face_size
        elsif s == 'rot'
          x, y = rotate_2d(face_size, x, y)
          dir = rotate_dir(dir, 'R')
        end
      end
    else
      draw_simplified_cube(map, max_x, max_y, prev_x, prev_y, prev_dir, x, y, dir)

      opts = []
      while true
        puts "New quadrant or empty for #{x_tri2},#{y_tri2}?"
        s = gets

        if s.strip.size == 0
          break
        else
          q_x, q_y = s.split(',')
          if q_y
            x = x % face_size + q_x.to_i * face_size
            y = y % face_size + q_y.to_i * face_size
            opts.push(s.strip)
            break
          end
        end
      end

      while true
        draw_simplified_cube(map, max_x, max_y, prev_x, prev_y, prev_dir, x, y, dir)

        puts "Rotate? r or empty"
        s = gets

        if s.strip == 'r'
          opts.push('rot')
          x, y = rotate_2d(face_size, x, y)
          dir = rotate_dir(dir, 'R')
        elsif s.strip.size == 0
          break
        end
      end

      memo[[[x_tri, y_tri], [x_tri2, y_tri2]]] = opts
    end
  end

  c = map.dig(y, x)
  return nil if c == '#'
  return [x, y, dir] if c == '.'
  next_coord2(map, face_size, max_x, max_y, x, y, dir, memo)
end

def move2(map, face_size, max_x, max_y, path, x, y, dir, memo)
  path.each.with_index do |instruction, idx|
    if %w[L R].include?(instruction)
      dir = rotate_dir(dir, instruction)
    else
      while instruction > 0
        next_x, next_y, new_dir = next_coord2(map, face_size, max_x, max_y, x, y, dir, memo)
        if new_dir
          x = next_x
          y = next_y
          dir = new_dir
          instruction -= 1
        else
          break
        end
      end
    end
  end

  facing = dir == '>' ? 0 : dir == 'v' ? 1 : dir == '<' ? 2 : 3

  (y + 1) * 1000 + (x + 1) * 4 + facing
end

face_size = max_x > max_y ? max_x / 4 : max_y / 4

if face_size == 50
  memo = {
    # Delete these to generate them again:
    [[1, 0], [1, 3]] => ["0,3", "rot"],
    [[0, 3], [2, 3]] => ["1,0", "rot", "rot", "rot"],
    [[1, 0], [0, 0]] => ["0,2", "rot", "rot"],
    [[0, 2], [2, 2]] => ["1,0", "rot", "rot"],
    [[1, 0], [2, 0]] => [],
    [[2, 0], [0, 0]] => ["1,2", "rot", "rot"],
    [[1, 2], [1, 1]] => [],
    [[1, 1], [2, 1]] => ["2,0", "rot", "rot", "rot"],
    [[1, 1], [1, 0]] => [],
    [[1, 0], [1, 1]] => [],
    [[1, 1], [1, 2]] => [],
    [[1, 2], [2, 2]] => ["2,0", "rot", "rot"],
    [[2, 0], [2, 3]] => ["0,3"],
    [[0, 3], [1, 3]] => ["1,2", "rot", "rot", "rot"],
    [[1, 2], [1, 3]] => ["0,3", "rot"],
    [[1, 2], [0, 2]] => [],
    [[0, 2], [0, 3]] => [],
    [[0, 3], [0, 2]] => [],
    [[0, 3], [0, 0]] => ["2,0"],
    [[2, 0], [1, 0]] => [],
    [[2, 0], [2, 1]] => ["1,1", "rot"],
    [[1, 1], [0, 1]] => ["0,2", "rot", "rot", "rot"],
    [[0, 2], [0, 1]] => ["1,1", "rot"],
    [[0, 2], [1, 2]] => []
  }
else
  memo = {}
end

puts move2(map2, face_size, max_x, max_y, path, start_x, 0, '>', memo)


