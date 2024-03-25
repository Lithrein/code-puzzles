input = File.open('../inputs/day11').readlines.join.split("\n\n").map { |x| x.split("\n") }

monkeys = []
i = 0
input.each do |(m,s,op,test,to_t,to_f)|
  _m = m.scan(/-?\d+/)[0].to_i
  _s = s.scan(/-?\d+/).map(&:to_i)
  _op = op.split("=")[1].strip
  _test = test.scan(/-?\d+/)[0].to_i
  _to_t = to_t.scan(/-?\d+/)[0].to_i
  _to_f = to_f.scan(/-?\d+/)[0].to_i
  monkeys[_m] = {
    :items => _s,
    :op => _op,
    :test => _test,
    :to_t => _to_t,
    :to_f => _to_f,
    :inspected => 0
  }
end

nb_monkeys = monkeys.size
nb_rounds = 10000 #p1 = 20, #p2 = 10000
p max = (2 * 3 * 5 * 7 * 11 * 13 * 17 * 19 * 23 * 29)
nb_rounds.times do
  nb_monkeys.times do |m|
    items = monkeys[m][:items]

    items.each do |it|
      old = it
      it = (eval(monkeys[m][:op])) % max #p1 should / 3
      new_m = monkeys[m][if it % monkeys[m][:test] == 0 then :to_t else :to_f end]
      monkeys[new_m][:items] << it.floor.to_i
      monkeys[m][:inspected] += 1
  end

  monkeys[m][:items] = []
end
end

# nb_monkeys.times do |m|
#   p monkeys[m]
# end

p monkeys.map { |m| m[:inspected] }.max(2).inject(&:*)
