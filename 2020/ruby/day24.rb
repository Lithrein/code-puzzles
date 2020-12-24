#! /usr/bin/env ruby

def walk path
  x, y = 0, 0
  path.each do |c|
    case c
    when 'ne' then
      y += 1
    when 'nw' then
      x += 1
    when 'se' then
      x -= 1
    when 'sw' then
      y -= 1
    end
  end
  [x,y]
end

def part1 paths
  marked = Hash.new 0
  paths.each do |path|
    pos = walk(path)
    marked[pos] += 1
  end
  marked.values.select { |m| m % 2 == 1 }.length
end

input = File.open('../inputs/day24').read.lines.map(&:chomp)

paths = input.map do |str|
  str.gsub(/(?<!n|s)e/, "nese")
     .gsub(/(?<!n|s)w/, "nwsw")
     .split('')
     .each_slice(2).to_a
     .map(&:join)
end

puts part1(paths)
