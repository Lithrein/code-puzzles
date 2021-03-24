require 'spec_helper'
require_relative '../day14'

instances_1 = [
  { :problem =>
    %q{mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
       mem[8] = 11
       mem[7] = 101
       mem[8] = 0},
    :sol => 165,
  } ,
  { :problem =>
    %q{mask = 000000000000000000000000000000X1001X
       mem[42] = 100
       mask = 00000000000000000000000000000000X0XX
       mem[26] = 1},
    :sol => 51,
  }
]

instances_2 = [
  { :problem =>
    %q{mask = 000000000000000000000000000000X1001X
       mem[42] = 100
       mask = 00000000000000000000000000000000X0XX
       mem[26] = 1},
    :sol => 208,
  }
]

RSpec.describe 'day14_1' do
  instances_1.each do |inst|
    it "The Manhattan distance between that location and the ship's starting position is #{inst[:sol]} using bad instructions." do
      input = inst[:problem].split "\n"
      expect(Day14.part1(input)).to eq(inst[:sol])
    end
  end
end

RSpec.describe 'day14_2' do
  instances_2.each do |inst|
    it "The Manhattan distance between that location and the ship's starting position is #{inst[:sol]} using good instructions." do
      input = inst[:problem].split "\n"
      expect(Day14.part2(input)).to eq(inst[:sol])
    end
  end
end
