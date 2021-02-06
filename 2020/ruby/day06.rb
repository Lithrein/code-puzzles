#! /usr/bin/env ruby

module Day06
  extend self

  def part1 input
    input
      .map { |x|
        x.gsub(/\n/, "")
         .split("")
         .uniq }
      .inject(0) { |sum, v| sum + v.length }
  end

  def part2 input
    input
      .map { |x|
        x.split("\n")
         .map { |x| x.split "" }
         .reduce :& }
      .inject(0) { |sum, v| sum + v.length }
  end
end

if $0 == __FILE__
  input = File.open('../inputs/day06').read.split "\n\n"
  puts "Part 1: #{Day06.part1 input}"
  puts "Part 2: #{Day06.part2 input}"
end
