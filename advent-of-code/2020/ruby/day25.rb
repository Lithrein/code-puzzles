#! /usr/bin/env ruby

module Day25
  extend self

def get_loop_size public_key
  subject_number = 7
  divisor = 20201227
  loop_number = 0

  res = 1
  loop {
    res *= subject_number
    res %= divisor
    loop_number += 1
    break if res == public_key
  }
  loop_number
end

def compute_private_key public_key, loop_size
  subject_number = public_key
  divisor = 20201227
  loop_number = 0

  res = 1
  loop {
    res *= subject_number
    res %= divisor
    loop_number += 1
    break if loop_number == loop_size
  }
  res
end

def part1 input
  public_key_card, public_key_door = input
  loop_size_card = get_loop_size(public_key_card)
  loop_size_door = get_loop_size(public_key_door)
  encryption_key_card = compute_private_key(public_key_door, loop_size_card)
  encryption_key_door = compute_private_key(public_key_card, loop_size_door)
  if encryption_key_card == encryption_key_door then
    return encryption_key_door
  else
    raise "error: can't compute encryption key"
  end
end
end

if $0 == __FILE__ then
  input = File.open('../inputs/day25').readlines.map(&:to_i)
  puts "Part 1: #{Day25.part1(input)}"
  puts "Part 2: nothing."
end
