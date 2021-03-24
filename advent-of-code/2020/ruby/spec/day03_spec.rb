require 'spec_helper'
require_relative '../day03'

instances = [
  { :problem => [
    "..##.......",
    "#...#...#..",
    ".#....#..#.",
    "..#.#...#.#",
    ".#...##..#.",
    "..#.##.....",
    ".#.#.#....#",
    ".#........#",
    "#.##...#...",
    "#...##....#",
    ".#..#...#.#"
  ],
    :sol1 => 7,
    :sol2 => 336
  }
]

RSpec.describe 'day02_1' do
  instances.each do |inst|
    it "assert that the number of trees on the path in `#{inst[:problem]}` is `#{inst[:sol1]}`" do
      input = inst[:problem]
      expect(Day03.part1(input)).to eq(inst[:sol1])
    end
  end
end

RSpec.describe 'day02_2' do
  instances.each do |inst|
    it "assert that the number of trees on the paths in `#{inst[:problem]}` is `#{inst[:sol2]}`" do
      input = inst[:problem]
      expect(Day03.part2(input)).to eq(inst[:sol2])
    end
  end
end
