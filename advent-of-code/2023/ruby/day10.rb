$maze = File.open('../inputs/10.txt').readlines.map(&:chomp)
$pipes =
  {
    '|' => ['N', 'S'],
    '-' => ['E', 'W'],
    'L' => ['N', 'E'],
    'J' => ['N', 'W'],
    '7' => ['S', 'W'],
    'F' => ['S', 'E'],
    '.' => ['', '']
  }
$dirs = {
  'E' => [0,1],
  'W' => [0,-1],
  'N' => [-1, 0],
  'S' => [1,0],
  '' => [0,0]
}

$h = $maze.size
$w = $maze[0].size
pos_s = []

(0..$h-1).each do |i|
  (0..$w-1).each do |j|
    if $maze[i][j] == 'S' then
      pos_s = [i, j]
    end
  end
end


def get_pos i, j
  if 0 <= i && i < $h && 0 <= j && j < $w then
    $maze[i][j]
  else
    '.'
  end
end

def get_pos_2 i, j
  if 0 <= i && i < $h && 0 <= j && j < $w then
    $maze[i][j]
  else
    ''
  end
end

s_type = ''
$pipes.keys.each do |pipe|
  neighboors = 0
  on_north = $pipes[get_pos(pos_s[0] - 1, pos_s[1])]
  on_east  = $pipes[get_pos(pos_s[0], pos_s[1] + 1)]
  on_west  = $pipes[get_pos(pos_s[0], pos_s[1] - 1)]
  on_south = $pipes[get_pos(pos_s[0] + 1, pos_s[1])]
  $pipes[pipe].each do |n|
    if n == 'N' and on_north.include? 'S' then
      neighboors += 1
    elsif n == 'E' and on_east.include? 'W' then
      neighboors += 1
    elsif n == 'W' and on_west.include? 'E' then
      neighboors += 1
    elsif n == 'S' and on_south.include? 'N' then
      neighboors += 1
    else
    end
  end
  if neighboors == 2 then
    s_type = pipe
  end
end

visited = Hash.new false
path = [pos_s]
i = 0
cur_i = pos_s[0]
cur_j = pos_s[1]
area = 0
$maze[pos_s[0]][pos_s[1]] = s_type
stop = false
while (not stop)
  visited["#{cur_i}-#{cur_j}"] = true
  stop = true
  $pipes[get_pos(cur_i, cur_j)].each do |dir|
    next if visited["#{cur_i + $dirs[dir][0]}-#{cur_j + $dirs[dir][1]}"]
    stop = false
    cur_i += $dirs[dir][0]
    cur_j += $dirs[dir][1]
    area += cur_j * $dirs[dir][0]
    path << [cur_i, cur_j]
    i += 1
    break
  end
end
p part1 = i / 2 + 1
p area - part1 + 1


# I took the idea from this reddit post
# --------------------------------------
# Part 1: I maintained the direction of the current node and used a dictionary to
# find the change in direction.
# 
# Part 2: I did this in one line! I used Green's Theorem to calculate the area by
# simply adding: area+=x*dy However, this only counts the area enclosed by the
# path formed by the top left vertex of each cell. For example, in a 2x2, the
# cells occupy space from (0,0) to (2,2) with an area of 4, but my code would
# only count the area from (0,0) to (1,1), which is an area of 1.
# 
# If you instead consider it as the path formed by the centers of the cells, (
# (.5,.5) to (1.5,1.5) ) then we can add the area lost in each perimeter cell.
# Each perimeter cell has area=1, but when pathing between centers of cells, we
# only enclose areas of 3/4, 1/4, or 1/2. (the number of occurrences of 1/4 and
# 3/4 are nearly equal because they correspond to CW or CCW turns, so we get
# #(1/4) = #(3/4) + 4 from having net 4 CW turns to reach the origin)
# 
# The end result is that the correction factor for the total area is area +
# pathlength/2 + 1
# 
# Way easier to implement and less prone to bugs than flood fill :)
