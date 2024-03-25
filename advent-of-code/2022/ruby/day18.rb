# p1
map = {}
input = File.open('../inputs/day18').readlines.each do |l|
  x,y,z = l.scan(/-?\d+/).map(&:to_i)
  map[[x,y,z]] = 1
end

dirs = [ [0,0,1], [0,0,-1], [0,1,0], [0,-1,0], [1,0,0], [-1,0,0] ]

surface = 0
map.keys.each do |x,y,z|
  surface += 6 - dirs.map { |v,u,w| map[[x + v, y + u, w + z]] == 1 }.count { |x| x == true }
end
p surface

# p2
# Thing is bounded by 22 on all sides, floodfill the exterior.
new_map = Hash.new 0
m = 22
to_visit = [[m,m,m]]
i = 0
while !to_visit.empty? do
  cur_x, cur_y, cur_z = to_visit[0]
  to_visit = to_visit[1..-1] || []
  if new_map[[cur_x, cur_y, cur_z]] == 1 then
    next
  end

  new_map[[cur_x, cur_y, cur_z]] = 1
  dirs.each do |u,v,w| 
    new_x = cur_x + u
    new_y = cur_y + v
    new_z = cur_z + w
    to_visit << [new_x, new_y, new_z] unless new_map[[new_x, new_y, new_z]] == 1 || map[[new_x, new_y, new_z]] == 1 || new_x > m || new_y > m || new_z > m || new_x < 0 || new_y < 0 || new_z < 0
  end
  i += 1
end

new_new_map = {}
m.times do |i|
  m.times do |j|
    m.times do |k|
      new_new_map[[i,j,k]] = 1 if new_map[[i,j,k]] == 0
    end
  end
end

m.times do |i|
  m.times do |j|
    if new_new_map[[i,j,2]] == 1 then print '#' else print '.' end
  end
  puts ""
end

surface = 0
new_new_map.keys.each do |x,y,z|
  surface += 6 - dirs.map { |v,u,w| new_new_map[[x + v, y + u, w + z]] == 1 }.count { |x| x == true }
end
p surface
