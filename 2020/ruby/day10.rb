#! /usr/bin/env ruby


def part1 input
  current_max, chain = 0, []
  loop {
    current_max = input.select {|a| a > current_max && a <= current_max + 3}.min
    break if current_max == nil
    chain += [current_max]
  }
  chain = ([0] + chain + [input.max + 3]).each_cons(2).map {|x,y| y - x}
  return chain.count(1) * chain.count(3)
end

def part2 input
  arr = Hash.new 0
  arr[input.length - 1] = 1
  (0..input.length-2).reverse_each do |idx|
    (idx..idx+3).each do |i|
      if i < input.length then
        arr[idx] += arr[i] if input[i] - input[idx] <= 3
      end
    end
  end
  input.map.with_index {|_,idx| input[idx] <= 3 ? arr[idx] : 0}.sum
end

input = File.open('../inputs/day10').read.lines.map(&:to_i).sort
p part1(input)
p part2(input)
