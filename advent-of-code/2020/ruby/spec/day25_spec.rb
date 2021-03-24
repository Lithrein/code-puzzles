require 'spec_helper'
require_relative '../day25'

instances = [
  { :problem => [5764801,17807724],
    :sol => 14897079,
  } ,
]

RSpec.describe 'day25_1' do
  instances.each do |inst|
    it "The encryption key is #{inst[:sol]}." do
      input = inst[:problem]
      expect(Day25.part1(input)).to eq(inst[:sol])
    end
  end
end
