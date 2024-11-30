lines = File.open('../inputs/4.txt').readlines

sum = 0
lines.each do |l|
  game, numbers = l.split(': ')
  set1, set2 = numbers.split(' | ')
  set1 = set1.split(' ').map(&:to_i)
  set2 = set2.split(' ').map(&:to_i)
  set = []
  set2.each do |el|
    set << el if set1.include? el
  end
  sum += 2 ** (set.size - 1) if set.size > 0
end
p sum
