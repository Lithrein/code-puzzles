#! /usr/bin/env ruby

def parse_rule raw_rules
  hash = {}
  raw_rules.each do |r|
    if r =~ /^\d+: "(?:a|b)"$/ then
      nb, char = r.match(/(\d+): "(a|b)"/)[1..2]
      hash[nb] = [[char]]
    elsif r =~ /^\d+: \d+ \d+$/ then
      nb, r1, r2 = r.match(/^(\d+): (\d+) (\d+)$/)[1..4]
      hash[nb] = [[r1,r2]]
    elsif r =~ /^\d+: \d+ \d+ \d+$/ then
      nb, r1, r2, r3 = r.match(/^(\d+): (\d+) (\d+) (\d+)$/)[1..4]
      hash[nb] = [[r1,r2,r3]]
    elsif r =~ /^\d+: \d+$/ then
      nb, r1 = r.match(/^(\d+): (\d+)$/)[1..3]
      hash[nb] = [[r1]]
    elsif r =~ /^\d+: \d+ \d+ \| \d+ \d+$/ then
      nb, r1, r2, r3, r4 = r.match(/^(\d+): (\d+) (\d+) \| (\d+) (\d+)$/)[1..6]
      hash[nb] = [[r1,r2],[r3,r4]]
    elsif r =~ /^\d+: \d+ \| \d+ \d+$/ then
      nb, r1, r3, r4 = r.match(/^(\d+): (\d+) \| (\d+) (\d+)$/)[1..5]
      hash[nb] = [[r1],[r3,r4]]
    elsif r =~ /^\d+: \d+ \| \d+$/ then
      nb, r1, r3 = r.match(/^(\d+): (\d+) \| (\d+)$/)[1..4]
      hash[nb] = [[r1],[r3]]
    elsif r =~ /^\d+: \d+ \d+ \| \d+$/ then
      nb, r1, r2, r3 = r.match(/^(\d+): (\d+) (\d+) \| (\d+)$/)[1..4]
      hash[nb] = [[r1,r2],[r3]]
    else
      puts "rule parsing error when parsing #{r}"
      exit
    end
  end
  hash
end

def expend_rule1 rules, n
  tmp = rules[n]
  str = ""
  if tmp == [["a"]] || tmp == [["b"]] then
    str = tmp[0][0]
  else
    left  = rules[n][0]
    right = rules[n][1]

    str += '(?:'
    left.each do |nb|
      str += expend_rule1(rules,nb)
    end
    if !right.nil? then
      str += '|'
      right.each do |nb|
        str += expend_rule1(rules,nb)
      end
    end
    str += ')'
  end
  str
end

def part1 input, regex
  input.select {|l| l.match? regex}.length
end


raw_rules, input = File.open('../inputs/day19').read.split("\n\n").map { |x| x.split("\n") }
# raw_rules, input = <<-DATA
# 0: 4 1 5
# 1: 2 3 | 3 2
# 2: 4 4 | 5 5
# 3: 4 5 | 5 4
# 4: "a"
# 5: "b"

# ababbb
# bababa
# abbbab
# aaabbb
# aaaabbb
# DATA
#   .split("\n\n")
#   .map { |x| x.split("\n") }
rules = parse_rule(raw_rules)
regex = Regexp.new("^" + expend_rule1(rules,"0") + "$")
puts part1(input, regex)
