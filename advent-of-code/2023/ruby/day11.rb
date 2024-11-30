lines = File.open('/tmp/11.txt').readlines                                                                                                                                                                                                                                                                                                                                                                                                                                              $h = lines.size                                                                                                                                                                                                                             $w = lines[0].size                                                                                                                                                                                                                                                                                                                                                                                                                                                                      expanded_rows = []                                                                                                                                                                                                                          expanded_cols = []                                                                                                                                                                                                                          galaxies = []                                                                                                                                                                                                                               i = 0
lines.each do |line|
  new_galaxies = line.split('').map.with_index { |s,i| [s, i] }.select { |(s,i)| s == '#' }.map { |(s, j)| [i, j] }
  empty_cols = line.split('').map.with_index { |s,i| [s, i] }.select { |(s,i)| s == '.' }.map { |(s, i)| i }
  if new_galaxies.size == 0 then
    expanded_rows << i
  else
    galaxies << new_galaxies
  end
  if i == 0 then
    expanded_cols = empty_cols
  else
    expanded_cols = expanded_cols & empty_cols
  end
  i += 1
end
#p expanded_rows
#p expanded_cols
galaxies = galaxies.flatten(1)
nb_galaxies = galaxies.size

factor = 999999
expanded_rows.sort.reverse.each do |r|
  (0..nb_galaxies-1).each do |i|
    if galaxies[i][0] > r then
      galaxies[i][0] += factor
    end
  end
end

expanded_cols.sort.reverse.each do |c|
  (0..nb_galaxies-1).each do |i|
    if galaxies[i][1] > c then
      galaxies[i][1] += factor
    end
  end
end

sum = 0
(0..nb_galaxies-1).each do |i|
  (0..i).each do |j|
    sum += (galaxies[i][0] - galaxies[j][0]).abs + (galaxies[i][1] - galaxies[j][1]).abs
  end
end
p sum
