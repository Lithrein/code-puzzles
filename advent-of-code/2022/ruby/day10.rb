input = File.open('../inputs/day10').readlines.map { |x| res = x.scan(/-?\d+/); if res == [] then [0,""] else [1,res[0].to_i] end }

acc = 1
cycle = 1
i = 0
res = 0
crt = []
40.times do |i| crt[i] = [] end
while i < input.size
  c = cycle - 1
  if [acc-1,acc,acc+1].include?(c % 40)
    crt[c / 40][c % 40] = '#'
  else
    crt[c / 40][c % 40] = ' '
  end
  if input[i][0] == 0
    if input[i][1] != ""
      acc += input[i][1]
    end
    i += 1
  else
    input[i][0] -= 1
  end
  cycle += 1
  if [20,60,100,140,180,220].include?(cycle)
    res += cycle * acc
  end
end
p res
puts crt.map { |x| x.join }.join "\n"
