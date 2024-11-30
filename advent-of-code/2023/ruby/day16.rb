lines = File.open('../inputs/16.txt').readlines.map(&:chomp)

dirs = { '>' => [0, 1], '<' => [0,-1], '^' => [-1,0], 'v' => [1, 0] }
h = lines.size
w = lines[0].size

configs = (0..w-1).map { |j| [0, j, 'v'] } +
  (0..w-1).map { |j| [h-1, j, '^'] } +
  (0..h-1).map { |i| [i, 0, '>'] } +
  (0..h-1).map { |i| [i, w-1, '>'] }

p nb_configs = configs.size

define_method 'get_pos' do |lines, i, j|
  if 0 <= i && i < h && 0 <= j && j < w then
    return lines[i][j]
  else
    return nil
  end
end

m = 0
i = 0
configs.each do |config|
  i += 1
  puts "#{(100.0 * i) / nb_configs}"
#  worklist_p1 = [ [0, 0, '>'] ]
  worklist = [ config ]
  visited = {}
  visited_bis = Hash.new false

  while !worklist.empty? do
    cur = worklist[0]
    worklist = worklist[1..-1]
    next unless 0 <= cur[0] && cur[0] < h && 0 <= cur[1] && cur[1] < w
    visited["#{cur[0]}-#{cur[1]}"] = true
    visited_bis["#{cur[0]}-#{cur[1]}-#{cur[2]}"] = true

    dir = cur[2]

    if (dir == '>' || dir == '<') && get_pos(lines,cur[0],cur[1]) == '|' then
      worklist << [ cur[0] - 1, cur[1], '^' ] unless visited_bis["#{cur[0] - 1}-#{cur[1]}-^"]
      worklist << [ cur[0] + 1, cur[1], 'v' ] unless visited_bis["#{cur[0] + 1}-#{cur[1]}-v"]
    elsif (dir == '^' || dir == 'v') && get_pos(lines,cur[0],cur[1]) == '-' then
      worklist << [ cur[0], cur[1] - 1, '<' ] unless visited_bis["#{cur[0]}-#{cur[1] - 1}-<"]
      worklist << [ cur[0], cur[1] + 1, '>' ] unless visited_bis["#{cur[0]}-#{cur[1] + 1}->"]
    elsif dir == '>' && get_pos(lines,cur[0],cur[1]) == '\\' then
      worklist << [ cur[0] + 1, cur[1], 'v' ] unless visited_bis["#{cur[0] + 1}-#{cur[1]}-v"]
    elsif dir == '<' && get_pos(lines,cur[0],cur[1]) == '\\' then
      worklist << [ cur[0] - 1, cur[1], '^' ] unless visited_bis["#{cur[0] - 1}-#{cur[1]}-^"]
    elsif dir == '^' && get_pos(lines,cur[0],cur[1]) == '\\' then
      worklist << [ cur[0], cur[1] - 1, '<' ] unless visited_bis["#{cur[0]}-#{cur[1] - 1}-<"]
    elsif dir == 'v' && get_pos(lines,cur[0],cur[1]) == '\\' then
      worklist << [ cur[0], cur[1] + 1, '>' ] unless visited_bis["#{cur[0]}-#{cur[1] + 1}->"]
    elsif dir == '>' && get_pos(lines,cur[0],cur[1]) == '/' then
      worklist << [ cur[0] - 1, cur[1], '^' ] unless visited_bis["#{cur[0] - 1}-#{cur[1]}-^"]
    elsif dir == '<' && get_pos(lines,cur[0],cur[1]) == '/' then
      worklist << [ cur[0] + 1, cur[1], 'v' ] unless visited_bis["#{cur[0] + 1}-#{cur[1]}-v"]
    elsif dir == '^' && get_pos(lines,cur[0],cur[1]) == '/' then
      worklist << [ cur[0], cur[1] + 1, '>' ] unless visited_bis["#{cur[0]}-#{cur[1] + 1}->"]
    elsif dir == 'v' && get_pos(lines,cur[0],cur[1]) == '/' then
      worklist << [ cur[0], cur[1] - 1, '<' ] unless visited_bis["#{cur[0]}-#{cur[1] - 1}-<"]
    else
      worklist << [ cur[0] + dirs[dir][0], cur[1] + dirs[dir][1], dir ] unless visited_bis["#{cur[0] + dirs[dir][0]}-#{cur[1] + dirs[dir][1]}-#{dir}"]
    end
  end

  m = [m, visited.keys.size].max
  # puts "#{config} #{visited.keys.size}"
end
p m

# (0..h-1).each do |i|
#   (0..w-1).each do |j|
#     print (if visited["#{i}-#{j}"] then '#' else lines[i][j] end)
#   end
#   puts ""
# end

