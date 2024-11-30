lines = File.open('../inputs/15.txt').readlines.map(&:chomp)

line = lines.join
# line = 'rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7'
puts "p1: #{line.split(',').map { |s| s.split('').inject(0) { |acc,c| acc = (17*(c.ord + acc)) % 256 } }.sum}"

h = Hash.new
p line.split(',').map { |s| h[s.split(/[-=]/)[0]] = s.split(/[-=]/)[0].split('').inject(0) { |acc,c| acc = (17*(c.ord + acc)) % 256 } }

nh = []
line.split(',').each do |str|
  label, value = str.split(/[-=]/)
  box = label.split('').inject(0) { |acc,c| acc = (17*(c.ord + acc)) % 256 }
  if nh[box].nil? then nh[box] = {} end
    value = value.to_i
  if value == 0 && str[-1] == '-' then
    nh[box].delete(label)
  else
    nh[box][label] = value
  end
end

sum = 0
nh.each.with_index do |key,box_id|
  if !key.nil? && !key.empty?
    key.keys.each.with_index do |val, slot|
      sum += (box_id + 1) * (slot + 1) * key[val]
    end
  end
end
p sum
