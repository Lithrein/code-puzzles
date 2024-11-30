# lines = File.open('../inputs/14.txt').readlines.map(&:chomp)
# 
# $h = lines.size
# $w = lines[0].size
# 
# score = 0
# (0..$w-1).each do |j|
#   cur = 0
#   (0..$h-1).each do |i|
#     while cur < $h && lines[cur][j] == '#' do
#       cur += 1
#     end
#     if lines[i][j] == '#' then
#       cur = i + 1
#     end
#     if lines[i][j] == 'O' then
#       lines[i][j] = '.'
#       lines[cur][j] = 'O'
#       score += $w - cur
#       cur += 1
#     end
#   end
# end
# puts score

lines = File.open('../inputs/14.txt').readlines.map(&:chomp)
$h = lines.size
$w = lines[0].size

# lines.each do |line|
#   puts line
# end

memo = Hash.new 0
memo_id = {}

memo[lines.join] += 1
memo_id[lines.join] = [0]
scores = []
time = 1
score = 0
1000000000.times do
  # North fall
  (0..$w-1).each do |j|
    cur = 0
    (0..$h-1).each do |i|
      while cur < $h && lines[cur][j] == '#' do cur += 1 end
      if lines[i][j] == '#' then cur = i + 1 end
      if lines[i][j] == 'O' then
        lines[i][j] = '.'
        lines[cur][j] = 'O'
        cur += 1
      end
    end
  end

  # West fall
  (0..$h-1).each do |i|
    cur = 0
    (0..$w-1).each do |j|
      while cur < $w && lines[i][cur] == '#' do cur += 1 end
      if lines[i][j] == '#' then cur = j + 1 end
      if lines[i][j] == 'O' then
        lines[i][j] = '.'
        lines[i][cur] = 'O'
        cur += 1
      end
    end
  end


  # South fall
  (0..$w-1).each do |j|
    cur = $h-1
    (0..$h-1).reverse_each do |i|
      while cur >= 0 && lines[cur][j] == '#' do cur -= 1 end
      if lines[i][j] == '#' then cur = i - 1 end
      if lines[i][j] == 'O' then
        lines[i][j] = '.'
        lines[cur][j] = 'O'
        cur -= 1
      end
    end
  end

  score = 0
  # East fall
  (0..$h-1).each do |i|
    cur = $w-1
    (0..$w-1).reverse_each do |j|
      while cur >= 0 && lines[i][cur] == '#' do cur -= 1 end
      if lines[i][j] == '#' then cur = j - 1 end
      if lines[i][j] == 'O' then
        lines[i][j] = '.'
        lines[i][cur] = 'O'
        score += $w - i
        cur -= 1
      end
    end
  end
  puts "time: #{time} score: #{score}"

  time += 1
  memo[lines.join] += 1
  if memo_id[lines.join].nil? then
    memo_id[lines.join] = [time]
  else
    memo_id[lines.join] << time
  end

  scores[time] = score 
    
  if memo[lines.join] > 1 then
    # p time
    # p memo_id[lines.join]
    break
  end
end

tmp = memo_id[lines.join]

p scores[1 + tmp[0] + (1000000000 - tmp[0]) % (tmp[1] - tmp[0])]

# puts ""
# lines.each do |line|
#   puts line
# end


exit
# North tilt
(0..$w-1).each do |j|
  (0..$h-1).each do |i|
    if 0 <= i - 1 && lines[i - 1][j] == '.' && lines[i][j] == 'O' then
      lines[i - 1][j] = 'O'
      lines[i][j] = '.'
    end
  end
end

# West tilt
(0..$h-1).each do |i|
  (0..$w-1).each do |j|
    if 0 <= j - 1 && lines[i][j - 1] == '.' && lines[i][j] == 'O' then
      lines[i][j - 1] = 'O'
      lines[i][j] = '.'
    end
  end
end

# South tilt
(0..$w-1).each do |j|
  (0..$h-1).reverse_each do |i|
    if i + 1 < $h && lines[i + 1][j] == '.' && lines[i][j] == 'O' then
      lines[i + 1][j] = 'O'
      lines[i][j] = '.'
    end
  end
end
