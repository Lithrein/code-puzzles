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
  lst.join
end

def part2 lst, n
  # 1. build a linked list out of `lst`
  len = lst.length
  head = {}
  node_from_val = {}
  head[:val], head[:nxt] = lst.shift, nil
  node_from_val[head[:val]] = head
  cur = head
  while !lst.empty? do
    new = {}
    new[:val], cur[:nxt] = lst.shift, new
    node_from_val[new[:val]] = new
    cur = new
  end
  cur[:nxt] = head

  # 2. Do the same as part1 but efficiently
  n.times do |_|
    # 2.1 `head` contains the current cup
    # 2.2 remove the next three cups
    three_cups_labels =                \
        [head[:nxt][:val]]             \
      + [head[:nxt][:nxt][:val]]       \
      + [head[:nxt][:nxt][:nxt][:val]]
    three_cups = head[:nxt]
    head[:nxt] = head[:nxt][:nxt][:nxt][:nxt]
    # 2.3 select the destination cup
    dest_cup_val = (head[:val] - 2) % len + 1
    while three_cups_labels.include? dest_cup_val do
      dest_cup_val = (dest_cup_val - 2) % len + 1
    end
    # 2.4 find the destination cup
    dest_cup = node_from_val[dest_cup_val]
    # 2.5 insert the `three_cups` after `dest_cup`
    three_cups[:nxt][:nxt][:nxt] = dest_cup[:nxt]
    dest_cup[:nxt] = three_cups
    head = head[:nxt]
  end

  # 3. Find "one"
  head = node_from_val[1]
  head[:nxt][:val] * head[:nxt][:nxt][:val]
end

input = "389125467"
input = File.open('../inputs/day23').read.chomp
lst = input.split('').map(&:to_i)
puts part1(lst,100)
puts part2(lst+(10..1_000_000).to_a,10000000)
