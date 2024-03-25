tree = Hash.new
parents = []
tree["/"] = {}
cwd = tree["/"]
File.open('../inputs/day07').readlines.each do |line|
  line = line.chomp
  if line[0] == "$" then
    if line[2..3] == "cd" then
      name = line[5..-1]
      if name == ".." then
        cwd = parents[0]
        parents = parents[1..-1] || []
      elsif name == "/"
        cwd = tree["/"]
      else
        parents = [cwd] + parents
        cwd[name] = {} if cwd[name].nil?
        cwd = cwd[name]
      end
    elsif line[2..3] == "ls" then
      # do nothing
    end
  else
    if line[0] == "d" then # directory
      name = line.match(/dir (.*)/).to_a[1]
      cwd[name] = {} if cwd[name].nil?
    else
      size, name = line.match(/(\d*) (.*)/).to_a[1..-1]
      size = size.to_i
      cwd[name] = size if cwd[name].nil?
    end
  end
end

$sizes = []
def compute_size(t)
  sum = 0
  t.keys.each do |k|
    if t[k].is_a? Integer then
      sum += t[k]
    else
      sum += compute_size(t[k])
    end
  end
  $sizes += [sum]
  return sum
end

compute_size(tree)
missing = 30000000 - (70000000 - $sizes.max)
puts "p1: #{$sizes.select { |x| x <= 100000 }.sum}"
puts "p2: #{$sizes.select { |x| x >= missing }.min}"
