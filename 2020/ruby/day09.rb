#! /usr/bin/env ruby

module Day09
  extend self

  def bad_number input, preamble_size
    input.each_cons(preamble_size) do |*a,b|
      return b if !a.permutation(2).map(&:sum).include?(b)
    end
  end

  def thing input, goal, i = 0, j = 0, sum = 0
    return "boom" if i >= input.size or j >= input.size
    return thing(input, goal, i, j + 1, sum + input[j]) if sum < goal
    return thing(input, goal, i + 1, j, sum - input[i]) if sum > goal
    # maybe a bug here
    return input[i..j-1].minmax.sum
  end

  def part1 input, preamble_size = 26
    bad_number input, preamble_size
  end

  def part2 input, preamble_size = 26
    thing(input, part1(input, preamble_size))
  end
end

if $0 == __FILE__ then
  input = File.open('../inputs/day09').read.lines.map(&:to_i)
  puts "Part 1: #{Day09.part1 input}"
  puts "Part 2: #{Day09.part2 input}"
end
