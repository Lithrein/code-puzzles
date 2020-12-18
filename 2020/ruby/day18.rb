#! /usr/bin/env ruby

def eval_rpn expr
  nb_nb_in_stack = 0
  stack = []
  expr.each do |el|
    if el == '+' || el == '*' then
      stack = [el] + stack
    elsif el.is_a? Integer
      stack = [el] + stack
    else
      stack = eval_rpn(el) + stack
    end
    while stack.length > 2 do
      left = stack.shift
      right = stack.shift
      op = stack.shift
      if left.is_a?(Integer) && right.is_a?(Integer) && (op == '+' || op == '*') then
        stack = [eval("#{left} #{op} #{right}")] + stack
      else
        stack = [left,right,op] + stack
        break
      end
    end
  end
  stack
end

def postfix_to_prefix_without_precedence lst
  ops, nums = [], []

  lst.each do |el|
    if el == '+' || el == '*' then
      ops += [el]
    elsif el.is_a? Integer then
      nums += [el]
    else # el is a list
      nums += [postfix_to_prefix_without_precedence(el)]
    end
  end

  ops.reverse + nums
end

def postfix_to_prefix_with_precedence lst
  ops, nums = [], []

  lst.each do |el|
    if el == '+' then
      left = nums.pop
      nums += [el, left]
    elsif el == '*' then
      ops += [el]
    elsif el.is_a? Integer then
      nums += [el]
    else # el is a list
      nums += [postfix_to_prefix_with_precedence(el)]
    end
  end

  ops + nums
end

def rpn_input input
  input.map { |str| eval(('('+str+')').gsub('+', "'+'").gsub('*',"'*'").tr('() ', '[],')) }
end

def part1 input
  rpn_input(input)
    .map { |lst| postfix_to_prefix_without_precedence lst }
    .map { |expr| eval_rpn expr }
    .flatten
    .sum
end

def part2 input
  rpn_input(input)
    .map { |lst| postfix_to_prefix_with_precedence lst }
    .map { |expr| eval_rpn expr }
    .flatten
    .sum
end

input = File.open('../inputs/day18').readlines.map(&:chomp)
p part1 input
p part2 input
