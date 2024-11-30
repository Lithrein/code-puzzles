lines = File.open('../inputs/20.txt').readlines.map(&:chomp)

configs = {}
lines.each do |line|
  _, prefix, name, dests = line.match(/([\%\&]?)(.*) -> (.*)/).to_a
  dests = dests.split(', ')
  configs[name] = {} if configs[name].nil?
  configs[name][:outputs] = dests
  configs[name][:typ] = prefix
  dests.each do |dest|
    configs[dest] = {} if configs[dest].nil?
    if configs[dest][:inputs].nil? then
      configs[dest][:inputs] = [name]
    else
      configs[dest][:inputs] << name
    end
  end
end

st = Hash.new
#p configs

lows = 0
highs = 0
clicks = 0
while 1 do
workqueue = [ "button" ]
while !workqueue.empty? do
  cur = workqueue[0]
  workqueue = workqueue[1..-1]

  if cur == "button" then
    clicks += 1
    workqueue << [ "low", "button", "broadcaster" ]
    lows += 1
  else
    signal, who, mod = cur

    if mod == "broadcaster" then
      configs[mod][:outputs].each do |o|
        workqueue << [ signal, mod, o ]
        if signal == "low" then
          lows += 1
        else
          highs += 1
        end
      end
    elsif mod == "output" || mod == "pv" || mod == "rx" then
      if signal == "low" then
        p "(end #{mod}) clicks: #{clicks}"
        abort
      end
      st[mod] = signal
    else
      if configs[mod][:typ] == "%" then
        # Ignore high pulses
        if signal == "low" then
          if st[mod].nil? || st[mod] == false then
            st[mod] = true
            configs[mod][:outputs].each do |o|
              workqueue << [ "high", mod, o ]
              highs += 1
            end
          else
            st[mod] = false
            configs[mod][:outputs].each do |o|
              workqueue << [ "low", mod, o ]
              lows += 1
            end
          end
        end
      elsif configs[mod][:typ] == "&" then
        st[mod] = Hash.new(false) if st[mod].nil?
        st[mod][who] = signal
        res = configs[mod][:inputs].all? { |k| st[mod][k] == "high" } ? "low" : "high"
        configs[mod][:outputs].each do |o|
          workqueue << [ res, mod, o ]
          if res == "high" then
            highs += 1
          else
            lows += 1
          end
        end
      else
        puts "unknown module type configs[#{mod}][:typ] #{configs[mod][:typ]}"
        abort
      end
    end
  end
#  p workqueue
end
end
p clicks
p lows
p highs
p lows * highs
