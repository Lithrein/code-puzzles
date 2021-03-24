require 'spec_helper'
require_relative '../day05'

instances = [
  { :serial => "BFFFBBFRRR",
    :seat => 567,
  },
  { :serial => "FFFBBBFRRR",
    :seat => 119,
  },
  { :serial => "BBFFBBFRLL",
    :seat => 820,
  }
]

RSpec.describe 'day05_seat_id' do
  instances.each do |inst|
    it "assert that the #{inst[:serial]} is seat #{inst[:seat]}" do
      expect(Day05.seat_id(inst[:serial])).to eq(inst[:seat])
    end
  end
end
