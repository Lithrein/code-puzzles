input = File.open('../inputs/day15').readlines.map { |l| l.scan(/-?\d+/).map(&:to_i) }

beacons = {}
input.each do |sx,sy,bx,by|
  beacons[[bx,by]] = 1
end

def dist(x0,y0,x1,y1)
  (x0 - x1).abs + (y0 - y1).abs
end

#p2
# 3299359,3355220
def enum_points(cx, cy, d)
  vals = Hash.new 0
  vals[[cx - d, cy]] = 1
  nxt = [cx - d, cy]
  while true do
    nxt = [nxt[0] + 1, nxt[1] + 1]   
    vals[[nxt[0], nxt[1]]] = 1
    break if nxt[0] == cx
  end
  while true do
    nxt = [nxt[0] + 1, nxt[1] - 1]   
    vals[[nxt[0], nxt[1]]] = 1
    break if nxt[1] == cy
  end
  while true do
    nxt = [nxt[0] - 1, nxt[1] - 1]   
    vals[[nxt[0], nxt[1]]] = 1
    break if nxt[0] == cx
  end
  while true do
    nxt = [nxt[0] - 1, nxt[1] + 1]   
    vals[[nxt[0], nxt[1]]] = 1
    break if nxt[1] == cy
  end
  vals
end

final_vals = []
i = 0
input.each do |sx,sy,bx,by|
  puts "#{i} #{final_vals.size}"
  i += 1
  d = dist(sx, sy, bx, by)
  vals = enum_points(sx, sy, d + 1)
  if final_vals.empty? then
    final_vals = vals.keys
  else
    final_vals = (vals.keys + final_vals)
  end
end

final_vals = final_vals.uniq.select { |x,y| x >= 0 && x <= 4000000 && y >= 0 && y <= 4000000 }
# final_vals = final_vals.uniq.select { |x,y| x >= 0 && x <= 20 && y >= 0 && y <= 20 }

i = 0
final_vals.each do |vx, vy|
  p "#{i}/#{final_vals.size} #{100 * i / final_vals.size}%"
  i += 1
  res = true
  input.each do |sx, sy, bx, by|
    res = res && (dist(sx,sy,vx,vy) > dist(sx,sy,bx,by))
  end
  if res then
    puts ">>> #{vx},#{vy}"
    break
  end
end

exit
#p1
y = 2000000
vals = Hash.new '.'
i = 0
input.each do |sx,sy,bx,by|
  p i
  i += 1
  min, max = [sx - ((sx - bx).abs + (sy - by).abs - (sy - y).abs), sx + (sx - bx).abs + (sy - by).abs - (sy - y).abs].minmax
  (min..max).each do |x|
    vals[x] = '#' unless beacons[[x,y]] == 1
    vals[x] = 'B' if beacons[[x,y]] == 1
  end
end
minx = vals.keys.min
maxx = vals.keys.max
n = 0
(minx..maxx).each do |i|
  n += 1 if vals[i] != '.'
end
p n
