require 'spec_helper'
require_relative '../day22'

instances_1 = [
  { :problem =>
    %q{Player 1:
       9
       2
       6
       3
       1

       Player 2:
       5
       8
       4
       7
       10},
    :sol => 306,
  }
]

instances_2 = [
  { :problem =>
    %q{Player 1:
       43
       19

       Player 2:
       2
       29
       14},
    :sol => 369
  } ,
  { :problem =>
    %q{Player 1:
       9
       2
       6
       3
       1

       Player 2:
       5
       8
       4
       7
       10},
    :sol => 291}
]

RSpec.describe 'day22_1' do
  instances_1.each do |inst|
    it "The winning player score is #{inst[:sol]}" do
      stack1, stack2 = inst[:problem].split("\n\n").map(&->x{x.split("\n")[1..-1].map(&:to_i)})
      expect(Day22.part1(stack1, stack2)).to eq(inst[:sol])
    end
  end
end

RSpec.describe 'day22_2' do
  instances_2.each do |inst|
    it "The winning player score is #{inst[:sol]}." do
      stack1, stack2 = inst[:problem].split("\n\n").map(&->x{x.split("\n")[1..-1].map(&:to_i)})
      expect(Day22.part2(stack1, stack2)[1]).to eq(inst[:sol])
    end
  end
end
