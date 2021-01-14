use crate::solver::Solver;
use lazy_static::lazy_static;
use regex::Regex;
use std::io::{self, BufRead, BufReader};

fn pf_to_flags(pf: &str) -> usize {
    match pf {
        "byr" => 0x1,
        "iyr" => 0x2,
        "eyr" => 0x4,
        "hgt" => 0x8,
        "hcl" => 0x10,
        "ecl" => 0x20,
        "pid" => 0x40,
        "cid" => 0x80,
        _ => 0,
    }
}

pub struct Problem;

impl Solver for Problem {
    type Input = Vec<String>;
    type Output1 = usize;
    type Output2 = usize;

    fn parse_input<R: io::Read>(&self, r: R) -> Self::Input {
        let r = BufReader::new(r);
        r.lines()
            .flatten()
            .fold(String::new(), |acc, l| acc + l.as_ref() + " ")
            .split("  ")
            .map(|s| s.to_string())
            .collect()
    }

    fn solve_first(&self, input: &Self::Input) -> Self::Output1 {
        input.into_iter().filter(|l| fst_policy(l)).count()
    }

    fn solve_second(&self, input: &Self::Input) -> Self::Output2 {
        input
            .into_iter()
            .filter(|l| fst_policy(l))
            .filter(|l| snd_policy(l))
            .count()
    }
}

fn fst_policy(passport_entry: &str) -> bool {
    lazy_static! {
        static ref RE: Regex = Regex::new(r" ?(?P<id>.[^: ]*):(?P<val>.[^ ]*)").unwrap();
    }
    RE.captures_iter(passport_entry)
        .fold(0, |acc, cap| acc | pf_to_flags(&cap["id"]))
        & 0x7F
        == 0x7F
}

fn snd_policy(passport_entry: &str) -> bool {
    lazy_static! {
        static ref RE: Regex = Regex::new(r" ?(?P<id>.[^: ]*):(?P<val>.[^ ]*)").unwrap();
        static ref BYR: Regex = Regex::new(r"^(19[2-8][0-9]|199[0-9]|200[0-2])$").unwrap();
        static ref IYR: Regex = Regex::new(r"^(201[0-9]|2020)$").unwrap();
        static ref EYR: Regex = Regex::new(r"^(202[0-9]|2030)$").unwrap();
        static ref HGT: Regex =
            Regex::new(r"^(1[5-8][0-9]|19[0-3])cm$|^(59|6[0-9]|7[0-6])in$").unwrap();
        static ref HCL: Regex = Regex::new(r"^#[0-9a-f]{6}$").unwrap();
        static ref ECL: Regex = Regex::new(r"^amb|blu|brn|gry|grn|hzl|oth$").unwrap();
        static ref PID: Regex = Regex::new(r"^[0-9]{9}$").unwrap();
    }
    RE.captures_iter(passport_entry).fold(true, |acc, cap| {
        acc && match &cap["id"] {
            "byr" => BYR.is_match(&cap["val"]),
            "iyr" => IYR.is_match(&cap["val"]),
            "eyr" => EYR.is_match(&cap["val"]),
            "hgt" => HGT.is_match(&cap["val"]),
            "hcl" => HCL.is_match(&cap["val"]),
            "ecl" => ECL.is_match(&cap["val"]),
            "pid" => PID.is_match(&cap["val"]),
            "cid" => true,
            _ => false,
        }
    })
}

#[cfg(test)]
mod tests {
    use crate::solutions::day04::*;

    #[test]
    fn test_first_part() {
        assert_eq!(
            fst_policy(
                "ecl:gry pid:860033326 eyr:2020 hcl:#fffffd byr:1937 iyr:2017 cid:147 hgt:183cm"
            ),
            true
        );
        assert_eq!(
            fst_policy("iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884 hcl:#cfa07d byr:1929"),
            false
        );
        assert_eq!(
            fst_policy("hcl:#ae17e1 iyr:2013 eyr:2024 ecl:brn pid:760753108 byr:1931 hgt:179cm"),
            true
        );
        assert_eq!(
            fst_policy("hcl:#cfa07d eyr:2025 pid:166559648 iyr:2011 ecl:brn hgt:59in"),
            false
        );
    }

    #[test]
    fn test_second_part() {
        assert_eq!(
            snd_policy("eyr:1972 cid:100 hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926"),
            false
        );
        assert_eq!(
            snd_policy("iyr:2019 hcl:#602927 eyr:1967 hgt:170cm ecl:grn pid:012533040 byr:1946"),
            false
        );
        assert_eq!(
            snd_policy(
                "hcl:dab227 iyr:2012 ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277"
            ),
            false
        );
        assert_eq!(
            snd_policy("hgt:59cm ecl:zzz eyr:2038 hcl:74454a iyr:2023 pid:3556412378 byr:2007"),
            false
        );
        assert_eq!(
            snd_policy("iyr:2018 cid:158 eyr:2020 byr:1929 pid:334374178 hgt:181cm hcl:z ecl:grn"),
            false
        );

        assert_eq!(
            snd_policy("pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1920 hcl:#623a2f"),
            true
        );
        assert_eq!(
            snd_policy("pid:087499704 hgt:59in ecl:grn iyr:2012 eyr:2030 byr:1980 hcl:#623a2f"),
            true
        );
        assert_eq!(
            snd_policy("pid:087499714 hgt:76in ecl:grn iyr:2012 eyr:2030 byr:1980 hcl:#623a2f"),
            true
        );
        assert_eq!(
            snd_policy(
                "eyr:2029 ecl:oth cid:129 byr:1989 iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm"
            ),
            true
        );
        assert_eq!(
            snd_policy(
                "hcl:#888785 hgt:164cm byr:2001 iyr:2015 cid:88 pid:545766238 ecl:hzl eyr:2022"
            ),
            true
        );
        assert_eq!(
            snd_policy("iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719"),
            true
        );
    }
}
