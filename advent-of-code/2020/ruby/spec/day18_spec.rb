require 'spec_helper'
require_relative '../day18'

instances = [
  { :problem => ["1 + 2 * 3 + 4 * 5 + 6"],
    :valid_1 => 71,
    :valid_2 => 231,
  } ,
  { :problem => ["1 + (2 * 3) + (4 * (5 + 6))"],
    :valid_1 => 51,
    :valid_2 => 51,
  } ,
  { :problem => ["2 * 3 + (4 * 5)"],
    :valid_1 => 26,
    :valid_2 => 46,
  } ,
  { :problem => ["5 + (8 * 3 + 9 + 3 * 4 * 3)"],
    :valid_1 => 437,
    :valid_2 => 1445,
  } ,
  { :problem => ["5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))"],
    :valid_1 => 12240,
    :valid_2 => 669060,
  } ,
  { :problem => ["((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2 "],
    :valid_1 => 13632,
    :valid_2 => 23340,
  } ,
]

RSpec.describe 'day18_1' do
  instances.each do |inst|
    it "#{inst[:problem]} evaluates to #{inst[:valid_1]}." do
      input = inst[:problem]
      expect(Day18.part1(input)).to eq(inst[:valid_1])
    end
  end
end

RSpec.describe 'day18_2' do
  instances.each do |inst|
    it "#{inst[:problem]} evaluates to #{inst[:valid_2]}." do
      input = inst[:problem]
      expect(Day18.part2(input)).to eq(inst[:valid_2])
    end
  end
end
