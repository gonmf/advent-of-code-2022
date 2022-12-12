input = File.read('12.input').split("\n").map(&:strip).map { |l| l.chars }

# problem 1

start_x = start_y = end_x = end_y = -1

input.each.with_index do |row, y|
  row.each.with_index do |c, x|
    if c == 'S'
      start_x = x
      start_y = y
      input[y][x] = 'a'
    elsif c == 'E'
      end_x = x
      end_y = y
      input[y][x] = 'z'
    end
  end
end

def moveable(from_c, to_c)
  from_c <= to_c || from_c.ord - 1 == to_c.ord
end

def explore(end_y, end_x, input, visited)
  stack = [[end_y, end_x, 0]]

  while stack.count > 0
    item = stack[0]
    stack = stack[1..stack.count]

    y, x, inc = item

    if visited[y][x] > inc || visited[y][x] == -1
      visited[y][x] = inc

      if x < input[0].count - 1 && moveable(input[y][x], input[y][x + 1])
        stack.push([y, x + 1, inc + 1])
      end
      if x > 0 && moveable(input[y][x], input[y][x - 1])
        stack.push([y, x - 1, inc + 1])
      end
      if y < input.count - 1 && moveable(input[y][x], input[y + 1][x])
        stack.push([y + 1, x, inc + 1])
      end
      if y > 0 && moveable(input[y][x], input[y - 1][x])
        stack.push([y - 1, x, inc + 1])
      end
    end
  end
end

visited = Array.new(input.count).map { Array.new(input[0].count, -1) }

explore(end_y, end_x, input, visited)

min_v = visited[start_y][start_x]

puts min_v

# problem 2

input.each.with_index do |row, y|
  row.each.with_index do |c, x|
    if c == 'a' && visited[y][x] != -1 && min_v > visited[y][x]
      min_v = visited[y][x]
    end
  end
end

puts min_v
