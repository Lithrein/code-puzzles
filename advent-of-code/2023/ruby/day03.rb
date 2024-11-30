$grid = []

$lines = File.open('../inputs/3.txt').readlines

i = 0
$lines.each do |l|
  $grid[i] = l.chomp.split('')
  i += 1
end

$h = $grid.size
$w = $grid[0].size

dirs = [[-1, 0], [-1, 1], [-1, -1], [0, 1], [0, -1], [1, -1], [1, 0], [1, 1]]

def at i,j
  if 0 <= i && i < $h && 0 <= j && j < $w then
    $grid[i][j]
  else
    '.'
  end
end

def set_at i,j,v
  if 0 <= i && i < $h && 0 <= j && j < $w then
    $grid[i][j]=v
  end
end

$sum = 0
(0..$h-1).each do |i|
  (0..$w-1).each do |j|
    if $grid[i][j].to_i != 0 || $grid[i][j] == '0' then
      adjacent = false
      dirs.each do |di, dj|
        cur = at(i + di, j + dj)
        adjacent = adjacent || (cur != '.' && (cur.to_i == 0 && cur != '0'))
      end
      if adjacent then
        k = 1
        nums = []
        while at(i, j - k).to_i != 0 || at(i, j - k) == '0' do
          nums << at(i, j - k)
          set_at(i, j - k, '.')
          k += 1
        end
        nums = nums.reverse
        nums << at(i,j)
        k = 1
        while at(i, j + k).to_i != 0 || at(i, j + k) == '0' do
          nums << at(i, j + k)
          set_at(i, j + k, '.')
          k += 1
        end
        $sum += nums.join.to_i
      end
    end
  end
end
p $sum

i = 0
$lines.each do |l|
  $grid[i] = l.chomp.split('')
  i += 1
end

def parse_around(i,j)
  return false if at(i, j).to_i == 0 && at(i, j) != '0'
  k = 1
  nums = []
  while at(i, j - k).to_i != 0 || at(i, j - k) == '0' do
    nums << at(i, j - k)
    set_at(i, j - k, '.')
    k += 1
  end
  nums = nums.reverse
  nums << at(i,j)
  set_at(i,j,'.')
  k = 1
  while at(i, j + k).to_i != 0 || at(i, j + k) == '0' do
    nums << at(i, j + k)
    set_at(i, j + k, '.')
    k += 1
  end
  if nums.empty? then false else nums.join.to_i end
end

$sum = 0
(0..$h-1).each do |i|
  (0..$w-1).each do |j|
    if $grid[i][j] == '*' then
      nums = []
      dirs.each do |di, dj|
        a = parse_around(i + di, j + dj)
        nums << a if a != false
      end
      $sum += nums.inject(&:*) if nums.size == 2
    end
  end
end
p $sum
