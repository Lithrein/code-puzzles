#! /usr/bin/env ruby

def bad_number input
  input.each_cons(26) do |*a,b|
    return b if !a.permutation(2).map(&:sum).include?(b)
  end
end

def thing input, goal, i = 0, j = 0, sum = 0
  return "boom" if i >= input.size or j >= input.size
  return thing(input, goal, i, j + 1, sum + input[j]) if sum < goal
  return thing(input, goal, i + 1, j, sum - input[i]) if sum > goal
  return input[i..j].minmax.sum
end

input = File.open('../inputs/day09').read.lines.map(&:to_i)
p part1 = bad_number(input)
p part2 = thing(input, part1)
