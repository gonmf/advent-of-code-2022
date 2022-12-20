input = File.read('20.input').split("\n").map(&:strip)

# problem 1

def mix(arr, number_order)
  number_order.each do |num|
    idx = arr.find_index(num)
    arr.rotate!(idx)
    arr.shift
    arr.rotate!(num[0] % arr.count)
    arr.unshift(num)
  end
end

def set_zero_at_head(arr)
  # pos = arr.find_index(num)
  pos = arr.find_index { |v| v[0] == 0 }

  arr.rotate!(pos)
end

arr = input.map.with_index { |l, idx| [l.to_i, idx] }
number_order = arr.dup

mix(arr, number_order)
set_zero_at_head(arr)

puts arr[1000 % arr.count][0] + arr[2000 % arr.count][0] + arr[3000 % arr.count][0]

# problem 2

arr = input.map.with_index { |l, idx| [l.to_i * 811589153, idx] }
number_order = arr.dup

(1..10).each do |idx|
  mix(arr, number_order)
end

set_zero_at_head(arr)

puts arr[1000 % arr.count][0] + arr[2000 % arr.count][0] + arr[3000 % arr.count][0]
