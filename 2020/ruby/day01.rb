#! /usr/bin/env ruby

GOAL = 2020

def part1 lst, goal
  i, j = 0, lst.length - 1
  cur = lst[i] + lst[j]
  while cur != goal && i < lst.length && j >= 0 do
    if cur < goal then
      i += 1
    else
      j -= 1
    end
    cur = lst[i] + lst[j]
  end
  cur == goal ? lst[i] * lst[j] : nil
end

def part2 lst, goal
  lst.length.times do |i|
    tmp = part1(lst, goal - lst[i])
    if tmp != nil then
      return tmp * lst[i]
    end
  end
  nil
end

lst = File.open('../inputs/day01').readlines.map(&:to_i).sort
puts part1(lst, GOAL)
puts part2(lst, GOAL)
