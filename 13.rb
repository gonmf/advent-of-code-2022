input = File.read('13.input').split("\n").map(&:strip)

# problem 1

def tokenize(str)
  arr = []

  s = ''

  str.chars.each do |c|
    if c == '[' || c == ']'
      arr.push(s.to_i) if s.size > 0
      s = ''
      arr.push(c)
    elsif c == ','
      arr.push(s.to_i) if s.size > 0
      s = ''
    else
      s += c
    end
  end

  arr.push(s.to_i) if s.size > 0

  arr
end

def parse(tokens, i = 0)
  arr = []

  while i < tokens.count
    tok = tokens[i]
    if tok == '['
      subarr, cont_i = parse(tokens[(i + 1)..-1])
      arr.push(subarr)
      i += cont_i + 1
      next
    end
    if tok == ']'
      return [arr, i + 1]
    end

    arr.push(tok)

    i += 1
  end

  [arr, i]
end

def compare(left, right, sp = '')
  if left.is_a?(Integer) && right.is_a?(Integer)
    return 't' if left < right
    return 'f' if left > right
    return
  end
  if left.is_a?(Integer) != right.is_a?(Integer)
    if left.is_a?(Integer)
      return compare([left], right, sp + '  ')
    else
      return compare(left, [right], sp + '  ')
    end
  end

  if left.count == 0 && right.count == 0
    return
  end
  if left.count == 0 || right.count == 0
    return 't' if left.count == 0
    return 'f' if right.count == 0
  end

  compare(left.first, right.first, sp + '  ') || compare(left[1..-1], right[1..-1], sp + '  ')
end

sum = 0

input.each_slice(3).with_index do |lines, idx|
  signal1, signal2, _ = lines

  parsed1, _ = parse(tokenize(signal1)[1...-1])
  parsed2, _ = parse(tokenize(signal2)[1...-1])

  right_order = compare(parsed1, parsed2)

  sum += idx + 1 if right_order == 't'
end

puts sum

# problem 2

extra = ['[[2]]', '[[6]]']

lines = extra + input.filter { |l| l.size > 0 }

parsed = lines.map { |l| parse(tokenize(l)[1...-1]).first }

mux = 1

parsed.sort { |a, b| compare(a, b) == 't' ? -1 : 1 }.each.with_index do |l, idx|
  mux *= idx + 1 if parsed.first(2).include?(l)
end

puts mux
