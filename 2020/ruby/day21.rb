#! /usr/bin/env ruby

module Day21
  extend self

  def find_allergenes input
    hash = Hash.new []
    final_assoc = Hash.new []

    input.each do |as,bs|
      as.each do |a|
        if hash[a] == [] then
          hash[a] = bs
        else
          hash[a] &= bs
        end
      end
    end

    tmp = hash.select { |k,vs| vs.length == 1 }
    while tmp != {} do
      tmp.each do |k, vs|
        final_assoc[k] = vs[0]
        hash.keys.each do |k|
          hash[k] -= [vs[0]]
        end
      end
      tmp = hash.select { |k,vs| vs.length == 1 }
    end
    final_assoc
  end

  def part1 input, allergenes
    ingredients = []
    input.each do |_,bs|
      ingredients += bs
    end
    allergenes.values.each do |v|
      ingredients -= [v]
    end
    ingredients.length
  end

  def part2 allergenes
    allergenes.keys.sort.map { |k| allergenes[k] }.join ","
  end
end

if $0 == __FILE__ then
  input = File.open('../inputs/day21').readlines
    .map(&:chomp)
    .map(&->x{x.tr("(),","")})
    .map(&->x{x.split(" contains ")})
    .map(&->x{[x[1].split(" "),x[0].split(" ")]})

  allergenes = Day21.find_allergenes(input)
  puts "Part 1: #{Day21.part1(input, allergenes)}"
  puts "Part 2: #{Day21.part2(allergenes)}"
end
