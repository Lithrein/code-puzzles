#! /usr/bin/env ruby

def bad_number input
  input.each_cons(26) do |*a,b|
    return b if !a.permutation(2).map(&:sum).include?(b)
  end
end

def thing input, goal
  set, sum = [], 0
  input.each do |e|
    set += [e]
    sum += e
    while sum > goal do
      sum -= set.shift
    end
    return set.min + set.max if sum == goal && set.length > 1
  end
end

input = File.open('../inputs/day09').read.lines.map(&:to_i)
p part1 = bad_number(input)
p part2 = thing(input,part1)
