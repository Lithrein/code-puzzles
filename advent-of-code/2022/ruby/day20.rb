n = 1
key = 1
key = 811589153
n = 10

p input = File.open('../inputs/day20').readlines.map(&:to_i).map.with_index { |x, i| [x * key, i] }

def find_n j, arr
  arr.size.times do |i|
    if arr[i][1] == j then return i end
  end
  return -1
end

def find_i j, arr
  arr.size.times do |i|
    if arr[i][0] == j then return i end
  end
  return -1
end

sz = input.size
n.times do
  j = 0
  while j < sz do
    i = find_n(j, input)
    v = input[i]
    input.delete_at(i)
    idx = (i + v[0]) % (sz - 1)
    head = input[0..idx-1] || []
    tail = if idx != 0 then input[idx..-1] || [] else [] end
    input = head + [v] + tail
    j += 1
  end
end

# n.times do
#   j = 0
#   while j < sz do
#     i = input.find_index(input_[j])
#     v = input[i]
#     if v == 0 then
#       # nothing to do
#     else
#       input.delete_at(i)
#       idx = (i + v) % (sz - 1)
#       if idx == 0 then
#         input = input + [v]
#       elsif idx == sz then
#         input = [v] + input
#       else
#         head = input[0..idx-1] || []
#         tail = input[idx..-1] || []
#         input = head + [v] + tail
#       end
#     end
#     j += 1
#   end
# end

p input
p zero_pos = find_i(0, input)
p [1000, 2000, 3000].map { |x| input[(x + zero_pos) % (sz)][0] }.sum
