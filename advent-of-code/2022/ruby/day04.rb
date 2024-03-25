File.open('day04').readlines.map(&:chomp).map { |x| x.split(',').map { |x| x.split('-').map(&:to_i) } }.map { |(x,y)| (y[0] >= x[0] && y[1] <= x[1]) || (x[0] >= y[0] && x[1] <= y[1]) }.count { |x| x == true }
File.open('day04').readlines.map(&:chomp).map { |x| x.split(',').map { |x| x.split('-').map(&:to_i) } }.map { |(x,y)| (x[0] <= y[0] && y[0] <= x[1]) || (x[0] <= y[1] && y[1] <= x[1]) || (y[0] <= x[0] && x[0] <= y[1]) |
                                                                                                               (y[0] <= x[1] && x[1] <= y[1]) }.count { |x| x == true }
