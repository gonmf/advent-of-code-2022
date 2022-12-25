input = File.read('25.input').split("\n")

# problem 1

def snafu_to_decimal(str)
  sum = 0

  mul = 1
  str.chars.reverse.each do |c|

    if c == '2'
      sum += mul * 2
    elsif c == '1'
      sum += mul
    elsif c == '0'

    elsif c == '-'
      sum -= mul
    elsif c == '='
      sum -= mul * 2
    end
    mul *= 5
  end

  sum
end

POWERS_OF_FIVE = (1..20).map { |n| 5 ** n }.reverse + [1]

def decimal_to_snafu(num)
  str = ''

  POWERS_OF_FIVE.each.with_index do |p, idx|
    pick = ([
      ['2', num - p * 2],
      ['1', num - p],
      ['0', num],
      ['-', num + p],
      ['=', num + p * 2]
    ].filter { |v| v[1].abs <= num.abs }.sort_by { |v| v[1].abs }.first)
    if !pick.nil?
      str += pick[0] if str != '' || pick[0] != '0'
      num = pick[1]
    end
  end

  str
end

total = 0
input.each do |line|
  total += snafu_to_decimal(line)
end

puts decimal_to_snafu(total)
