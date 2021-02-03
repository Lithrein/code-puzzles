#! /usr/bin/env ruby

module Day02
  def self.process_input line
    res = line.match /^(\d+)-(\d+) ([a-z]): ([a-z]+)$/
    {
      :number => [res[1].to_i, res[2].to_i],
      :letter => res[3],
      :word   => res[4]
    }
  end

  def self.part1 lst
    lst.select do |entry|
      cnt = entry[:word].count(entry[:letter])
      entry[:number][0] <= cnt && cnt <= entry[:number][1]
    end.length
  end

  def self.part2 lst
    lst.select do |entry|
      (entry[:word][entry[:number][0] - 1] == entry[:letter]) ^
      (entry[:word][entry[:number][1] - 1] == entry[:letter])
    end.length
  end
end

if $0 == __FILE__ then
  lst = File.open('../inputs/day02').readlines.map &Day02.method(:process_input)
  puts "Part 1: #{Day02.part1(lst)}"
  puts "Part 2: #{Day02.part2(lst)}"
end
