use crate::solver::Solver;
use std::{
    io::{self, BufRead, BufReader},
};

pub struct Problem;

impl Solver for Problem {
    type Input = Vec<Vec<isize>>; // l, w, h
    type Output1 = isize;
    type Output2 = isize;

    fn parse_input<R: io::Read>(&self, r: R) -> Self::Input {
        let r = BufReader::new(r);
        r.lines()
         .flatten()
         .map(|line|
              line.split('x')
                  .map(|n| n.parse::<isize>().unwrap())
                  .collect())
         .collect()
    }

    fn solve_first(&self, input: &Self::Input) -> Self::Output1 {
        input.iter().map(wrap_surface).sum()
    }

    fn solve_second(&self, input: &Self::Input) -> Self::Output2 {
        input.iter().map(feets_to_order).sum()
    }
}


fn wrap_surface(lwh: &Vec<isize>) -> isize {
    let side1 = lwh[0] * lwh[1];
    let side2 = lwh[1] * lwh[2];
    let side3 = lwh[2] * lwh[0];
    2*side1+ 2*side2 + 2*side3 +
        vec![side1, side2, side3].iter().min().unwrap()
}

fn feets_to_order(lwh: &Vec<isize>) -> isize {
    2 * (lwh.iter().sum::<isize>() - lwh.iter().max().unwrap()) + lwh[0] * lwh[1] * lwh[2]
}


#[cfg(test)]
mod tests {
  use crate::solutions::day02::*;

  #[test]
  fn test_first_part() {
      assert_eq!(wrap_surface(vec![2,3,4].as_ref()), 58);
      assert_eq!(wrap_surface(vec![1,1,10].as_ref()), 43);
  }

  #[test]
  fn test_second_part() {
      assert_eq!(feets_to_order(vec![2,3,4].as_ref()), 34);
      assert_eq!(feets_to_order(vec![1,1,10].as_ref()), 14);
  }
}
