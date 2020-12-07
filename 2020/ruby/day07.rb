#! /usr/bin/env ruby

hash = {}
input = File.open('../inputs/day07').read()

input.each_line() do |line|
  key = line.match(/(.*) bags contain/)[1]
  val = line.scan(/(\d+) (.[^,.]*(?= bag))/).map(&->a{[a[1],a[0].to_i]}).to_h
  hash[key] = val
end


def can_shiny (bag, hash)
  return true if hash[bag].keys.include?("shiny gold")
  return hash[bag].keys.any? ->x{can_shiny(x, hash)}
end

def shiny_space(key, hash)
  res = hash[key].values.sum
  hash[key].each do |(k,v)|
    res = res + v * shiny_space(k,hash)
  end
  return res
end

puts hash.keys.map(&->k{can_shiny(k,hash)}).select(&->b{b == true}).length()
puts shiny_space("shiny gold", hash)
