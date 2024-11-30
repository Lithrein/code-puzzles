lines = File.open('../inputs/12.txt').readlines

def is_valid(line, groups)
  qms = line.split('').select { |a| a == '?' }.size
  sharps = line.split('').select { |a| a == '#' }.size
  fst, _ = line.split('?')
  fst = fst.split('.').select { |a| a != "" }
  fst = fst.map { |a| a.size }
  fst_size = fst.size
  groups_size = groups.size
  ok = true

  ok = false if qms + sharps < groups.sum || sharps > groups.sum
  i = 0
  while ok && i < fst_size && i < groups_size
    ok = ok && (fst[i] == groups[i] || (i == (fst_size - 1) && fst[i] <= groups[i]))
    i += 1
  end
#  p "ret: #{ok} #{line}"
  return ok
end

$memo = Hash.new

def process(line_, qm, groups, lline = "")
  sum = 0
  line = line_.clone
  line_size = line.size
  if qm.empty? then
#    puts "#{lline} is valid"
    return 1
  else
    fst_qm = qm[0]
    rst_qm = qm[1..-1]

    ['#', '.'].each do |c|
      bad = false
      line[fst_qm] = c
      if is_valid(line, groups) then
        i = group_idx = cnt = group_start = 0
        # Skip '.'
        while i < line.size && line[i] == '.' do i += 1 end
        group_start = i
        while i < line.size && line[i] != '?' do
          if line[i] == '.' then
            # Skip '.'
            while i < line.size && line[i] == '.' do i += 1 end
            if cnt != groups[group_idx] then
              bad = true
            end
            group_start = i
            cnt = 0
            group_idx += 1
          end
          cnt += 1 if line[i] == '#'
          i += 1 unless line[i] == '?'
        end
        next if bad
#        puts "i: #{i}"
#        puts "lline: #{lline}"
#        puts "line: #{line}"
#        puts "group_start: #{group_start}"
#        puts "group_idx: #{group_idx}"
#        puts "qm: #{rst_qm}"

        l = line[group_start..-1]
        q = rst_qm.map { |qm| qm - group_start }
        g = groups[group_idx..-1]
        if $memo["#{l}-#{q}-#{g}"].nil? then
          # tmp = process(l, q, g, "") #lline + (if group_start > 0 then line[0..group_start-1] else "" end))
          $memo["#{l}-#{q}-#{g}"] = process(l,q,g,"")
        end
        sum += $memo["#{l}-#{q}-#{g}"] 
      else
#        puts "#{lline} is invalid"
      end
    end
  end
  return sum
end

def process_line line
  pattern, groups = line.split(' ')
  groups = groups.split(',').map(&:to_i)
  qm = pattern.split('').map.with_index { |a,i| [a, i] }
    .select { |a,i| a == '?' }
    .map { |a,i| i }

 process(pattern, qm, groups)
end

sum = 0
i = 0
lines.each do |line|
  pat, groups = line.chomp.split(' ')
  pat = ([pat] * 5).join('?')
  groups = (groups.split(',') * 5).join(',')
  line = "#{pat} #{groups}"
  sum += process_line(line)
  p i = i + 1
end
p sum
# p lines.map { |line| process_line(line) }.sum

