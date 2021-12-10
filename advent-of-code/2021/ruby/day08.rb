file = '../inputs/day08'
a = File.open(file).readlines.map { |l| l.chop.split('|')[1] }.map { |l| l.split ' ' }.flatten.map(&:length)
p a.count(2) + a.count(3) + a.count(4) + a.count(7) #p1

res = 0
File.open(file) do |f|
  f.readlines.each do |line|
    l,r = line.chop.split '|'
    lst = l.split(' ').map { |w| w.split('').sort }
    numbers = r.split(' ').map { |w| w.split('').sort.join }

    one   = lst.filter { |w| w.length == 2 }.flatten
    four  = lst.filter { |w| w.length == 4 }.flatten
    seven = lst.filter { |w| w.length == 3 }.flatten
    eight = lst.filter { |w| w.length == 7 }.flatten

    three = lst.filter { |w| w.length == 5 && w & seven == seven}.flatten
    six   = lst.filter { |w| w.length == 6 && (w & seven) != seven }.flatten
    nine  = lst.filter { |w| w.length == 6 && w & four == four }.flatten
    zero  = lst.filter { |w| w.length == 6 && w != six && w != nine }.flatten

    a = seven - (one & seven)
    bd = four - seven - a

    five = lst.filter { |w| w.length == 5 && (w & bd == bd) }.flatten
    two = lst.filter { |w| w.length == 5 && w != three && w != five }.flatten

    conv = {
      zero.join => 0,
      one.join => 1, two.join => 2, three.join => 3,
      four.join => 4, five.join => 5, six.join => 6,
      seven.join => 7, eight.join => 8, nine.join => 9
    }

    res += numbers.map { |w| conv[w] }.join.to_i
  end
end
p res
