#! /usr/bin/env ruby

module Day03
  extend self

  def toboggan lst, dx, dy = 1
    lst
      .each_slice(dy)
      .map.with_index { |l,i| l[0][(dx*i) % l[0].length] }
      .count ?#
  end

  def part1 lst
    toboggan(lst, 3)
  end

  def part2 lst
    [1, 3, 5, 7, [1, 2]]
      .map { |args| toboggan(lst, *args) }
      .reduce :*
  end
end

if $0 == __FILE__ then
  lst = File.open('../inputs/day03').readlines.map &:chomp
  puts "Part 1: #{Day03.part1(lst)}"
  puts "Part 2: #{Day03.part2(lst)}"
end
