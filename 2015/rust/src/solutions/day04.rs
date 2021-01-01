use crate::solver::Solver;
use std::{
    io::{self, BufRead, BufReader},
    fmt::format,
};
use md5::compute;

pub struct Problem;

impl Solver for Problem {
    type Input = String;
    type Output1 = isize;
    type Output2 = isize;

    fn parse_input<R: io::Read>(&self, r: R) -> Self::Input {
        let r = BufReader::new(r);
        r.lines()
         .flatten()
         .collect()
    }

    fn solve_first(&self, input: &Self::Input) -> Self::Output1 {
        part1(input.to_string())
    }

    fn solve_second(&self, input: &Self::Input) -> Self::Output2 {
        part2(input.to_string())
    }
}


fn part1(base: String)-> isize {
    let mut i = 1;
    while !format!("{:x}", md5::compute(format(format_args!("{}{}", base, i)))).starts_with("00000") {
        i += 1;
    }
    i
}

fn part2(base: String)-> isize {
    let mut i = 1;
    while !format!("{:x}", md5::compute(format(format_args!("{}{}", base, i)))).starts_with("000000") {
        i += 1;
    }
    i
}

#[cfg(test)]
mod tests {
  use crate::solutions::day04::*;

  #[test]
  fn test_first_part() {
  }

  #[test]
  fn test_second_part() {
  }
}
