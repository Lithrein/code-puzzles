lines = File.open('../inputs/14.txt').readlines.map(&:chomp)

line_idx = 0

def get_pos i,j
  if 0 <= i && i < $h && 0 <= j && j < $w then
    return $table[i][j]
  else
    return true
  end
end

# # P1
# horiz = []
# verti = []
# 
# while 1 do
#   $table = []
#   break if lines[line_idx].nil?
#   table_idx = 0
#   while !lines[line_idx].nil? && lines[line_idx] != "" do
#     $table[table_idx] = lines[line_idx]
#     line_idx += 1
#     table_idx += 1
#   end
#   line_idx += 1
# # $table.each do |t|
# #   puts t
# # end
# $h = $table.size
# $w = $table[0].size
# 
#   # Horiz candidates
#   horiz_mirror_candidates = (0..$h-2).to_a
#   new_horiz_mirror_candidates = []
# 
#   (0..$w-1).each do |j|
#     horiz_mirror_candidates.each do |c|
# #     puts "c: #{c}"
#       new_horiz_mirror_candidates << c if (0..c).all? { |i| 
# #       puts "get_pos(#{i},#{j})"
# #       puts "get_pos(#{c + (c - i).abs + 1},#{j})"
# #       puts "#{get_pos(i,j)} || #{get_pos(c + (c - i).abs + 1,j)} || #{get_pos(i,j)} == #{get_pos(c + (c - i).abs + 1,j)}"
#         get_pos(i,j) == true || get_pos(c + (c - i).abs + 1,j) == true || get_pos(i,j) == get_pos(c + (c - i).abs + 1,j) 
#       }
# #     puts ""
#     end
#     horiz_mirror_candidates = new_horiz_mirror_candidates.clone
#     new_horiz_mirror_candidates = []
#   end
# # puts "horiz_mirror_candidates: #{horiz_mirror_candidates}"
#   horiz << horiz_mirror_candidates
# 
#   # Vert candidates
#   vert_mirror_candidates = (0..$w-2).to_a
#   new_vert_mirror_candidates = []
# 
#   (0..$h-1).each do |i|
#     vert_mirror_candidates.each do |c|
# #     puts "c: #{c}"
#       new_vert_mirror_candidates << c if (0..c).all? { |j| 
# #       puts "#{get_pos(i,j)} || #{get_pos(i, c + (c - j).abs + 1)} || #{get_pos(i,j)} == #{get_pos(i, c + (c - j).abs + 1)}"
#         get_pos(i,j) == true || get_pos(i, c + (c - j).abs + 1) == true || get_pos(i,j) == get_pos(i, c + (c - j).abs + 1) 
#       }
# #    puts ""
#     end
#     vert_mirror_candidates = new_vert_mirror_candidates.clone
#     new_vert_mirror_candidates = []
#   end
# 
# # puts "vert_mirror_candidates: #{vert_mirror_candidates}"
#   verti << vert_mirror_candidates
# end
# p 100 * horiz.flatten.map { |i| i + 1 }.sum + verti.flatten.map { |i| i + 1 }.sum
# p horiz.flatten.size
# p verti.flatten.size
# exit

# P2
horiz = []
verti = []

while 1 do
  $table = []
  break if lines[line_idx].nil?
  table_idx = 0
  while !lines[line_idx].nil? && lines[line_idx] != "" do
    $table[table_idx] = lines[line_idx]
    line_idx += 1
    table_idx += 1
  end
  line_idx += 1
# $table.each do |t|
#   puts t
# end
$h = $table.size
$w = $table[0].size

  # Horiz candidates
  horiz_mirror_candidates = (0..$h-2).to_a
  new_horiz_mirror_candidates = []

  candidates_0 = Hash.new 0
  candidates_1 = Hash.new 0
  (0..$w-1).each do |j|
    horiz_mirror_candidates.each do |c|
#     puts "c: #{c}"
      cnt = 0
      (0..c).each { |i| 
#       puts "get_pos(#{i},#{j})"
#       puts "get_pos(#{c + (c - i).abs + 1},#{j})"
#       puts "#{get_pos(i,j)} || #{get_pos(c + (c - i).abs + 1,j)} || #{get_pos(i,j)} == #{get_pos(c + (c - i).abs + 1,j)}"
        cnt += 1 if get_pos(i,j) == true || get_pos(c + (c - i).abs + 1,j) == true || get_pos(i,j) == get_pos(c + (c - i).abs + 1,j) 
      }
      new_horiz_mirror_candidates << c if cnt >= (0..c).to_a.size - 1
      candidates_0[c] += 1 if cnt >= (0..c).to_a.size - 1
      candidates_1[c] += 1 if cnt == (0..c).to_a.size - 1
#     puts ""
    end
    horiz_mirror_candidates = new_horiz_mirror_candidates.clone
    new_horiz_mirror_candidates = []
  end
# puts "horiz_mirror_candidates: #{horiz_mirror_candidates}"
# puts "horiz #{$w} [["
# p candidates_0
# p candidates_1
  okh = -1
  (candidates_0.keys & candidates_1.keys).each do |k|
    okh = k if candidates_0[k] == $w && candidates_1[k] == 1
  end
# puts "]] #{okh} horiz"
  horiz << okh if okh != -1

  # Vert candidates
  vert_mirror_candidates = (0..$w-2).to_a
  new_vert_mirror_candidates = []

  candidates_0 = Hash.new 0
  candidates_1 = Hash.new 0
  (0..$h-1).each do |i|
    vert_mirror_candidates.each do |c|
#    puts "c: #{c} #{$table[i]}"
      cnt = 0
      (0..c).each { |j| 
#      puts "#{get_pos(i,j)} || #{get_pos(i, c + (c - j).abs + 1)} || #{get_pos(i,j)} == #{get_pos(i, c + (c - j).abs + 1)}"
        cnt += 1 if get_pos(i,j) == true || get_pos(i, c + (c - j).abs + 1) == true || get_pos(i,j) == get_pos(i, c + (c - j).abs + 1) 
      }
      new_vert_mirror_candidates << c if cnt >= (0..c).to_a.size - 1
      candidates_0[c] += 1 if cnt >= (0..c).to_a.size - 1
      candidates_1[c] += 1 if cnt == (0..c).to_a.size - 1
#   p cnt
#   puts ""
    end
    vert_mirror_candidates = new_vert_mirror_candidates.clone
    new_vert_mirror_candidates = []
  end
#  puts "vert #{$h} [["
#  p candidates_0
#  p candidates_1
  okv = -1
  (candidates_0.keys & candidates_1.keys).each do |k|
    okv = k if candidates_0[k] == $h && candidates_1[k] == 1
  end
#  puts "]] #{okv} vert"

# puts "vert_mirror_candidates: #{vert_mirror_candidates}"
  verti << okv if okv != -1

# p [okv, okh]
  if okv == -1 && okh == -1 then
    $table.each do |t|
      puts t
    end
  end
end
# p horiz.flatten.size
# p verti.flatten.size
p 100 * horiz.flatten.map { |i| i + 1 }.sum + verti.flatten.map { |i| i + 1 }.sum


