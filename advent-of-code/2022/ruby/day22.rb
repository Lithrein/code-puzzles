*input_map, movements = File.open('../inputs/day22ex').readlines.map(&:chomp)

hash_map = { }
input_map.each.with_index do |row, i|
  row.split('').each.with_index do |elem, j|
    hash_map[[j, i]] = elem if elem != " "
  end
end

cur = hash_map.keys.min do |a,b|
  fst = a[1] - b[1]
  if fst != 0 then fst else a[0] - b[0] end
end
nxt = []
dir = '>'

dir_moves = { '>' => [1, 0], 'v' => [0, 1], '<' => [-1, 0], '^' => [0, -1] }
keys = dir_moves.keys
mvts = movements.scan(/\d+|./)

# (0..20).each do |j|
#   (0..20).each do |i|
#     if hash_map.key? [i,j] then
#     print hash_map[[i,j]]
#     else
#       print ' '
#     end
#   end
#   puts ""
# end

mvts.each do |m|
  case m
  when "L"
#    puts "L"
    dir = keys[(keys.find_index(dir) - 1) % 4]
  when "R"
#    puts "R"
    dir = keys[(keys.find_index(dir) + 1) % 4]
  else
    steps = m.to_i
    while steps > 0 do
      if hash_map.key?([cur[0] + dir_moves[dir][0], cur[1] + dir_moves[dir][1]]) then
        nxt = [cur[0] + dir_moves[dir][0], cur[1] + dir_moves[dir][1]]
      else
#        wrap = true
        case dir
        when 'v'
          nxt = [cur[0], hash_map.keys.select { |x,y| x == cur[0] }.min { |a,b| a[1] <=> b[1] }[1]]
        when '^'
          nxt = [cur[0], hash_map.keys.select { |x,y| x == cur[0] }.max { |a,b| a[1] <=> b[1] }[1]]
        when '>'
          nxt = [hash_map.keys.select { |x,y| y == cur[1] }.min { |a,b| a[0] <=> b[0] }[0], cur[1]]
        when '<'
          nxt = [hash_map.keys.select { |x,y| y == cur[1] }.max { |a,b| a[0] <=> b[0] }[0], cur[1]]
        end
      end
      if hash_map[[nxt[0], nxt[1]]] == '#' then
#        puts "hitting a wall at #{nxt}"
        break
      else
#        puts "moving #{dir} from #{cur} to #{nxt}"
#        puts "wrap" if wrap == true
#        wrap = false
        cur = nxt
      end
      steps -= 1
    end
  end
end

p cur[0]
p cur[1]
p (cur[0] + 1) * 4 + (cur[1] + 1) * 1000 + dir_moves.keys.find_index(dir)
