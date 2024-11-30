$lines = File.open('../inputs/21.txt').readlines.map(&:chomp)
$h = $lines.size
$w = $lines[0].size

$dirs = [ [0,1], [0,-1], [1,0], [-1,0] ]
debug = false

matrix = []
(0..$h-1).each do |i|
  (0..$w-1).each do |j|
    matrix[i * $w + j] = []
  end
end

def get_pos i, j
  if 0 <= i && i < $h && 0 <= j && j < $w then
    return $lines[i][j]
  else
    return '#'
  end
end

# find the starting position
start_pos = nil
(0..$h-1).each do |i|
  (0..$w-1).each do |j|
    print $lines[i][j] if debug
    if $lines[i][j] == 'S' then
      start_pos = [i, j]
    end
#    $dirs.each do |dir|
#      if get_pos(i + dir[0], j + dir[1]) != '#' then
#        matrix[i * $w + j][(i + dir[0]) * $w + (j + dir[1])] = 1
#      end
#    end
  end
  puts "" if debug
end

# p1
fuel = 64
parity = {}
visited = Hash.new false
workqueue = [ [ fuel, start_pos ] ]
while !workqueue.empty? do
  print "\r workqueue size: #{workqueue.size}          visited.keys.size: #{visited.keys.size}                                           "
  f, pos = workqueue[0]
  workqueue = workqueue[1..-1]
  next if visited["#{pos[0]}-#{pos[1]}"]
  visited["#{pos[0]}-#{pos[1]}"] = true
  parity["#{pos[0]}-#{pos[1]}"] = if f % 2 == 0 then 1 else 0 end

  $dirs.each do |dir|
    new_x = pos[0] + dir[0]
    new_y = pos[1] + dir[1]
    if get_pos(new_x, new_y) != '#' && f > 0 && visited["#{new_x}-#{new_y}"] == false then
      workqueue << [ f - 1, [ new_x, new_y ] ]
    end
  end
end

p visited.keys.map { |v| parity[v] }.sum

# p2
fuel = 0
parity = {}
visited = Hash.new false
workqueue = [ [ fuel, start_pos ] ]
while !workqueue.empty? do
  print "\r workqueue size: #{workqueue.size}          visited.keys.size: #{visited.keys.size}                                           "
  f, pos = workqueue[0]
  workqueue = workqueue[1..-1]
  next if visited["#{pos[0]}-#{pos[1]}"]
  visited["#{pos[0]}-#{pos[1]}"] = true
  parity["#{pos[0]}-#{pos[1]}"] = f

  $dirs.each do |dir|
    new_x = pos[0] + dir[0]
    new_y = pos[1] + dir[1]
    if get_pos(new_x, new_y) != '#' && !visited["#{new_x}-#{new_y}"] then
      workqueue << [ f + 1, [ new_x, new_y ] ]
    end
  end
end

p even_corners = visited.keys.select { |v| parity[v] % 2 == 0 && parity[v] > 65 }.size
p odd_corners = visited.keys.select { |v| parity[v] % 2 == 1 && parity[v] > 65 }.size

p even_full = visited.keys.select { |v| parity[v] % 2 == 0 }.size
p odd_full = visited.keys.select { |v| parity[v] % 2 == 1}.size

n = 202300
p p2 = ((n+1)*(n*1)) * odd_full + (n*n) * even_full - (n+1) * odd_corners + n * even_corners


exit
if debug then
  (0..$h-1).each do |i|
    (0..$w-1).each do |j|
      if reachable["#{i}-#{j}"] then
        print 'O'
      else
        print $lines[i][j]
      end
    end
    puts ""
  end
end

p reachable.keys.size

exit
# You're so naive...
fuel = 64
reachable = Hash.new false
workqueue = [ [ fuel, start_pos ] ]
while !workqueue.empty? do
  print "\r workqueue size: #{workqueue.size}                                                      "
  f, pos = workqueue[0]
  workqueue = workqueue[1..-1]

  $dirs.each do |dir|
    new_x = pos[0] + dir[0]
    new_y = pos[1] + dir[1]
    if get_pos(new_x, new_y) != '#' && f > 0 then
      reachable["#{new_x}-#{new_y}"] = true if f - 1 == 0
      workqueue << [ f - 1, [ new_x, new_y ] ]
    end
  end
end
exit
def mat_mult m1, m2, sz
  is = js = ks = sz
  m = []
  is.times do |i|
    m[i] = [] if m[i].nil?
    js.times do |j|
      m[i][j] = 0
      ks.times do |k|
        m1[i][k] = 0 if m1[i][k].nil?
        m2[k][j] = 0 if m2[k][j].nil?
        m[i][j] += m1[i][k] * m2[k][j]
      end
    end
  end
  return m
end

m1 = matrix
puts 1
m2 = mat_mult(m1,m1,m1.size)
puts 2
m4 = mat_mult(m2,m2,m1.size)
puts 4
m8 = mat_mult(m4,m4,m1.size)
puts 8
m16 = mat_mult(m8,m8,m1.size)
puts 16
m32 = mat_mult(m16,m16,m1.size)
puts 32
m64 = mat_mult(m32,m32,m1.size)
puts 64

m1.each do |mm|
  mm.each do |mmm|
    print "#{mmm}" if mmm == 1
    print " " if mmm != 1
  end
  puts ""
end

p m64[5 * $w + 5].select { |a| a != 0 }.size
