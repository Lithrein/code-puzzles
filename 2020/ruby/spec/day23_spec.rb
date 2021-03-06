require 'spec_helper'
require_relative '../day23'

instances = [
  { :problem => "389125467",
    :valid_1 => "67384529",
    :valid_2 => 149245887792,
  } ,
]

RSpec.describe 'day23_1' do
  instances.each do |inst|
    it "The cups after the cup 1 appear in the following order #{inst[:valid_1]}." do
      input = inst[:problem].split('').map(&:to_i)
      expect(Day23.part1(input,100)).to eq(inst[:valid_1])
    end
  end
end

RSpec.describe 'day23_2' do
  instances.each do |inst|
    it "When we multiply the label of the cups which comes clockwise just after the cup 1, we get #{inst[:valid_2]}." do
      input = inst[:problem].split('').map(&:to_i)
      expect(Day23.part2(input+(10..1_000_000).to_a,10000000)).to eq(inst[:valid_2])
    end
  end
end
