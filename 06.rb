input = File.read('06.input').split("\n").map(&:strip)

# problem 1

partial = []

input[0].chars.each.with_index do |c, idx|
  partial = (partial + [c]).last(4)

  if partial.size == 4 && partial.uniq.size === 4
    puts idx + 1
    break
  end
end

# problem 2

partial = []

input[0].chars.each.with_index do |c, idx|
  partial = (partial + [c]).last(14)

  if partial.size == 14 && partial.uniq.size === 14
    puts idx + 1
    break
  end
end
