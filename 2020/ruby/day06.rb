#! /usr/bin/env ruby

input = File.open('../inputs/day06').read().split("\n\n")
puts input.map(&->x{x.gsub(/\n/,'')}).map(&->x{x.split('')}).map(&:uniq).map(&:length).sum()
puts input.map(&->x{x.split("\n").map(&->x{x.split('')})}).map(&->x{x.reduce(:&)}).map(&:length).sum()
