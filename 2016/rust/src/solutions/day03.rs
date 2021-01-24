use crate::solver::Solver;
use std::{
    io::{self, BufRead, BufReader},
};

pub struct Problem;

impl Solver for Problem {
    type Input = Vec<(isize, isize, isize)>;
    type Output1 = usize;
    type Output2 = usize;

    fn parse_input<R: io::Read>(&self, r: R) -> Self::Input {
        BufReader::new(r)
            .lines()
            .flatten()
            .map (|line| {
                let nbs: Vec<_> = line.trim().split_whitespace().map(|s| s.parse::<isize>().unwrap()).collect();
                (nbs[0], nbs[1], nbs[2])
            })
            .collect()
    }

    fn solve_first(&self, input: &Self::Input) -> Self::Output1 {
        input.iter().filter(|t| is_valid_triangle(t)).count()
    }

    fn solve_second(&self, input: &Self::Input) -> Self::Output2 {
        let mut new_input_tmp = vec![];
        for elem in input.iter() {
            new_input_tmp.push(elem.0)
        }
        for elem in input.iter() {
            new_input_tmp.push(elem.1)
        }
        for elem in input.iter() {
            new_input_tmp.push(elem.2)
        }
        let new_input: Vec<_> = new_input_tmp.chunks(3).map(|x| (x[0], x[1], x[2])).collect();
        new_input.iter().filter(|t| is_valid_triangle(t)).count()
    }
}


fn is_valid_triangle(side: &(isize, isize, isize)) -> bool {
    // no flat triangles...
    side.0 < side.1 + side.2 &&
    side.1 < side.0 + side.2 &&
    side.2 < side.0 + side.1
}

#[cfg(test)]
mod tests {
    use crate::solutions::day03::*;

    #[test]
    fn test_is_valid_triangle() {
        assert_eq!(is_valid_triangle(&&(5, 10, 25)), false);
        assert_eq!(is_valid_triangle(&&(5, 10, 15)), false);
        assert_eq!(is_valid_triangle(&&(3,  4,  5)), true);
    }
}
