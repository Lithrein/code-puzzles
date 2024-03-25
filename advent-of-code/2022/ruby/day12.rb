input = File.open('../inputs/day12').readlines.map { |l| l.chomp.split '' }

grid_vals = Hash.new 0
imax = input.size
jmax = input[0].size
xe = 0
ye = 0
xs = 0
ys = 0
nb_cases = imax * jmax
imax.times do |i|
  jmax.times do |j|
    grid_vals[[i,j]] = Float::INFINITY
    if input[i][j] == "E" then
      xs = i
      ys = j
    elsif input[i][j] == "S" then
      xe = i
      ye = j
    end
    input[i][j] = if input[i][j] == "S" then 0 elsif input[i][j] == "E" then 25 else input[i][j].ord - 97 end
    input[i][j] = 25 - input[i][j]
  end
end

puts ""
grid_vals[[xs,ys]] = 0
dirs = [[0,1],[1,0],[0,-1],[-1,0]]

visited = { }
pred = { }
while true do
  cur = grid_vals.keys
    .select { |k| !visited[[k[0],k[1]]] && grid_vals[[k[0],k[1]]] != Float::INFINITY }
    .map { |k| [k, grid_vals[[k[0],k[1]]]] }
  m = Float::INFINITY
  cur.each do |s|
    if s[1] < m then m = s[1]; cur = s[0] end
  end
  break if cur.empty?

  visited[[cur[0],cur[1]]] = true

  tmp = dirs
    .map { |dir| [dir[0] + cur[0],  dir[1] + cur[1]] } 
    .select { |x| x[0] >= 0 && x[0] < imax && x[1] >= 0 && x[1] < jmax }
    .select { |x| input[cur[0]][cur[1]] + 1 >= input[x[0]][x[1]] }
    .each do |n|
    if grid_vals[[n[0],n[1]]] > grid_vals[[cur[0],cur[1]]] + 1 then
      grid_vals[[n[0],n[1]]] = grid_vals[[cur[0],cur[1]]] + 1
      pred[[n[0],n[1]]] = [cur[0],cur[1]]
    end
  end
end

imax.times do |i|
  jmax.times do |j|
    if grid_vals[[i,j]] != Float::INFINITY then
      print (if i == xe and j == ye then "[%2d]" else "%2d " end) % grid_vals[[i,j]]
    else
      print (if i == xe and j == ye then "[∞]" else " ∞ " end) 
    end
  end
  puts ""
end

p grid_vals[[xe,ye]]
m = Float::INFINITY
imax.times do |i|
  jmax.times do |j|
    if input[i][j] == 25 then
      if grid_vals[[i,j]] < m then m = grid_vals[[i,j]] end
    end
  end
end
p m
