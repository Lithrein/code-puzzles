lines = File.open('../inputs/18.txt').readlines.map(&:chomp)

dirs = {
  'R' => [1, 0],
  'L' => [-1, 0],
  'U' => [0, -1],
  'D' => [0, 1],
}

new_dirs = {
  '0' => 'R',
  '1' => 'D',
  '2' => 'L',
  '3' => 'U',
}

area = 0
perimeter = 0
cur = [0, 0]
lines.each do |line|
  dir, val, color = line.split(' ')
  val = val.to_i
  color = color[1..-2]
  val = color[1..-2].to_i 16
  dir = new_dirs[color[-1..-1]]
  new_cur = [cur[0] + val * dirs[dir][0], cur[1] + val * dirs[dir][1]]
  area += (cur[1] + new_cur[1]) * (cur[0] - new_cur[0])
  cur = new_cur
  perimeter += val
end
p (area + perimeter) / 2 + 1
