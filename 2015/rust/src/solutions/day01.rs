use crate::solver::Solver;
use std::{
    io::{self, BufRead, BufReader},
};

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


fn part1(input: String) -> isize {
    input.chars()
        .map(
            |c| match c {
                '(' =>  1,
                ')' => -1,
                _  => 0
            }).sum()
}

fn part2(input: String) -> isize {
    let mut floor = 0;
    let mut step  = 0;
    let moves = input.chars()
        .map(
            |c| match c {
                '(' =>  1,
                ')' => -1,
                _  => 0
            });
    for i in moves {
        floor += i;
        step  += 1;
        if floor == -1 { break }
    }
    step
}


#[cfg(test)]
mod tests {
  use crate::solutions::day01::*;

  #[test]
  fn test_first_part() {
      assert_eq!(part1("(())".to_string())    , 0);
      assert_eq!(part1("()()".to_string())    , 0);
      assert_eq!(part1("(((".to_string())     , 3);
      assert_eq!(part1("(()(()(".to_string()) , 3);
      assert_eq!(part1("))(((((".to_string()) , 3);
      assert_eq!(part1("())".to_string())     , -1);
      assert_eq!(part1("))(".to_string())     , -1);
      assert_eq!(part1(")))".to_string())     , -3);
      assert_eq!(part1(")())())".to_string()) , -3);
  }

  #[test]
  fn test_second_part() {
      assert_eq!(part2(")".to_string())     , 1);
      assert_eq!(part2("()())".to_string()) , 5);
  }
}
