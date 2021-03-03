require 'spec_helper'
require_relative '../day19'

instances = [
  { :problem =>
    %q{0: 4 1 5
       1: 2 3 | 3 2
       2: 4 4 | 5 5
       3: 4 5 | 5 4
       4: "a"
       5: "b"

       ababbb
       bababa
       abbbab
       aaabbb
       aaaabbb},
    :valid_1 => 2,
    :valid_2 => 2,
  } ,
  { :problem =>
    %q{42: 9 14 | 10 1
       9: 14 27 | 1 26
       10: 23 14 | 28 1
       1: "a"
       11: 42 31
       5: 1 14 | 15 1
       19: 14 1 | 14 14
       12: 24 14 | 19 1
       16: 15 1 | 14 14
       31: 14 17 | 1 13
       6: 14 14 | 1 14
       2: 1 24 | 14 4
       0: 8 11
       13: 14 3 | 1 12
       15: 1 | 14
       17: 14 2 | 1 7
       23: 25 1 | 22 14
       28: 16 1
       4: 1 1
       20: 14 14 | 1 15
       3: 5 14 | 16 1
       27: 1 6 | 14 18
       14: "b"
       21: 14 1 | 1 14
       25: 1 1 | 1 14
       22: 14 14
       8: 42
       26: 14 22 | 1 20
       18: 15 15
       7: 14 5 | 1 21
       24: 14 1

       abbbbbabbbaaaababbaabbbbabababbbabbbbbbabaaaa
       bbabbbbaabaabba
       babbbbaabbbbbabbbbbbaabaaabaaa
       aaabbbbbbaaaabaababaabababbabaaabbababababaaa
       bbbbbbbaaaabbbbaaabbabaaa
       bbbababbbbaaaaaaaabbababaaababaabab
       ababaaaaaabaaab
       ababaaaaabbbaba
       baabbaaaabbaaaababbaababb
       abbbbabbbbaaaababbbbbbaaaababb
       aaaaabbaabaaaaababaa
       aaaabbaaaabbaaa
       aaaabbaabbaaaaaaabbbabbbaaabbaabaaa
       babaaabbbaaabaababbaabababaaab
       aabbbbbaabbbaaaaaabbbbbababaaaaabbaaabba},
    :valid_1 => 3,
    :valid_2 => 12,
  } ,
]

RSpec.describe 'day19_1' do
  instances.each do |inst|
    it "#{inst[:valid_2]} messages completely match rule 0." do
      raw_rules, input = inst[:problem].split("\n\n").map { |x| x.split("\n") }
      rules = Day19.parse_rule raw_rules
      expect(Day19.part1(input, rules)).to eq(inst[:valid_1])
    end
  end
end

RSpec.describe 'day19_2' do
  instances.each do |inst|
    it "After updating rules 8 and 11, #{inst[:valid_2]} messages completely match rule 0." do
      raw_rules, input = inst[:problem].split("\n\n").map { |x| x.split("\n") }
      rules = Day19.parse_rule raw_rules
      expect(Day19.part2(input, rules)).to eq(inst[:valid_2])
    end
  end
end
