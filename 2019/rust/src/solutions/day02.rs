use crate::solver::Solver;
use std::{
    fmt,
    io::{self, BufRead, BufReader},
};

pub struct Problem;

pub struct Pair<T>(T, T);

impl<T> fmt::Display for Pair<T> where T: fmt::Display {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "{} {}", self.0, self.1)
    }
}

impl Solver for Problem {
    type Input = Vec<usize>;
    type Output1 = usize;
    type Output2 = Pair<usize>;

    fn parse_input<R: io::Read>(&self, r: R) -> Self::Input {
        let r = BufReader::new(r);
        let v : Vec<String> = r.lines().flatten().collect();

        match v.iter().next() {
            Some(l) => l.split(",").map(|nb| nb.parse().unwrap()).collect(),
            None => vec![]
        }
    }

    fn solve_first(&self, input: &Self::Input) -> Self::Output1 {
        exec(input, 12, 2)
    }

    fn solve_second(&self, input: &Self::Input) -> Self::Output2 {
        find_noun_verb(input, 19690720)
    }
}

fn exec (_vec: &Vec<usize>, noun: usize, verb: usize) -> usize {
    let mut i = 0;
    let mut vec = _vec.clone();
    vec[1] = noun;
    vec[2] = verb;
    while i + 4 < vec.len() {
        let dest = vec[i + 3];
        let val1 = vec[vec[i + 1]];
        let val2 = vec[vec[i + 2]];
        match vec[i] {
            1 => vec[dest] = val1 + val2,
            2 => vec[dest] = val1 * val2,
            _ => {}
        }
        i += 4;
    }
    vec[0]
}

fn find_noun_verb (vec: &Vec<usize>, goal: usize) -> Pair<usize> {
    let mut noun = 0;
    let mut verb = 0;
    let mut stop = false;

    while noun < 100 && !stop {
        verb = 0;
        while verb < 100 && !stop {
            if exec(vec,noun,verb) == goal {
                stop = true
            }
            verb += 1;
        }
        noun += 1;
    }
    Pair(noun - 1, verb - 1)
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
