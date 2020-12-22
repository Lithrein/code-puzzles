#! /usr/bin/env ruby

require 'digest'
def md5sum array
  Digest::MD5.hexdigest(array.join("|"))
end

def part1 stack1, stack2
  stack1 = stack1.clone
  stack2 = stack2.clone
  while !stack1.empty? && !stack2.empty?
    top1 = stack1.shift
    top2 = stack2.shift
    if top1 > top2 then
      stack1 += [top1, top2]
    else
      stack2 += [top2, top1]
  end
  end
  end_deck = stack1 + stack2
  len = end_deck.length
  end_deck.map.with_index { |c,idx| c * (len - idx) }.sum
end

def part2 stack1, stack2, game = 1
  stack1 = stack1.clone
  stack2 = stack2.clone
  rec_exit = false
  configs = []
  round = 1
  # puts "starting game #{game}"
  while !rec_exit && !stack1.empty? && !stack2.empty?
    config = md5sum(stack1) + md5sum(stack2)
    if configs.include? config then
      # puts "configuration already seen !!!"
      # puts "deck p1: #{stack1.join ","}"
      # puts "deck p2: #{stack2.join ","}"
      rec_exit = true
    else
      configs += [config]
      top1 = stack1.shift
      top2 = stack2.shift
      s1len, s2len = stack1.length, stack2.length
      # puts "round #{round}"
      # puts "deck p1: #{stack1.join ","}"
      # puts "deck p2: #{stack2.join ","}"
      # puts "p1 plays #{top1}"
      # puts "p2 plays #{top2}"
      if top1 <= s1len && top2 <= s2len then
        # sub-game
        # puts "entering a sub-game"
          # if enough card for both recurse
          winner,_ = part2(stack1[0..top1-1],stack2[0..top2-1],game+1)
          # puts "subgame winner #{winner}"
          if winner == 1 then
            stack1 += [top1, top2]
          else
            stack2 += [top2, top1]
          end
        # puts "resuming game #{game}"
      else
        # classic rules
        if top1 > top2 then
          stack1 += [top1, top2]
        else
          stack2 += [top2, top1]
        end
      end
    end
    round += 1
  end
  end_deck = stack1 + stack2
  winner = rec_exit ? 1 : stack1.empty? ? 2 : 1
  len = end_deck.length
  [winner, end_deck.map.with_index { |c,idx| c * (len - idx) }.sum]
end

input = <<-DATA
Player 1:
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
10
DATA
# input = <<-DATA
# Player 1:
# 43
# 19

# Player 2:
# 2
# 29
# 14
# DATA
input = File.open('../inputs/day22').read

stack1, stack2 = input.split("\n\n").map(&->x{x.split("\n")[1..-1].map(&:to_i)})
p part1(stack1,stack2)
p part2(stack1,stack2)[1]
