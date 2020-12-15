#! /usr/bin/env ruby

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

input = File.open('../inputs/day15').readlines[0].split(',').map(&:to_i)
p iter(input,2020)
p iter(input,30000000)
