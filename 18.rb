input = File.read('18.input').split("\n").map(&:strip)

# problem 1

def exposed_surface(map, x, y, z)
  map.dig(z, y, x) ? 0 : 1
end

def count_exposed_surfaces(cube, map)
  x, y, z = cube

  [
    [x, y, z + 1],
    [x, y, z - 1],
    [x, y + 1, z],
    [x, y - 1, z],
    [x + 1, y, z],
    [x - 1, y, z]
  ].map do |x, y, z|
    exposed_surface(map, x, y, z)
  end.sum
end

map = {}
cubes = []
min_x = max_x = min_y = max_y = min_z = max_z = nil

input.each do |line|
  x, y, z = line.split(',')
  x = x.to_i
  y = y.to_i
  z = z.to_i

  min_x = min_x.nil? ? x : [x, min_x].min
  max_x = max_x.nil? ? x : [x, max_x].max
  min_y = min_y.nil? ? y : [y, min_y].min
  max_y = max_y.nil? ? y : [y, max_y].max
  min_z = min_z.nil? ? z : [z, min_z].min
  max_z = max_z.nil? ? z : [z, max_z].max

  map[z] ||= {}
  map[z][y] ||= {}
  map[z][y][x] = -1
  cubes.push([x, y, z])
end

puts (cubes.map do |cube|
  count_exposed_surfaces(cube, map)
end.sum)

# problem 2

min_x -= 1
max_x += 1
min_y -= 1
max_y += 1
min_z -= 1
max_z += 1

def is_exterior(map, id, start, min_x, max_x, min_y, max_y, min_z, max_z)
  stack = [start]
  ret = false

  while stack.any?
    x, y, z = stack[0]
    stack = stack[1..-1]

    if x < min_x || x > max_x || y < min_y || y > max_y || z < min_z || z > max_z
      ret = true
      next
    end

    next if !map.dig(z, y, x).nil?

    map[z] ||= {}
    map[z][y] ||= {}
    map[z][y][x] = id

    [
      [x, y, z + 1],
      [x, y, z - 1],
      [x, y + 1, z],
      [x, y - 1, z],
      [x + 1, y, z],
      [x - 1, y, z]
    ].each { |v| stack.push(v) }
  end

  ret
end

def fill_in_with_exterior_or_interior(map, exposed_map, min_x, max_x, min_y, max_y, min_z, max_z)
  id = 0

  (min_z..max_z).each do |z|
    (min_y..max_y).each do |y|
      (min_x..max_x).each do |x|
        if map.dig(z, y, x).nil?
          exposed_map[id] = is_exterior(map, id, [x, y, z], min_x, max_x, min_y, max_y, min_z, max_z)
          id += 1
        end
      end
    end
  end
end

def exposed_surface2(map, exposed_map, x, y, z)
  c = map.dig(z, y, x)
  c != -1 && exposed_map[c]
end

def count_exposed_surfaces2(cube, map, exposed_map)
  x, y, z = cube

  [
    [x, y, z + 1],
    [x, y, z - 1],
    [x, y + 1, z],
    [x, y - 1, z],
    [x + 1, y, z],
    [x - 1, y, z],
  ].filter { |x, y, z| exposed_surface2(map, exposed_map, x, y, z) }.count
end

exposed_map = {}

fill_in_with_exterior_or_interior(map, exposed_map, min_x, max_x, min_y, max_y, min_z, max_z)

puts (cubes.map do |cube|
  count_exposed_surfaces2(cube, map, exposed_map)
end.sum)
