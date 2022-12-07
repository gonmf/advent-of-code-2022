input = File.read('07.input').split("\n").map(&:strip)

# problem 1

dir_list = {
  parent: nil,
  type: 'dir',
  name: '/',
  size: 0,
  children: []
}
root_dir = dir_list
current_dir = dir_list

i = 0
while i < input.count
  line = input[i]
  i += 1

  if line.start_with?('$ cd ')
    new_dir = line['$ cd '.size..line.size]

    if new_dir == '/'
      current_dir = root_dir
    elsif new_dir == '..'
      current_dir = current_dir[:parent]
      raise if !current_dir
    else
      current_dir = current_dir[:children].find { |c| c[:type] == 'dir' && c[:name] == new_dir }
      raise if !current_dir
    end
  elsif line == '$ ls'
    j = i
    peeked_lines = []
    while j < input.count
      nline = input[j]
      j += 1

      break if nline.start_with?('$ ')

      peeked_lines.push(nline)
    end
    i = j < input.count ? j - 1 : j

    peeked_lines.each do |peeked_line|
      pl_type_size, pl_name = peeked_line.split(' ')

      existing = current_dir[:children].find { |c| c[:name] == pl_name }
      next if existing

      if pl_type_size == 'dir'
        current_dir[:children].push({
          parent: current_dir,
          type: 'dir',
          name: pl_name,
          size: 0,
          children: []
        })
      else
        current_dir[:children].push({
          parent: current_dir,
          type: 'fil',
          name: pl_name,
          size: pl_type_size.to_i,
          children: []
        })
      end
    end
  end
end

def update_dir_sizes(dir)
  dir[:size] = dir[:children].filter { |c| c[:type] == 'dir' }.map { |c| update_dir_sizes(c) }.sum +
               dir[:children].filter { |c| c[:type] == 'fil' }.map { |c| c[:size] }.sum
end

update_dir_sizes(root_dir)

def sum_under_x(dir, x)
  total = dir[:size] < x ? dir[:size] : 0

  total += dir[:children].filter { |c| c[:type] == 'dir' }.map { |c| sum_under_x(c, x) }.sum

  total
end

puts sum_under_x(root_dir, 100000)

# problem 2

space_available = 70000000 - root_dir[:size]
space_needed = 30000000 - space_available

def min_size_equal_or_over_x(dir, x)
  sub_sizes = dir[:children].filter { |c| c[:type] == 'dir' }.map { |d| min_size_equal_or_over_x(d, x) }.compact

  if dir[:size] >= x
    sub_sizes.push(dir[:size])
  end

  sub_sizes.min
end

puts min_size_equal_or_over_x(root_dir, space_needed)

