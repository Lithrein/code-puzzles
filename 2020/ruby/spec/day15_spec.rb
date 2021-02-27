require 'spec_helper'
require_relative '../day15'

instances = [
  { :problem => [0,3,6],
    :valid_1 => 436,
    :valid_2 => 175594,
  } ,
  { :problem => [1,3,2],
    :valid_1 => 1,
    :valid_2 => 2578,
  } ,
  { :problem => [2,1,3],
    :valid_1 => 10,
    :valid_2 => 3544142,
  } ,
  { :problem => [1,2,3],
    :valid_1 => 27,
    :valid_2 => 261214,
  } ,
  { :problem => [2,3,1],
    :valid_1 => 78,
    :valid_2 => 6895259,
  } ,
  { :problem => [3,2,1],
    :valid_1 => 438,
    :valid_2 => 18,
  } ,
  { :problem => [3,1,2],
    :valid_1 => 1836,
    :valid_2 => 362,
  } ,
]

RSpec.describe 'day15_1' do
  instances.each do |inst|
    it "The Manhattan distance between that location and the ship's starting position is #{inst[:valid_1]} using bad instructions." do
      input = inst[:problem]
      expect(Day15.part1(input)).to eq(inst[:valid_1])
    end
  end
end

RSpec.describe 'day15_2' do
  instances.each do |inst|
    it "The Manhattan distance between that location and the ship's starting position is #{inst[:valid_2]} using good instructions." do
      input = inst[:problem]
      expect(Day15.part2(input)).to eq(inst[:valid_2])
    end
  end
end
