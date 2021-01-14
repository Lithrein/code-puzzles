use crate::solver::Solver;
use std::io::{self, BufRead, BufReader};

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
        input.iter().cloned().map(fuel1).sum()
    }

    fn solve_second(&self, input: &Self::Input) -> Self::Output2 {
        input.iter().cloned().map(fuel2).sum()
    }
}

fn fuel1(mass: isize) -> isize {
    mass / 3 - 2
}

fn fuel2(mass: isize) -> isize {
    let tmp: isize = fuel1(mass);
    if tmp > 0 {
        fuel2(tmp) + tmp
    } else {
        0
    }
}

#[cfg(test)]
mod tests {
    use crate::solutions::day01::*;

    #[test]
    fn test_fuel1() {
        assert_eq!(fuel1(12), 2);
        assert_eq!(fuel1(14), 2);
        assert_eq!(fuel1(1969), 654);
        assert_eq!(fuel1(100756), 33583);
    }

    #[test]
    fn test_fuel2() {
        assert_eq!(fuel2(14), 2);
        assert_eq!(fuel2(1969), 966);
        assert_eq!(fuel2(100756), 50346);
    }
}
