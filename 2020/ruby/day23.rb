#! /usr/bin/env ruby

def part1 lst, n
  lst = lst.clone
  len = lst.length
  cur_cup_idx = 0

  n.times do |_|
    cur_cup_val = lst[cur_cup_idx]
    cups = [lst[(cur_cup_idx + 1) % len]] \
         + [lst[(cur_cup_idx + 2) % len]] \
         + [lst[(cur_cup_idx + 3) % len]]
    lst -= cups
    dst_cup = (cur_cup_val - 2) % len + 1
    while cups.include? dst_cup do
      dst_cup = (dst_cup - 2) % len + 1
    end
    dst_cup_idx = lst.index dst_cup
    lst = lst[0..dst_cup_idx] + cups + lst[dst_cup_idx+1..-1]
    cur_cup_idx = (lst.index(cur_cup_val) + 1) % lst.length
  end
  lst
end

input = "389125467"
input = File.open('../inputs/day23').read.chomp
lst = input.split('').map(&:to_i)
p part1(lst,100).join
