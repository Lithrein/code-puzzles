#! /usr/bin/env ruby

def part1 lst, goal
  i, j = 0, lst.length - 1
  cur = lst[i] + lst[j]
  while cur != goal && i < lst.length - 1 && j > 0 do
    if cur < goal then
      i += 1
    else
      j -= 1
    end
    cur = lst[i] + lst[j]
  end
  cur == goal ? [lst[i], lst[j]] : []
end

def part2 lst, goal
  lst.length.times do |i|
    tmp = part1(lst, goal - lst[i])
    if !tmp.empty? then
      return [tmp[0], tmp[1], lst[i]]
    end
  end
  []
end

if $0 == __FILE__ then
  GOAL = 2020

  lst = File.open('../inputs/day01').readlines.map(&:to_i).sort
  puts part1(lst, GOAL).reduce :*
  puts part2(lst, GOAL).reduce :*
end
