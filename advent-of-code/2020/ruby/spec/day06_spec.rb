require 'spec_helper'
require_relative '../day06'

instances = [
  { :problem =>
    %q{abc

       a
       b
       c

       ab
       ac

       a
       a
       a
       a

       b},
    :valid_1 => 11,
    :valid_2 => 6,
  } ,
  { :problem =>
    %q{abcx
       abcy
       abcz},
    :valid_1 => 6,
    :valid_2 => 3,
  }
]

RSpec.describe 'day06_1' do
  instances.each do |inst|
    it "assert the number of questions where at least one person answered yes is #{inst[:valid_1]}." do
      input = inst[:problem].split "\n\n"
      expect(Day06.part1(input)).to eq(inst[:valid_1])
    end
  end
end

RSpec.describe 'day06_2' do
  instances.each do |inst|
    it "assert the number of questions where all persons answered yes is #{inst[:valid_1]}." do
      input = inst[:problem].split "\n\n"
      expect(Day06.part2(input)).to eq(inst[:valid_2])
    end
  end
end
