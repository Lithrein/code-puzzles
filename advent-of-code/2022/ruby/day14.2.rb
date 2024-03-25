map = Hash.new '.'
map[[0,500]] = '+'
sand = [0,500]

input = File.open('../inputs/day14').readlines.map(&:chomp).map { |l| l.split(" -> ").map { |el| el.split(",").map(&:to_i) }.each_cons(2).to_a }

input.each do |l|
  l.each do |(a0, a1), (b0, b1)|
    ([a0, b0].min .. [a0,b0].max).each do |i|
    ([a1, b1].min .. [a1,b1].max).each do |j|
      map[[j,i]] = '#'
    end
  end
  end
end

p imin = map.keys.map { |k| k[0] }.min
p imax = map.keys.map { |k| k[0] }.max
p jmin = map.keys.map { |k| k[1] }.min
p jmax = map.keys.map { |k| k[1] }.max

cnt = 0
fuel = 40000
while true && fuel > 0 do
  fuel -= 1
  i = [0,500]
  lasti = [0,500]
  while true do
    lasti[0] = i[0]
    lasti[1] = i[1]
    if i[0] < imax + 1 && map[[i[0] + 1,i[1]]] == '.' then
      i[0] = i[0] + 1
    else
      if i[0] < imax + 1 && map[[i[0] + 1, i[1] - 1]] == '.' then
        i[0] = i[0] + 1
        i[1] = i[1] - 1
      elsif i[0] < imax + 1 && map[[i[0] + 1, i[1] + 1]] == '.' then
        i[0] = i[0] + 1
        i[1] = i[1] + 1
      else
        # bad end
      end
    end
    break if (i[0] == lasti[0] && i[1] == lasti[1]) || i[0] == imax + 1
  end
  cnt += 1
  break if i[0] == 0 && i[1] == 500
  map[[i[0],i[1]]] = 'o'
end

p imin = map.keys.map { |k| k[0] }.min
p imax = map.keys.map { |k| k[0] }.max
p jmin = map.keys.map { |k| k[1] }.min
p jmax = map.keys.map { |k| k[1] }.max

(imin..imax + 2).each do |i|
  (jmin..jmax).each do |j|
    print map[[i,j]]
  end
  puts ""
end
p cnt
