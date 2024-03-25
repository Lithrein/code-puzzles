puts "P1: #{File.open('../inputs/day1').readlines.join.split("\n\n").map { |x| x.split("\n").map(&:to_i).sum }.max}"
puts "P2: #{File.open('../inputs/day1').readlines.join.split("\n\n").map { |x| x.split("\n").map(&:to_i).sum }.sort.reverse[0..2].sum}"
