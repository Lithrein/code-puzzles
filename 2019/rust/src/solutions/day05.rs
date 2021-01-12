use crate::solver::Solver;
use crate::exec;
use crate::intcode::*;
use std::{
    fmt,
    io::{self, BufRead, BufReader},
};

pub struct Problem;

impl Solver for Problem {
    type Input = Vec<isize>;
    type Output1 = Vec<isize>;
    type Output2 = Vec<isize>;

    fn parse_input<R: io::Read>(&self, r: R) -> Self::Input {
        let r = BufReader::new(r);
        let v: Vec<String> = r.lines().flatten().collect();

        match v.iter().next() {
            Some(l) => l.split(",").map(|nb| nb.parse().unwrap()).collect(),
            None => vec![],
        }
    }

    fn solve_first(&self, input: &Self::Input) -> Self::Output1 {
        let mut output = vec![];
        exec!(input, &vec![1], &mut output);
        output
    }

    fn solve_second(&self, input: &Self::Input) -> Self::Output2 {
        let mut output = vec![];
        exec!(input, &vec![5], &mut output);
        output
    }
}



// #[cfg(test)]
// mod tests {
//   use crate::solutions::day05::*;

//   #[test]
//   fn test_part1() {
//   }

//   #[test]
//   fn test_part2() {
//   }
// }
