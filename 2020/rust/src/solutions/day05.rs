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
        r.lines()
         .flatten()
         .map(|line|
              line.chars().map(
                  |c| match c {
                      'F' => '0',
                      'B' => '1',
                      'R' => '1',
                      'L' => '0',
                       _  => c
                  }).collect::<String>())
         .map(|line| isize::from_str_radix(&line, 2).unwrap())
         .collect()
    }

    fn solve_first(&self, input: &Self::Input) -> Self::Output1 {
        *input.iter().max().unwrap()
    }

    fn solve_second(&self, input: &Self::Input) -> Self::Output2 {
        let mut copy = input.to_vec();
        copy.sort();
        copy.windows(2)
            .map( |x| if isize::abs(x[0] - x[1]) == 1 { 0 } else { (x[0] + x[1]) / 2 } )
            .sum()
    }
}


#[cfg(test)]
mod tests {
  use crate::solutions::day05::*;

  #[test]
  fn test_first_part() {
      assert_eq!(true, true);
  }

  #[test]
  fn test_second_part() {
      assert_eq!(true, true);
  }
}
