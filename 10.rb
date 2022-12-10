input = File.read('10.input').split("\n").map(&:strip)

# problem 1

cycle = 1
x = 1
out = [0]

def inc_signal_strength(cycle, x, out)
  if cycle == 20 || ((cycle - 20) % 40) == 0
    out[0] = out[0] + cycle * x
  end
end

input.each do |line|
  cmd, arg = line.split(' ')

  if cmd == 'noop'
    inc_signal_strength(cycle, x, out)
    cycle += 1
  elsif cmd == 'addx'
    inc_signal_strength(cycle, x, out)
    cycle += 1
    inc_signal_strength(cycle, x, out)
    cycle += 1
    x += arg.to_i
  end
end

puts out[0]

# problem 2

cycle = 0
x = 1
crt = Array.new(240, ' ')

def crt_draw_pixel(cycle, x, crt)
  if (cycle % 40) == x - 1 || (cycle % 40) == x || (cycle % 40) == x + 1
    crt[cycle % 240] = '#'
  end
end

input.each do |line|
  cmd, arg = line.split(' ')

  if cmd == 'noop'
    crt_draw_pixel(cycle, x, crt)
    cycle += 1
  elsif cmd == 'addx'
    crt_draw_pixel(cycle, x, crt)
    cycle += 1
    crt_draw_pixel(cycle, x, crt)
    cycle += 1
    x += arg.to_i
  end
end

crt.each_slice(40) do |slice|
  puts "#{slice.join}"
end
