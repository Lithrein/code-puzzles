blueprints = []
File.open('../inputs/day19ex').readlines.each do |line|
  nums = line.scan(/\d+/).map(&:to_i)
  blueprints << { :ore => [nums[1], 0, 0, 0], :clay => [nums[2], 0, 0, 0], :obsidian => [nums[3], nums[4], 0, 0], :geode => [nums[5], 0, nums[6], 0] }
end
p blueprints

def apply_blueprint(bp, robots, stock)
  new_robots = Hash.new 0
  [:geode, :obsidian, :clay, :ore].each do |tag|
    while (0..3).all? { |i| stock[i] >= bp[tag][i] } do
      stock = stock.map.with_index { |x, i| x - bp[tag][i] }
      new_robots[tag] += 1
    end
    break if (1..3).any? { |i| stock[i] >= bp[tag][i] && stock[i] > 0 && bp[tag][i] > 0 }
  end
  stock = [stock[0] + robots[:ore], stock[1] + robots[:clay], stock[2] + robots[:obsidian], stock[3] + robots[:geode]]
  [[:ore, :clay, :obsidian, :geode].map { |tag| [tag, robots[tag] + new_robots[tag] ] }.to_h, stock]
end

def apply_blueprint_n(n, bp, robots, stock)
  n.times do |i|
    robots, stock = apply_blueprint(bp, robots, stock)
    puts "#{i} #{robots} #{stock}"
  end
  [robots, stock]
end

robots_0 = { :ore => 1, :clay => 0, :obsidian => 0, :geode => 0 }
# stock_0 = { :ore => 0, :clay => 0, :obsidian => 0, :geode => 0 }
stock_0 = [ 0, 0, 0, 0 ]

apply_blueprint_n(100, blueprints[1], robots_0, stock_0)
