require 'set'

input = File.read('15.input').split("\n").map(&:strip)

# problem 1

def manhattan_distance(x, y, bx, by)
  (x - bx).abs + (y - by).abs
end

def mark_positions(x, y, dst, target_y, set)
  ((x - dst)...(x + dst)).each do |x1|
    if manhattan_distance(x, y, x1, target_y) <= dst
      set.add(x1)
    elsif x1 > x
      break
    end
  end
end

beacons = []

target_y = 2000000

sensors = []

input.each do |line|
  _, _, x, y, _, _, _, _, bx, by = line.split(' ')

  x = x.split('=')[1].to_i
  y = y.split('=')[1].split(':')[0].to_i
  bx = bx.split('=')[1].split(',')[0].to_i
  by = by.split('=')[1].to_i

  beacons.push([bx, by])

  dst = manhattan_distance(x, y, bx, by)

  sensors.push([x, y, dst])
end

set = Set.new

sensors.each do |sensor|
  x, y, dst = sensor

  mark_positions(x, y, dst, target_y, set)
end

beacons.each do |beacon|
  set.delete(beacon[0]) if beacon[1] == target_y
end

puts set.count

# problem 2

def join_contiguous(ranges)
  ranges.each do |range|
    contiguous_i = ranges.find_index { |r| r != range && (r[1] == range[0] - 1 || r[0] == range[1] + 1) }

    if contiguous_i
      contiguous = ranges[contiguous_i]

      range[0] = [contiguous[0], range[0]].min
      range[1] = [contiguous[1], range[1]].max

      ranges.delete_at(contiguous_i)
      return join_contiguous(ranges)
    end
  end
end

def ranges_add(ranges, a, b)
  return ranges if ranges.any? { |r| r[0] <= a && b <= r[1] }

  overlap = ranges.find { |r| (a <= r[0] && r[0] <= b) || (r[0] <= a && a <= r[1]) }
  if overlap
    overlap[0] = [overlap[0], a].min
    overlap[1] = [overlap[1], b].max
  else
    ranges.push([a, b])
  end

  ranges = join_contiguous(ranges)
end

def fill_in(ranges, x, y, scan_y, dst, max_dim)
  x_inc = dst - manhattan_distance(x, y, x, scan_y)

  if x_inc >= 0
    ranges = ranges_add(ranges, [x - x_inc, 0].max, [x + x_inc, max_dim].min)
    new_ranges = []

    ranges.each do |r|
      ranges_add(new_ranges, r[0], r[1])
    end

    new_ranges
  else
    ranges
  end
end

max_dim = 4_000_000

(0...max_dim).each do |scan_y|
  ranges = []

  sensors.each do |sensor|
    x, y, dst = sensor

    ranges = fill_in(ranges, x, y, scan_y, dst, max_dim)
  end

  if ranges.count > 1
    puts (ranges.flatten.sort[1] + 1) * 4_000_000 + scan_y
    break
  end
end
