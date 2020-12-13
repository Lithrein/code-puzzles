#! /usr/bin/env ruby

def part1 input
  timestamp = input[0].to_i
  depart_time = input[1].split(',').map(&:to_i).select(&:positive?)
  wait = depart_time.map.with_index {|t,idx| [t - (timestamp % t), depart_time[idx]] }.min {|a,b| a[0]<=>b[0]}
  wait[0] * wait[1]
end

def part2 input
  depart_time = input[1].split(',').map(&:to_i).map.with_index {|i,idx| [idx,i]}.select {|idx, i| i > 0}.reverse # (modulo, div)
  depart_time = depart_time.map {|i,j| [(j-i) % j,j] }
  nb, to_add = depart_time[0]
  while depart_time.length > 1 do
    if nb % depart_time[1][1] == depart_time[1][0] then
      to_add *= depart_time[1][1]
      depart_time.shift
    else
      nb += to_add
    end
  end
  nb
end

input = File.open('../inputs/day13').read.lines
# input = ["939\n", "7,13,x,x,59,x,31,19\n"]
p part1(input)
p part2(input)
