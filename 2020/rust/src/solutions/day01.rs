use crate::solver::Solver;
use std::{
    io::{self, BufRead, BufReader},
};

pub struct Problem;

impl Solver for Problem {
    type Input = Vec<isize>;
    type Output1 = isize;
    type Output2 = isize;

    fn parse_input<R: io::Read>(&self, r: R) -> Self::Input {
        let r = BufReader::new(r);
        r.lines().flatten().flat_map(|l| l.parse()).collect()
    }

    fn solve_first(&self, input: &Self::Input) -> Self::Output1 {
        input.iter().cloned().map(first_part).sum()
    }

    fn solve_second(&self, input: &Self::Input) -> Self::Output2 {
        input.iter().cloned().map(second_part).sum()
    }
}

fn first_part (mass:isize) -> isize {
    0
}

fn second_part (mass: isize) -> isize {
    0
}

#[cfg(test)]
mod tests {
  use crate::solutions::day01::*;

  #[test]
  fn test_first_part() {
    assert_eq!(first_part(12), 0);
  }

  #[test]
  fn test_second_part() {
    assert_eq!(second_part(14), 0);
  }
}
