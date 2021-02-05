#! /usr/bin/env ruby

module Day05
  extend self

  def seat_id pass
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

  def find_seat seats
    last_seat = -1
    seats.each do |seat|
      return seat unless seat - last_seat == 1
      last_seat = seat
    end
  end

  def part1 lst
    lst.map { |id| seat_id(id) }.max
  end

  def part2 lst
    find_seat(lst.inject((0..1023).to_a) { |acc, s| acc - [seat_id(s)] })
  end
end

if $0 == __FILE__ then
  lst = File.open('../inputs/day05').readlines
  puts "Part 1: #{Day05.part1 lst}"
  puts "Part 2: #{Day05.part2 lst}"
end

