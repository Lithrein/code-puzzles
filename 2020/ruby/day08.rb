#! /usr/bin/env ruby

input = File.open('../inputs/day08').read

$prgm = []
input.each_line do |line|
  l = line.match(/(nop|acc|jmp) ([+|-])(\d+)/)
  sign = l[2] == "+" ? 1 : -1
  $prgm += [[l[1], sign * l[3].to_i]]
end

def exec
  acc, pc = 0, 0
  visited = Hash.new false
  while pc < $prgm.length && !visited[pc] do
    visited[pc] = true
    acc += $prgm[pc][1] if $prgm[pc][0] == "acc"
    pc  += $prgm[pc][0] == "jmp" ? $prgm[pc][1] : 1
  end
  [acc, pc]
end

part1, pc = exec
p part1

(0..$prgm.length - 1).each do |i|
  instr = $prgm[i][0]
  if instr == "nop" || instr == "jmp" then
    $prgm[i][0] = instr == "nop" ? "jmp" : "nop"

    part2, pc = exec
    if pc == $prgm.length then
      p part2
      break
    end

    $prgm[i][0] = instr
  end
end
