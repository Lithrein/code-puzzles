use crate::solver::Solver;
use md5;
use std::{
    fmt::format,
    io::{self, BufRead, BufReader},
};

pub struct Problem;

impl Solver for Problem {
    type Input = String;
    type Output1 = String;
    type Output2 = String;

    fn parse_input<R: io::Read>(&self, r: R) -> Self::Input {
        let r = BufReader::new(r);
        r.lines().flatten().collect()
    }

    fn solve_first(&self, input: &Self::Input) -> Self::Output1 {
        part1(input.to_string())
    }

    fn solve_second(&self, input: &Self::Input) -> Self::Output2 {
        part2(input.to_string())
    }
}

fn part1(base: String) -> String {
    let mut i = 1;
    let mut count = 0;
    let mut res = vec![' '; 8];
    loop {
        if count == 8 { break }
        let hash = format!("{:x}", md5::compute(format(format_args!("{}{}", base, i))));
        if hash.starts_with("00000") {
            res[count] = hash.chars().nth(5).unwrap();
            count += 1
        }
        i += 1
    }
    res.iter().collect::<String>()
}

fn part2(base: String) -> String {
    let mut i = 1;
    let mut count = 0;
    let mut res = vec![' '; 8];
    loop {
        if count == 8 { break }
        let hash = format!("{:x}", md5::compute(format(format_args!("{}{}", base, i))));
        if hash.starts_with("00000") {
            match hash.chars().nth(5).unwrap().to_digit(8) {
                Some(d) => {
                    if res[d as usize] == ' ' {
                        res[d as usize] = hash.chars().nth(6).unwrap();
                        count += 1
                    }
                }
                None => {}
            }
        }
        i += 1
    }
    res.iter().collect::<String>()
}

#[cfg(test)]
mod tests {
    use crate::solutions::day04::*;

    #[test]
    fn test_first_part() {}

    #[test]
    fn test_second_part() {}
}
