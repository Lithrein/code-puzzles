$lines = File.open('../inputs/17ex.txt').readlines.map(&:chomp)
$h = $lines.size
$w = $lines[0].size

# todo improve dijkstra

$p = {}
$d = Hash.new 1000000
$pred = {}

s = [0, 0]
$d["#{s[0]}-#{s[1]}"] = 0

$dirs = [
  [0, 1], [1, 0], [-1, 0], [0, -1]
]

def not_aligned(arr, n)
  n.times do
    arr << $pred[arr[-1]]
  end
  if arr.any? { |a| a.nil? } then
    return true
  else
    bla = []
    arr.map { |aa| aa.split('-').map(&:to_i) }.each_cons(2) do |a,b| bla << [a[0] - b[0], a[1] - b[1]] end
    return !(bla.all? { |a| a[0] == bla[0][0] && a[1] == bla[0][1] })
  end
end

cnt = 0
while $p.keys.size != $h * $w do
  a = ($d.keys.select { |k| $p[k].nil? })[0]
  $d.keys.each do |k|
    a = k if $d[k] < $d[a] && $p[k].nil?
  end
#  puts "p: #{$p.keys}"
#  puts "l: #{$d.keys.select { |k| $p[k].nil? }}"
#  puts "d: #{$d}"
#  puts "#{a} #{$d[a]}"
  $p[a] = true
  a = a.split('-').map(&:to_i)
  $dirs.each do |dx, dy|
    b = [a[0] + dx, a[1] + dy]
    a_key = "#{a[0]}-#{a[1]}"
    b_key = "#{b[0]}-#{b[1]}"
#    puts "#{b} #{$d[b]}"
    next unless not_aligned([b_key, a_key], 10)
    next unless 0 <= b[0] && b[0] < $h && 0 <= b[1] && b[1] < $w
    next unless $p[b_key].nil?
    weight = $lines[b[0]][b[1]].to_i
#    puts "$d[#{b_key}] >= $d[#{a_key}] + weight:: #{$d[b_key]} > #{$d[a_key]} + #{weight}"
    if $d[b_key] > $d[a_key] + weight
      $d[b_key] = $d[a_key] + weight
      $pred[b_key] = a_key
    end
  end
  cnt += 1
end

p $d

path = {}
cur = "#{$w-1}-#{$w-1}"
while cur != "0-0" do
  path[cur] = true
  cur = $pred[cur]
end

sum = 0
(0..$h-1).each do |i|
  (0..$w-1).each do |j|
    if path["#{i}-#{j}"] == true then
      print '#'
      sum += $lines[i][j].to_i
    else
      print '.'
    end
  end
  puts ""
end
p sum
