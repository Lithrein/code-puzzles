input = File.open('../inputs/day20').readlines.map(&:to_i).map { |x| [x, :to_do] }

stop = false
sz = input.size
while !stop do
  i = 0
  while i < sz && input[i][1] != :to_do do
    i += 1
  end
  break if i == sz
  v = input[i][0]
  input.delete_at(i)
  idx = (i + v) % (sz - 1)
  head = input[0..idx-1] || []
  tail = if idx != 0 then input[idx..-1] || [] else [] end
  input = head + [[v, :done]] + tail
end

zero_pos = input.find_index([0, :done])
p [1000, 2000, 3000].map { |x| input[ (x + zero_pos) % (sz)][0] }.sum
