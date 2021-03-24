require 'spec_helper'
require_relative '../day10'

instances = [
  { :problem => [16, 10, 15, 5, 1, 11, 7, 19, 6, 12, 4],
    :valid_1 => 35,
    :valid_2 => 8,
  } ,
  { :problem => [28, 33, 18, 42, 31, 14, 46, 20, 48, 47, 24, 23, 49, 45, 19,
                 38, 39, 11, 1,  32, 25, 35, 8,  17, 7,  9,  4,  2,  34, 10, 3],
    :valid_1 => 220,
    :valid_2 => 19208,
  }
]

RSpec.describe 'day10_1' do
  instances.each do |inst|
    it "The number of 1-diff multiplied by the number of 3-diff is #{inst[:valid_1]}" do
      input = inst[:problem].sort
      expect(Day10.part1(input)).to eq(inst[:valid_1])
    end
  end
end

RSpec.describe 'day10_2' do
  instances.each do |inst|
    it "The number of ways the adapters can be combined is #{inst[:valid_2]}" do
      input = inst[:problem].sort
      expect(Day10.part2(input)).to eq(inst[:valid_2])
    end
  end
end
