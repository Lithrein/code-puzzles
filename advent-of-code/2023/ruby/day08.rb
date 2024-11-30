h = Hash.new {}
lines = File.open('../inputs/8.txt').readlines

dirs = lines[0].chomp
lines[2..-1].each do |line|
  _, key, l, r = line.match(/([0-9A-Z]*) = \(([0-9A-Z]*), ([0-9A-Z]*)\)/).to_a
  h[key] = [l, r]
end

# cur = 'AAA'
# i = 0
# len = dirs.size
# while cur != 'ZZZ' do
#   if dirs[i % len] == 'L' then
#     cur = h[cur][0]
#   else
#     cur = h[cur][1]
#   end
#   i += 1
# end
# p i

len = dirs.size
curs = h.keys.select { |a| a[2] == 'A' }
curs_len = curs.size
curs_end_step = []

j = 0
curs.each do |cur|
  i = 0
  len = dirs.size
  while cur[2] != 'Z' do
    if dirs[i % len] == 'L' then
      cur = h[cur][0]
    else
      cur = h[cur][1]
    end
    i += 1
  end
  p curs_end_step[j] = i
  j += 1
end
p curs_end_step

# while not curs.all? { |a| a[2] == 'Z' }
#   p curs
#   (0..curs_len - 1).each do |j|
#    if dirs[i % len] == 'L' then
#      curs[j] = h[curs[j]][0]
#    else
#      curs[j] = h[curs[j]][1]
#    end
#   end
#   i += 1
# end
# p i
