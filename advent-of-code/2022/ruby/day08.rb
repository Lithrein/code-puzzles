input = File.open('../inputs/day08').readlines.map { |x| x.chomp.split('').map(&:to_i) }

nb = 0
imax = input.size
jmax = input[0].size

visible = []
score = []

# init
(0..imax - 1).each do |i|
  max = -1
  visible[i] = []
  score[i] = []
  (0..jmax - 1).each do |j|
    visible[i][j] = 0
    score[i][j] = 1
  end
end

# g -> d
(0..imax-1).each do |i|
  max = -1
  (0..jmax-1).each do |j|
    if input[i][j] > max then
      visible[i][j] += 1
      max = input[i][j]
    end
    s = 0
    (j+1..jmax-1).each do |jj|
      s += 1
      break if input[i][jj] >= input[i][j]
    end
    score[i][j] *= s
  end
end

# d -> g
(0..imax - 1).each do |i|
  max = -1
  (0..jmax - 1).to_a.reverse.each do |j|
    if input[i][j] > max then
      visible[i][j] += 1
      max = input[i][j]
    end
    s = 0
    (0..j-1).to_a.reverse.each do |jj|
      s += 1
      break if input[i][jj] >= input[i][j]
    end
    score[i][j] *= s
  end
end

# h -> b
(0..imax-1).each do |i|
  max = -1
  (0..jmax-1).each do |j|
    if input[j][i] > max then
      nb += 1
      visible[j][i] += 1
      max = input[j][i]
    end
    s = 0
    (j+1..jmax-1).each do |jj|
      s += 1
      break if input[jj][i] >= input[j][i]
    end
    score[j][i] *= s
  end
end

# b -> h
(0..imax - 1).each do |i|
  max = -1
  (0..jmax - 1).to_a.reverse.each do |j|
    if input[j][i] > max then
      visible[j][i] += 1
      max = input[j][i]
    end
    s = 0
    (0..j-1).to_a.reverse.each do |jj|
      s += 1
      break if input[jj][i] >= input[j][i]
    end
    score[j][i] *= s
  end
end

nb = 0
puts "visible"
(0..imax - 1).each do |i|
  max = 0
  (0..jmax - 1).each do |j|
    if visible[i][j] > 0
      nb += 1
    end
    print "#{visible[i][j] }"
  end
  puts ""
end

puts ""
puts "score"
max2=0
(0..imax - 1).each do |i|
  max = 0
  (0..jmax - 1).each do |j|
    if score[i][j] > max2
      max2 = score[i][j]
    end
    print "#{ "%2d" % score[i][j]} "
  end
  puts ""
end
puts nb
puts max2
