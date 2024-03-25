a = [[4,8,3],[1,5,9],[7,2,6]] #p1
a = [[3,4,8],[1,5,9],[2,6,7]] #p2
File.open('input').readlines.map(&:chomp).map { |x| a[x[0].ord - 'A'.ord][x[2].ord - 'X'.ord] }.sum
