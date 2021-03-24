require 'spec_helper'
require_relative '../day12'

instances = [
  { :problem => %w[F10 N3 F7 R90 F11],
    :valid_1 => 25,
    :valid_2 => 286,
  }
]

RSpec.describe 'day12_1' do
  instances.each do |inst|
    it "The Manhattan distance between that location and the ship's starting position is #{inst[:valid_1]} using bad instructions." do
      input = inst[:problem].map {|a| [a[0], a[1..-1].to_i]}
      expect(Day12.part1(input)).to eq(inst[:valid_1])
    end
  end
end

RSpec.describe 'day12_2' do
  instances.each do |inst|
    it "The Manhattan distance between that location and the ship's starting position is #{inst[:valid_2]} using good instructions." do
      input = inst[:problem].map {|a| [a[0], a[1..-1].to_i]}
      expect(Day12.part2(input)).to eq(inst[:valid_2])
    end
  end
end
