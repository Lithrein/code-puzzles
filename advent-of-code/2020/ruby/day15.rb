#! /usr/bin/env ruby

module Day15
  extend self
  def iter input, nb
    mem, len, last = {}, input.length, 0
    input.each.with_index do |e,idx|
      mem[e], last = idx, e
    end
    mem[last] = nil
    (len-1..nb-2).each do |i|
      tmp = mem[last]
      mem[last] = i
      last = tmp.nil? ? 0 : i - tmp
    end
    last
  end

  def part1 input
    iter(input, 2020)
  end

  def part2 input
    iter(input, 30_000_000)
  end
end

if $0 == __FILE__ then
  input = File.open('../inputs/day15').readlines[0].split(',').map(&:to_i)
  puts "Part 1: #{Day15.part1 input}"
  puts "Part 2: #{Day15.part2 input}"
end
