input = File.read('11.input').split("\n").map(&:strip)

# problem 1

def parse_input(input)
  monkeys = {}
  lcd = 1 # lowest common denominator

  input.each_slice(7) do |lines|
    monkey_id, items, oper, check, if_true, if_false = lines

    monkey_id = monkey_id.split(' ')[1].split(':')[0].to_i
    items = items.split('items: ')[1].split(', ').map(&:to_i)
    operation = oper.include?('+') ? '+' : '*'
    operand = oper.end_with?('old') ? nil : oper.split(' ').last.to_i
    check = check.split('divisible by ')[1].to_i
    if_true = if_true.split('throw to monkey ')[1].to_i
    if_false = if_false.split('throw to monkey ')[1].to_i
    lcd *= check

    monkeys[monkey_id] = {
      id: monkey_id,
      items: items,
      operation: operation,
      operand: operand,
      check: check,
      if_true: if_true,
      if_false: if_false,
      inspections: 0
    }
  end

  [monkeys, lcd]
end

monkeys, _ = parse_input(input)

(0...20).each do
  monkeys.values.each do |monkey|
    monkey[:items].each do |item_worry_level|
      operand = monkey[:operand] || item_worry_level

      if monkey[:operation] == '*'
        item_worry_level = item_worry_level * operand
      else
        item_worry_level = item_worry_level + operand
      end

      item_worry_level = item_worry_level / 3

      if (item_worry_level % monkey[:check]) == 0
        new_monkey = monkey[:if_true]
      else
        new_monkey = monkey[:if_false]
      end

      monkeys[new_monkey][:items].push(item_worry_level)
    end

    monkey[:inspections] += monkey[:items].count
    monkey[:items] = []
  end
end

a, b = monkeys.values.map { |m| m[:inspections] }.sort.last(2)
puts a * b

# problem 2

monkeys, lcd = parse_input(input)

(0...10_000).each do
  monkeys.values.each do |monkey|
    monkey[:items]  .each do |item_worry_level|
      operand = monkey[:operand] || item_worry_level

      if monkey[:operation] == '*'
        item_worry_level = item_worry_level * operand
      else
        item_worry_level = item_worry_level + operand
      end

      if (item_worry_level % monkey[:check]) == 0
        new_monkey = monkey[:if_true]
      else
        new_monkey = monkey[:if_false]
      end

      monkeys[new_monkey][:items].push(item_worry_level % lcd)
    end

    monkey[:inspections] += monkey[:items].count
    monkey[:items] = []
  end
end

a, b = monkeys.values.map { |m| m[:inspections] }.sort.last(2)
puts a * b
