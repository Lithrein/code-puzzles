#! /usr/bin/env ruby

def process_input line
  res = line.match /^(\d+)-(\d+) ([a-z]): ([a-z]+)$/
  {
    :number => [res[1].to_i, res[2].to_i],
    :letter => res[3],
    :word   => res[4]
  }
end

def part1 lst
  lst.select do |entry|
    cnt = entry[:word].count(entry[:letter])
    entry[:number][0] <= cnt && cnt <= entry[:number][1]
  end.length
end

def part2 lst
  lst.select do |entry|
    (entry[:word][entry[:number][0] - 1] == entry[:letter]) ^
    (entry[:word][entry[:number][1] - 1] == entry[:letter])
  end.length
end

lst = File.open('../inputs/day02').readlines.map &method(:process_input)
puts part1(lst)
puts part2(lst)
