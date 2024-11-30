lines = File.open('../inputs/5.txt').readlines

i = 0
seeds = lines[i].chomp.split(': ')[1].split(' ').map(&:to_i)

hash = Hash.new []
elements = ['seed', 'soil', 'fertilizer', 'water', 'light', 'temperature', 'humidity', 'location']

i = 2 # Skip blank line
elements.each_cons(2) do |from,to|
  i += 1 # Skip "seed-to-soil map:"
  while (not (lines[i] =~ /map/)) && !lines[i].nil?
    if hash["#{from}-#{to}"].empty? then
      hash["#{from}-#{to}"] = [lines[i].split(' ').map(&:to_i)]
    else
      lst = lines[i].split(' ').map(&:to_i)
      hash["#{from}-#{to}"] << lst if !lst.empty?
    end
    i += 1
  end
end

# sort the hash
hash.keys.each do |k,_| hash[k] = hash[k].sort end

# part1
locations = []
seeds.each do |s|
  cur = s
  elements.each_cons(2) do |from,to|
    hash["#{from}-#{to}"].each do |(dst, src, range)|
      if range.nil? then
        range = src
        src = dst
      end

      if src <= cur && cur < src + range then
        cur = dst + (cur - src)
        break
      end
    end
  end
  locations << cur
end
p locations.min

# part2
locations = []
seeds.each_slice(2) do |s, s_range|
  cur = [[s, s + s_range - 1]]
  nxt = []
  curr = []

  elements.each_cons(2) do |from,to|
#    p "#{from}-#{to}"
#    p cur
    hash["#{from}-#{to}"].each do |(dst, src, range)|
      if range.nil? then
        range = src
        src = dst
      end

      curr = []
#      puts "cur: #{cur}"
#      puts "nxt: #{nxt}"
      cur.each do |(h_s, h_e)|
#        puts "src: #{src} src+range: #{src + range} dst: #{dst}"
#        puts "[#{h_s},#{h_e}]"

        # h_s -- [src -- h_e] -- src + range
        if h_s < src && src <= h_e && h_e < src + range  then
#          puts "1"
          nxt << [dst, (h_e - src) + dst]
          curr << [h_s, src - 1 ]
          # src -- [h_s -- src + range[ -- h_e
        elsif src < h_s && h_s < src + range && src + range < h_e then
#          puts "2"
          nxt << [(h_s - src) + dst, [0, dst + range - 1].max ]
          curr << [src + range, h_e]
          # src -- [h_s -- h_e] -- src + range
        elsif src <= h_s && h_e < src + range then
#          puts "3"
          nxt << [h_s - src + dst, h_e - src + dst]
        else
#          puts "4"
          curr << [h_s, h_e]
        end
#        p nxt
      end
      cur = curr
    end
    cur = nxt + curr
    curr = []
    nxt = []
  end
  locations << cur
end
p locations.flatten.min
