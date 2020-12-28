#! /usr/bin/env ruby

def toboggan lst, dx, dy = 1
  lst.each_slice(dy).map.with_index { |l,i| l[0][(dx*i) % l[0].length] }.count ?#
end

lst = File.open('../inputs/day03').readlines.map &:chomp
puts toboggan(lst,3)
puts [1, 3, 5, 7, [1, 2]].map { |args| toboggan(lst,*args) }.reduce :*
