#! /usr/bin/env ruby

module Day16
  extend self

  def parse_rules raw
    rules = {}
    raw.split("\n").each do |l|
      m = l.match /\s*(.+): (\d+)-(\d+) or (\d+)-(\d+)/
      rules[m[1]] = ->x{
        (m[2].to_i <= x && x <= m[3].to_i) ||
        (m[4].to_i <= x && x <= m[5].to_i)
      }
    end
    rules
  end

  def part1 rules, tickets
    tickets.map do |ticket|
      ticket.select do |n|
        rules.values.all? { |r| !r.call(n) }
      end.sum
    end.sum
  end

  def assign_fields rules, you, tickets
    assignations = Hash.new []
    final_assignations = Hash.new 0

    valid_tickets_transposed = tickets.select do |ticket|
      ticket.all? do |n|
        rules.values.any? { |r| r.call(n) }
      end
    end.transpose

    valid_tickets_transposed.each.with_index do |row, idx|
      rules.each do |name, r|
        if row.all? { |n| r.call(n) } then
          assignations[name] += [idx]
        end
      end
    end

    while !assignations.empty? do
      fixed = assignations.select { |name, pos| pos.length == 1 }
      fixed.each do |name, val|
        final_assignations[name] = val[0]
        assignations.keys.each do |k|
          assignations[k] -= [val[0]]
        end
        assignations.delete(name)
      end
    end

    final_assignations.each {|n,v| final_assignations[n] = you[v]}
  end

  def part2 rules, you, tickets
    res = 1

    (assign_fields rules, you, tickets).each do |n,v|
      res *= v if n =~ /departure/
    end
    res
  end
end

if $0 == __FILE__ then
  input = File.open('../inputs/day16').read.to_s
  rules_raw, ticket_raw, nearby_raw = input.split "\n\n"
  rules = Day16.parse_rules rules_raw
  ticket = ticket_raw.split("\n")[1].split(',').map(&:to_i)
  tickets = nearby_raw.split("\n")[1..-1].map do |l| l.split(',').map(&:to_i) end

  puts "Part 1: #{Day16.part1(rules,tickets)}"
  puts "Part 2: #{Day16.part2(rules,ticket,tickets)}"
end
