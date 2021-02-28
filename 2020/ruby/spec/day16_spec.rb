require 'spec_helper'
require_relative '../day16'

instances = [
  { :problem =>
    %q{class: 1-3 or 5-7
       row: 6-11 or 33-44
       seat: 13-40 or 45-50

       your ticket:
       7,1,14

       nearby tickets:
       7,3,47
       40,4,50
       55,2,20
       38,6,12},
    :valid_1 => 71,
    :valid_2 => {"row" => 7, "seat" => 14, "class" => 1},
  } ,
  { :problem =>
    %q{class: 0-1 or 4-19
       row: 0-5 or 8-19
       seat: 0-13 or 16-19

       your ticket:
       11,12,13

       nearby tickets:
       3,9,18
       15,1,5
       5,14,9},
    :valid_1 => 0,
    :valid_2 => {"row" => 11, "seat" => 13, "class" => 12},
  } ,
]

RSpec.describe 'day16_1' do
  instances.each do |inst|
    it "Your ticket scanning error rate is #{inst[:valid_1]}" do
      input = inst[:problem]
      rules_raw, ticket_raw, nearby_raw = input.split "\n\n"
      rules = Day16.parse_rules rules_raw
      ticket = ticket_raw.split("\n")[1].split(',').map(&:to_i)
      tickets = nearby_raw.split("\n")[1..-1].map do |l| l.split(',').map(&:to_i) end

      expect(Day16.part1(rules,tickets)).to eq(inst[:valid_1])
    end
  end
end

RSpec.describe 'day16_2' do
  instances.each do |inst|
    it "The assignations for your ticket are #{inst[:valid_2]}" do
      input = inst[:problem]
      rules_raw, ticket_raw, nearby_raw = input.split "\n\n"
      rules = Day16.parse_rules rules_raw
      ticket = ticket_raw.split("\n")[1].split(',').map(&:to_i)
      tickets = nearby_raw.split("\n")[1..-1].map do |l| l.split(',').map(&:to_i) end

      expect(Day16.assign_fields(rules,ticket,tickets)).to eq(inst[:valid_2])
    end
  end
end
