input = File.read('19.input').split("\n").map(&:strip)

# problem 1

def obj_key(h)
  %i[ore clay obsidian geode].map { |t| h[t].to_i.to_s(16) }.join('-')
end

def calc_max_geodes(blueprint, minute, items, factories, memo, best)
  memo_key = "#{minute.to_s(16)},#{obj_key(items)},#{obj_key(factories)}"
  return memo[memo_key] if memo[memo_key]

  factories_to_build = []

  blueprint[:factories].each do |type, requirements|
    next if factories[type].to_i > blueprint[:maximums][type]

    all_requirements_met = true

    requirements.each do |required_type, required_amount|
      if items[required_type].to_i < required_amount
        all_requirements_met = false
        break
      end
    end

    if all_requirements_met
      factories_to_build.push(type)
      break if type == :geode || factories_to_build.count == 2
    end
  end

  factories.each do |type, amount|
    items[type] = items[type].to_i + amount
  end

  if minute == 24
    best[0] = [best[0], items[:geode].to_i].max
    return (memo[memo_key] = items[:geode].to_i)
  end

  max_geodes = -1

  factories_to_build.each do |type|
    next_items = {}
    items.each { |k, v| next_items[k] = v }
    next_factories = {}
    factories.each { |k, v| next_factories[k] = v }

    next_factories[type] = next_factories[type].to_i + 1
    blueprint[:factories][type].each do |required_type, required_amount|
      next_items[required_type] = next_items[required_type] - required_amount
    end

    new_geodes = calc_max_geodes(blueprint, minute + 1, next_items, next_factories, memo, best)

    if new_geodes > max_geodes
      max_geodes = new_geodes
    end
  end

  if !factories_to_build.include?(:geode)
    new_geodes = calc_max_geodes(blueprint, minute + 1, items, factories, memo, best)

    if new_geodes > max_geodes
      max_geodes = new_geodes
    end
  end

  memo[memo_key] = max_geodes
end

blueprints = []

input.each do |line|
  _, id, _, _, _, _, ore_robot_ore_cost, _, _, _, _, _, clay_ore_cost, _, _, _, _, _, obsidian_ore_cost, _, _, obsidian_clay_cost, _, _, _, _, _, geode_ore_cost, _, _, geode_obsidian_cost, = line.sub(':', '').split(' ')

  blueprints.push({
    id: id.to_i,
    maximums: {
      geode: 99999,
      obsidian: geode_obsidian_cost.to_i,
      clay: obsidian_clay_cost.to_i,
      ore: [geode_ore_cost.to_i, obsidian_ore_cost.to_i, clay_ore_cost.to_i].max
    },
    factories: {
      geode: {
        obsidian: geode_obsidian_cost.to_i,
        ore: geode_ore_cost.to_i
      },
      obsidian: {
        clay: obsidian_clay_cost.to_i,
        ore: obsidian_ore_cost.to_i
      },
      clay: {
        ore: clay_ore_cost.to_i
      },
      ore: {
        ore: ore_robot_ore_cost.to_i
      }
    }
  })
end

puts (blueprints.map do |blueprint|
  geodes = calc_max_geodes(blueprint, 1, {}, { ore: 1 }, {}, [0])

  blueprint[:id] * geodes
end).sum

# problem 2

def calc_max_geodes(blueprint, minute, items, factories, memo, best)
  memo_key = "#{minute.to_s(16)},#{obj_key(items)},#{obj_key(factories)}"
  return memo[memo_key] if memo[memo_key]

  factories_to_build = []

  blueprint[:factories].each do |type, requirements|
    next if factories[type].to_i > blueprint[:maximums][type]

    all_requirements_met = true

    requirements.each do |required_type, required_amount|
      if items[required_type].to_i < required_amount
        all_requirements_met = false
        break
      end
    end

    if all_requirements_met
      factories_to_build.push(type)
      break if type == :geode || factories_to_build.count == 2
    end
  end

  factories.each do |type, amount|
    items[type] = items[type].to_i + amount
  end

  if minute == 32
    best[0] = [best[0], items[:geode].to_i].max
    return (memo[memo_key] = items[:geode].to_i)
  end

  max_geodes = -1

  factories_to_build.each do |type|
    next_items = {}
    items.each { |k, v| next_items[k] = v }
    next_factories = {}
    factories.each { |k, v| next_factories[k] = v }

    next_factories[type] = next_factories[type].to_i + 1
    blueprint[:factories][type].each do |required_type, required_amount|
      next_items[required_type] = next_items[required_type] - required_amount
    end

    new_geodes = calc_max_geodes(blueprint, minute + 1, next_items, next_factories, memo, best)

    if new_geodes > max_geodes
      max_geodes = new_geodes
    end
  end

  if max_geodes == -1
    max_geodes = calc_max_geodes(blueprint, minute + 1, items, factories, memo, best)
  end

  memo[memo_key] = max_geodes
end

mul = 1

blueprints.first(3).each do |blueprint|
  geodes = calc_max_geodes(blueprint, 1, {}, { ore: 1 }, {}, [0])

  mul *= geodes
end

puts mul
