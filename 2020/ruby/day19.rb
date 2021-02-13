#! /usr/bin/env ruby

module Day19
  extend self

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

  def nb_matches input, regex
    input.select {|l| l.match? regex}.length
  end

  def expend_rule2 rules, n
    tmp = rules[n]
    str = ""
    if tmp == [["a"]] || tmp == [["b"]] then
      str = tmp[0][0]
    elsif n == "8" then
      str += "(?:" + expend_rule2(rules,"42") + ")+"
    elsif n == "11" then
      a = "(?:" + expend_rule2(rules,"42") + ")"
      b = "(?:" + expend_rule2(rules,"31") + ")"
      str += "(?:(?:#{a}{1}#{b}{1})"           \
        + "|" + "(?:#{a}{2}#{b}{2})"         \
        + "|" + "(?:#{a}{3}#{b}{3})"        \
        + "|" + "(?:#{a}{4}#{b}{4}))"
    else
      left  = rules[n][0]
      right = rules[n][1]

      str += '(?:'
      left.each do |nb|
        str += expend_rule2(rules,nb)
      end
      if !right.nil? then
        str += '|'
        right.each do |nb|
          str += expend_rule2(rules,nb)
        end
      end
      str += ')'
    end
    str
  end

  def part1 input, rules
    regex = Regexp.new("^" + expend_rule1(rules,"0") + "$")
    nb_matches(input, regex)
  end

  def part2 input, rules
    regex = Regexp.new("^" + expend_rule2(rules,"0") + "$")
    nb_matches(input, regex)
  end
end

if $0 == __FILE__ then
  raw_rules, input = File.open('../inputs/day19').read.split("\n\n").map { |x| x.split("\n") }
  rules = parse_rule(raw_rules)

  puts "Part 1: #{Day19.part1(input,rules)}"
  puts "Part 2: #{Day19.part2(input, rules)}"
end
