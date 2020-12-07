#! /usr/bin/env ruby

$hash = {}
input = File.open('../inputs/day07').read

input.each_line do |line|
  key = line.match(/(.*) bags contain/)[1]
  val = line.scan(/(\d+) (.[^,.]*(?= bag))/).map {|a| [a[1],a[0].to_i]}.to_h
  $hash[key] = val
end

def can_shiny bag
  keys = $hash[bag].keys
  keys.include?("shiny gold") || keys.any? {|x| can_shiny x}
end

def shiny_space key
  $hash[key].map {|(k,v)| v + v * shiny_space(k)}.sum
end

puts $hash.keys.map {|k| can_shiny k}.select(&:itself).length
puts shiny_space "shiny gold"
