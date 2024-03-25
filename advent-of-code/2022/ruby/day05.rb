input, moves = File.open('../inputs/day05').readlines.join.split("\n\n")
input = input.split("\n")[0..-2]

stacks = Array.new(9, [])
input.each do |l|
  (0..8).each do |i|
    stacks[i] += [ l[1 + i*4] ] if l[1 + i*4] != " "
  end
end
stacks.map(&:reverse)

# p1 needs reverse, p2 does not
moves = moves.split("\n").map { |l| l.scan(/\d+/).map(&:to_i) }
moves.each do |n,s,d|
  stacks[d-1] = stacks[s-1][0..n-1].reverse + stacks[d-1]
  stacks[s-1] = stacks[s-1][n..-1] || []
end

puts stacks.map { |x| x[0] }.join
