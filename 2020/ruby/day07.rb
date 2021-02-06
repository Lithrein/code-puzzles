#! /usr/bin/env ruby

module Day07
  extend self

  def process_input input
    hash = {}
    input.each_line do |line|
      key = line.match(/(.*) bags contain/)[1]
      val = line.scan(/(\d+) (.[^,.]*(?= bag))/).map {|a| [a[1],a[0].to_i]}.to_h
      hash[key] = val
    end
    return hash
  end

  def can_shiny hash, bag
    keys = hash[bag].keys
    keys.include?("shiny gold") || keys.any? { |x| can_shiny(hash, x) }
  end

  def shiny_space hash, key
    hash[key]
      .map { |(k,v)| v + v * shiny_space(hash, k) }
      .sum
  end

  def part1 hash
    shiny_space(hash, "shiny gold")
  end

  def part2 hash
    hash.keys
      .map { |k| can_shiny(hash, k) }
      .select(&:itself)
      .length
  end
end

if $0 == __FILE__ then
  input = File.open('../inputs/day07').read
  hash = Day07.process_input input

  puts "Part 1: #{Day07.part1 hash}"
  puts "Part 2: #{Day07.part2 hash}"
end
