input = File.readlines('../inputs/day01', chomp: true)

list1 = []
list2 = []
freqs = Hash.new 0
input.each do |line|
  (a, b) = line.split("   ");
  list1 << a.to_i
  list2 << b.to_i
  freqs[b.to_i] += 1
end

list1.sort!
list2.sort!

sum1 = 0
sum2 = 0
for i in 0..(list1.size - 1) do
  sum1 += (list1[i] - list2[i]).abs
  sum2 += list1[i] * freqs[list1[i]]
end
p sum1
p sum2
