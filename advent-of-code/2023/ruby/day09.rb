lines = File.open('../inputs/9.txt').readlines

sum = 0
lines.each do |line|
  a = []
  i = 0
  a[i] = line.split(' ').map(&:to_i)
  while not (a[i].all? { |a| a == 0 })
    a[i+1] = a[i].each_cons(2).map { |a,b| b - a}
    i += 1
  end
  res = 0
  while i != 0
    res += a[i-1][-1]
    i -= 1
  end
  sum += res
end
p sum

sum = 0
lines.each do |line|
  a = []
  i = 0
  a[i] = line.split(' ').map(&:to_i)
  while not (a[i].all? { |a| a == 0 })
    a[i+1] = a[i].each_cons(2).map { |a,b| b - a}
    i += 1
  end
  res = 0
  while i != 0
    res = a[i-1][0] - res
    i -= 1
  end
  sum += res
end
p sum
