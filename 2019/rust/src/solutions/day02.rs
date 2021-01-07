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
        let mut res = vec![];
        if let Some(l) = v.iter().next() {
            res = l.split(",").map(|nb| nb.parse().unwrap()).collect();
        }
        res
    }

    fn solve_first(&self, input: &Self::Input) -> Self::Output1 {
        part1(input)
    }

    fn solve_second(&self, input: &Self::Input) -> Self::Output2 {
        part2(input)
    }
}

fn part1 (_vec: &Vec<usize>) -> usize {
    let mut i : usize = 0;
    let mut vec = _vec.clone();
    vec[1] = 12;
    vec[2] = 2;
    while i + 4 < vec.len() {
        let addr1 = vec[i + 1];
        let addr2 = vec[i + 2];
        let dest = vec[i + 3];
        let val1 = vec[addr1];
        let val2 = vec[addr2];
        match vec[i] {
            1 => vec[dest] = val1 + val2,
            2 => vec[dest] = val1 * val2,
            _ => {}
        }
        i += 4;
    }
    vec[0]
}

fn part2 (_vec: &Vec<usize>) -> Pair<usize> {
    let mut noun : usize = 0;
    let mut verb : usize = 0;
    let mut stop = false;
    for n in 0..=99 {
        for v in 0..=99 {
            noun = n;
            verb = v;
            let mut i : usize = 0;
            let mut vec = _vec.clone();
            vec[1] = n;
            vec[2] = v;
            while i + 4 < vec.len() {
                let addr1 = vec[i + 1];
                let addr2 = vec[i + 2];
                let dest = vec[i + 3];
                let val1 = vec[addr1];
                let val2 = vec[addr2];
                match vec[i] {
                    1 => vec[dest] = val1 + val2,
                    2 => vec[dest] = val1 * val2,
                    _ => {}
                }
                i += 4;
            }
            if vec[0] == 19690720 { stop = true }
            if stop { break }
        }
        if stop { break }
    }
    Pair{ 0:noun, 1:verb }
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
