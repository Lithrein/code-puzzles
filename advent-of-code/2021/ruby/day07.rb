a = File.open('../inputs/day07').readline.split(',').map(&:to_i).sort
med = a[a.length/2]
s = ->n{ (n.abs + 1) * n.abs / 2 }
p a.map { |i| (i - med).abs }.sum #p1
p (0..a.max).map { |c| a.map { |i| s.call (i - c) }.sum }.min #p2
