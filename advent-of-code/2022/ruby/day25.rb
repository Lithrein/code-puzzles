input = File.open('../inputs/day25').readlines.map(&:chomp)

def to_dec n
  l = n.split('').map do |c|
    case c
    when '2' then 2
    when '1' then 1
    when '0' then 0
    when '-' then -1
    when '=' then -2
    end
  end

  res = 0
  l.each do |i|
    res = 5 * res + i
  end
  res
end

def to_snafu n
  m = [ '0', '1', '2', '=', '-' ]
  res = []
  while n != 0 do
    res << m[n % 5]
    if n % 5 < 2 then
      n = n / 5
    else
      n = (n + n%5) / 5
    end
  end
  res.reverse.join ""
end

sum = 0
input.each do |s|
  sum += to_dec(s)
end
puts to_snafu(sum)
