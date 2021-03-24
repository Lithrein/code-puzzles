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
        first_part(input.to_vec())
    }

    fn solve_second(&self, input: &Self::Input) -> Self::Output2 {
        second_part(input.to_vec())
    }
}

fn first_part(expenses: Vec<isize>) -> isize {
    let mut res = 0;
    for i in &expenses {
        for j in &expenses {
            if i + j == 2020 {
                res = i * j;
            }
        }
    }
    res
}

fn second_part(expenses: Vec<isize>) -> isize {
    let mut res = 0;
    for i in &expenses {
        for j in &expenses {
            for k in &expenses {
                if i + j + k == 2020 {
                    res = i * j * k;
                }
            }
        }
    }
    res
}

#[cfg(test)]
mod tests {
    use crate::solutions::day01::*;

    #[test]
    fn test_first_part() {
        assert_eq!(first_part(vec![1721, 979, 366, 299, 675, 1456]), 514579);
    }

    #[test]
    fn test_second_part() {
        assert_eq!(second_part(vec![1721, 979, 366, 299, 675, 1456]), 241861950);
    }
}
