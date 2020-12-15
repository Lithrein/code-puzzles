#! /usr/bin/env ruby

def part1 input
  msk, msk_val, mem = 0, 0, Hash.new(0)
  input.each do |l|
    if l =~ /mask/ then
      match = l.match(/mask = (.+)/)[1]
      msk = match.tr("X01","01").to_i 2
      msk_val = match.tr("X","0").to_i 2
    else
      match = l.match(/mem\[(\d+)\] = (\d+)/)
      loc, val = match[1].to_i, match[2].to_i
      mem[loc] = ((~0x2000000000 & ~msk & val) | msk_val)
    end
  end
  mem.values.sum
end

def part2 input
  msk, msk_val, mem = 0, 0, Hash.new(0)
  input.each do |l|
    if l =~ /mask/ then
      match = l.match(/mask = (.+)/)[1]
      msk = match.tr("X01","01").to_i 2
      msk_val = match.tr("X","0").to_i 2
    else
      match = l.match(/mem\[(\d+)\] = (\d+)/)
      base_loc, val = (match[1].to_i | msk_val) & msk, match[2].to_i
      tmp_msk, last_msk, locs, bp = ~msk, 0, [0], 0
      loop do
        bp = tmp_msk & -tmp_msk
        break if ("%b" % bp).length > 36
        locs = locs + locs.map(&->x{x + bp})
        tmp_msk = ~0x2000000000 & tmp_msk & ~bp
      end
      locs.each do |loc|
        mem[base_loc | loc] = val
      end
    end
  end
  mem.values.sum
end

input = File.open('../inputs/day14').readlines
# input = <<-DATA
# mask = 000000000000000000000000000000X1001X
# mem[42] = 100
# mask = 00000000000000000000000000000000X0XX
# mem[26] = 1
# DATA
# input = input.split("\n")
p part1(input)
p part2(input)
