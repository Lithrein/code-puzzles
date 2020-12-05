#! /usr/bin/env ruby

def seat_id (pass)
  lower, upper = 0,127
  (0..6).each do |i|
    if pass[i] == 'B' then lower = (lower + upper) / 2 + 1 end
    if pass[i] == 'F' then upper = (lower + upper) / 2 end
  end
  row = lower

  lower, upper = 0, 7
  (7..9).each do |i|
    if pass[i] == 'R' then lower = (lower + upper) / 2 + 1 end
    if pass[i] == 'L' then upper = (lower + upper) / 2 end
  end
  col = upper

  return row * 8 + col
end

def find_seat (seats)
  last_seat = -1
  seats.each do |seat|
    return seat unless seat - last_seat == 1
    last_seat = seat
  end
end

part1 = 0
part2 = (0..1023).entries
File.open('../inputs/day05').read().each_line do |pass|
  part1 = [part1, seat_id(pass)].max
  part2 = part2 - [seat_id(pass)]
end

puts part1
puts find_seat(part2)
