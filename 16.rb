input = File.read('16.input').split("\n").map(&:strip)

# problem 1

def calc_distance(paths, a, b, seen = [])
  return 0 if a == b

  fps = paths[a].filter { |next_a| !seen.include?(next_a) }
  return paths.count if fps.none?

  (fps.map do |next_a|
    1 + calc_distance(paths, next_a, b, seen + [a])
  end).min
end

def release_pressure1(own, valve_pressures, edges, pressure_released, best)
  own_opts = []

  own_loc, own_minute = own

  edges.each do |edge|
    from, to, cost = edge

    if from == own_loc && cost + own_minute < 30
      own_opts.push([to, cost])
    end
  end

  if own_opts.none?
    if pressure_released > best[0]
      best[0] = pressure_released
    end
    return
  end

  own_opts.shuffle.each do |own_opt|
    own_loc, own_minute = own
    own_to, own_cost = own_opt
    own_minute += own_cost

    new_pressure_released = pressure_released
    new_pressure_released += (31 - own_minute) * valve_pressures[own_to]

    release_pressure1([own_to, own_minute], valve_pressures, edges.filter { |e| e[1] != own_to }, new_pressure_released, best)
  end
end

valve_pressures = {}
paths = {}

input.each do |line|
  _, name, _, _, rate, _, _, _, _, a, b, c, d, e = line.gsub(',', '').gsub(';', '').split(' ')

  rate = rate.split('=')[1].to_i

  valve_pressures[name] = rate
  paths[name] = [a, b, c, d, e].compact
end

edges = []

valve_pressures.each do |name1, _|
  valve_pressures.each do |name2, _|
    next if name1 == name2

    if name1 == 'AA'
      edges.push([name1, name2] + [0])
    elsif valve_pressures[name1] > 0 && valve_pressures[name2] > 0
      edges.push([name1, name2] + [0])
      edges.push([name2, name1] + [0])
    end
  end
end

edges = edges.uniq.sort

distances_memo = {}
edges.each do |edge|
  edge[2] = (distances_memo[[edge[0], edge[1]].sort] ||= calc_distance(paths, edge[0], edge[1]) + 1)
end

best = [0]
release_pressure1(['AA', 1], valve_pressures, edges, 0, best)
puts best[0]

# problem 2

def release_pressure2(own, pht, valve_pressures, edges, pressure_released, best)
  own_opts = []
  pht_opts = []

  own_loc, own_minute = own
  pht_loc, pht_minute = pht

  edges.each do |edge|
    from, to, cost = edge

    if from == own_loc && cost + own_minute < 26
      own_opts.push([to, cost])
    end

    if from == pht_loc && cost + pht_minute < 26
      pht_opts.push([to, cost])
    end
  end

  if own_opts.none? && pht_opts.none?
    if pressure_released > best[0]
      best[0] = pressure_released
      puts pressure_released
    end
    return
  end

  if own_opts.none? && pht_opts.any?
    pht_opts.shuffle.each do |pht_opt|
      pht_loc, pht_minute = pht
      pht_to, pht_cost = pht_opt
      pht_minute += pht_cost

      new_pressure_released = pressure_released
      new_pressure_released += (27 - pht_minute) * valve_pressures[pht_to]

      release_pressure2(own, [pht_to, pht_minute], valve_pressures, edges.filter { |e| e[1] != pht_loc && e[1] != pht_to }, new_pressure_released, best)
    end
    return
  end

  if own_opts.any? && pht_opts.none?
    own_opts.shuffle.each do |own_opt|
      own_loc, own_minute = own
      own_to, own_cost = own_opt
      own_minute += own_cost

      new_pressure_released = pressure_released
      new_pressure_released += (27 - own_minute) * valve_pressures[own_to]

      release_pressure2([own_to, own_minute], pht, valve_pressures, edges.filter { |e| e[1] != own_loc && e[1] != own_to }, new_pressure_released, best)
    end
    return
  end

  pht_opts = pht_opts.shuffle

  own_opts.shuffle.each do |own_opt|
    pht_opts.each do |pht_opt|
      own_loc, own_minute = own
      own_to, own_cost = own_opt

      pht_loc, pht_minute = pht
      pht_to, pht_cost = pht_opt

      next if own_to == pht_to

      own_minute += own_cost
      pht_minute += pht_cost

      new_pressure_released = pressure_released
      new_pressure_released += (27 - own_minute) * valve_pressures[own_to]
      new_pressure_released += (27 - pht_minute) * valve_pressures[pht_to]

      release_pressure2([own_to, own_minute], [pht_to, pht_minute], valve_pressures, edges.filter { |e| e[1] != own_loc && e[1] != pht_loc && e[1] != own_to && e[1] != pht_to }, new_pressure_released, best)
    end
  end
end

puts "\nPossibilities:"
release_pressure2(['AA', 1], ['AA', 1], valve_pressures, edges, 0, [1700])
