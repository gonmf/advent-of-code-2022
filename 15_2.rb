# Another solution for day 15 problem 2, based on the intersection of the border of squares

input = File.read('15.input').split("\n").map(&:strip)

def manhattan_distance(x, y, bx, by)
  (x - bx).abs + (y - by).abs
end

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

def mark_border(x, y, dst, crossings)
  pts = []

  (0...(dst + 1)).each do |inc|
    x1 = x - (dst + 1) + inc
    y1 = y + inc
    pts.push([x1, y1])

    x1 = x - (dst + 1) + inc
    y1 = y - inc
    pts.push([x1, y1])

    x1 = x + (dst + 1) - inc
    y1 = y + inc
    pts.push([x1, y1])

    x1 = x + (dst + 1) - inc
    y1 = y - inc
    pts.push([x1, y1])
  end

  pts.uniq.each do |pt|
    x, y = pt

    next if x < 0 || y < 0 || x > 4_000_000 || y > 4_000_000

    crossings[pt] = (crossings[pt] || 0) + 1
  end
end

crossings = {}

sensors.each do |sensor|
  x, y, dst = sensor

  mark_border(x, y, dst, crossings)
end

puts "\nPossibilities:"

crossings.each do |pt, xings|
  puts pt[0] * 4_000_000 + pt[1] if xings >= 4
end
