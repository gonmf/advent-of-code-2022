input = File.read('23.input').split("\n")

# problem 1

def any_around?(map, x, y)
  map.dig(y - 1, x - 1) ||
  map.dig(y - 1, x    ) ||
  map.dig(y - 1, x + 1) ||
  map.dig(y + 1, x - 1) ||
  map.dig(y + 1, x    ) ||
  map.dig(y + 1, x + 1) ||
  map.dig(y,     x - 1) ||
  map.dig(y,     x + 1)
end

def move_step(map, elfs, direction_list)
  proposals = {}
  moving = []

  elfs.each do |elf|
    x, y = elf

    if any_around?(map, x, y)
      direction_list.each do |dir|
        if dir == 'north' && map.dig(y - 1, x).nil? && map.dig(y - 1, x - 1).nil? && map.dig(y - 1, x + 1).nil?
          proposals[y - 1] ||= {}
          if proposals[y - 1][x]
            proposals[y - 1][x] = 2
          else
            proposals[y - 1][x] = 1
            moving.push([elf, [x, y - 1]])
          end
          break
        elsif dir == 'south' && map.dig(y + 1, x).nil? && map.dig(y + 1, x - 1).nil? && map.dig(y + 1, x + 1).nil?
          proposals[y + 1] ||= {}
          if proposals[y + 1][x]
            proposals[y + 1][x] = 2
          else
            proposals[y + 1][x] = 1
            moving.push([elf, [x, y + 1]])
          end
          break
        elsif dir == 'west' && map.dig(y, x - 1).nil? && map.dig(y - 1, x - 1).nil? && map.dig(y + 1, x - 1).nil?
          proposals[y] ||= {}
          if proposals[y][x - 1]
            proposals[y][x - 1] = 2
          else
            proposals[y][x - 1] = 1
            moving.push([elf, [x - 1, y]])
          end
          break
        elsif dir == 'east' && map.dig(y, x + 1).nil? && map.dig(y - 1, x + 1).nil? && map.dig(y + 1, x + 1).nil?
          proposals[y] ||= {}
          if proposals[y][x + 1]
            proposals[y][x + 1] = 2
          else
            proposals[y][x + 1] = 1
            moving.push([elf, [x + 1, y]])
          end
          break
        end
      end
    end
  end

  any_moved = false
  moving.each do |move|
    elf = move[0]
    x, y = elf
    to_x, to_y = move[1]

    if proposals.dig(to_y, to_x) == 1
      map[y][x] = nil
      map[to_y] ||= {}
      map[to_y][to_x] = '#'
      elf[0] = to_x
      elf[1] = to_y
      any_moved = true
    end
  end

  direction_list.rotate!(1)
  any_moved
end

def calc_min_max(map)
  min_x = nil
  max_x = nil
  min_y = nil
  max_y = nil

  map.each do |y, row|
    row.each do |x, c|
      if c == '#'
        min_x = [min_x, x].compact.min
        max_x = [max_x, x].compact.max
        min_y = [min_y, y].compact.min
        max_y = [max_y, y].compact.max
      end
    end
  end

  [min_x, max_x, min_y, max_y]
end

elfs = []
map = {}

input.each.with_index do |row, y|
  row.chars.each.with_index do |c, x|
    if c == '#'
      map[y] ||= {}
      map[y][x] = c
      elfs.push([x, y])
    end
  end
end

direction_list = %w[north south west east]

(0...10).each do |num|
  move_step(map, elfs, direction_list)
end

min_x, max_x, min_y, max_y = calc_min_max(map)
puts (max_y - min_y + 1) * (max_x - min_x + 1) - elfs.count

# problem 2

round = 10

while move_step(map, elfs, direction_list)
  round += 1
end

puts round + 1
