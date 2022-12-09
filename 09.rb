require 'set'

input = File.read('09.input').split("\n").map(&:strip)

def touching(a, b)
  (a[0] - b[0]).abs <= 1 && (a[1] - b[1]).abs <= 1
end

def move_head(knot, dir)
  case dir
  when 'U'
    knot[1] -= 1
  when 'D'
    knot[1] += 1
  when 'R'
    knot[0] += 1
  when 'L'
    knot[0] -= 1
  end
end

def pull_knot(moving, target)
  if moving[0] != target[0]
    moving[0] += moving[0] > target[0] ? -1 : 1
  end

  if moving[1] != target[1]
    moving[1] += moving[1] > target[1] ? -1 : 1
  end
end

def pull_knots(input, knots)
  tail_visited = Set.new(['0,0'])

  input.each do |line|
    dir, count = line.split(' ')

    (0...count.to_i).each do
      move_head(knots[0], dir)

      (1...knots.count).each do |pos|
        break if touching(knots[pos - 1], knots[pos])

        pull_knot(knots[pos], knots[pos - 1])
      end

      tail_visited.add("#{knots.last[0]},#{knots.last[1]}")
    end
  end

  tail_visited.count
end

# problem 1

knots = Array.new(2).map { [0, 0] }

puts pull_knots(input, knots)

# problem 2

knots = Array.new(10).map { [0, 0] }

puts pull_knots(input, knots)
