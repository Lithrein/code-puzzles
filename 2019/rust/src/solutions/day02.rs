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
    type Output1 = isize;
    type Output2 = Pair<isize>;

    fn parse_input<R: io::Read>(&self, r: R) -> Self::Input {
        let r = BufReader::new(r);
        let v: Vec<String> = r.lines().flatten().collect();

        match v.iter().next() {
            Some(l) => l.split(",").map(|nb| nb.parse().unwrap()).collect(),
            None => vec![],
        }
    }

    fn solve_first(&self, input: &Self::Input) -> Self::Output1 {
        exec!(input, &vec![], &mut vec![], 12, 2)
    }

    fn solve_second(&self, input: &Self::Input) -> Self::Output2 {
        find_noun_verb(input, 19690720)
    }
}



// #[cfg(test)]
// mod tests {
//   use crate::solutions::day02::*;

//   #[test]
//   fn test_part1() {
//   }

//   #[test]
//   fn test_part2() {
//   }
// }
