#! /usr/bin/env ruby

$rules = {
  :byr => ->x{ (1920..2002) === x.to_i },
  :iyr => ->x{ (2010..2020) === x.to_i },
  :eyr => ->x{ (2020..2030) === x.to_i },
  :hgt => ->x{ x =~ /^1(?:[5-8][0-9]|9[0-3])cm$|^(?:59|6[0-9]|7[0-6])in$/ },
  :hcl => ->x{ x =~ /^#[0-9a-f]{6}$/ },
  :ecl => ->x{ x =~ /^amb|blu|brn|gry|grn|hzl|oth$/ },
  :pid => ->x{ x =~ /^[0-9]{9}$/ },
  :cid => ->x{ true }
}

def process_input raw_input
  raw_input
    .split("\n\n")
    .map(&->x{x.tr("\n", " ").strip})
    .map do |passport|
      passport.match                  \
       /(?=.*byr:(?<byr>[#0-9a-z]+))?
        (?=.*iyr:(?<iyr>[#0-9a-z]+))?
        (?=.*eyr:(?<eyr>[#0-9a-z]+))?
        (?=.*hgt:(?<hgt>[#0-9a-z]+))?
        (?=.*hcl:(?<hcl>[#0-9a-z]+))?
        (?=.*ecl:(?<ecl>[#0-9a-z]+))?
        (?=.*pid:(?<pid>[#0-9a-z]+))?
        (?=.*cid:(?<cid>[#0-9a-z]+))?/x
    end
end


def part1 passports
  fields = $rules.keys - [:cid]
  passports
    .select { |passport| fields.all? { |flag| passport[flag] != nil } }
    .length
end

def part2 passports
  fields = $rules.keys - [:cid]
  passports
    .select { |passport| fields.all? { |flag| passport[flag] != nil } }
    .select { |passport| $rules.all? { |flag,r| r.call(passport[flag]) } }
    .length
end

passports = process_input File.open('../inputs/day04').read
puts part1(passports)
puts part2(passports)
