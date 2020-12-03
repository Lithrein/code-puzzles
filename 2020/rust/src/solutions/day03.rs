use crate::solver::Solver;
use std::{
    io::{self, BufRead, BufReader},
};

pub struct Problem;

impl Solver for Problem {
    type Input = Vec<Vec<char>>;
    type Output1 = isize;
    type Output2 = isize;

    fn parse_input<R: io::Read>(&self, r: R) -> Self::Input {
        let r = BufReader::new(r);
        r.lines().flatten().map(|l| l.chars().collect()).collect()
    }

    fn solve_first(&self, input: &Self::Input) -> Self::Output1 {
        first_part(input.to_vec())
    }

    fn solve_second(&self, input: &Self::Input) -> Self::Output2 {
        second_part(input.to_vec())
    }
}

fn cnt_tree(map: &Vec<Vec<char>>, x: usize, y: usize) -> isize {
    let (height, width) = (map.len(), map[0].len());
    let mut pos = (0,0);
    let mut cnt = 0;
    while pos.0 < height {
        cnt += (map[pos.0][pos.1] == '#') as isize;
        pos = (pos.0 + y, (pos.1 + x) % width);
    }
    cnt
}

fn first_part (map: Vec<Vec<char>>) -> isize {
    cnt_tree(map.as_ref(), 3, 1)
}

fn second_part (map: Vec<Vec<char>>) -> isize {
    let slopes = vec![ (1, 1), (3, 1), (5, 1), (7, 1), (1, 2) ];
    slopes.into_iter().fold(1, |acc, s| acc * cnt_tree(map.as_ref(), s.0, s.1))
}

#[cfg(test)]
mod tests {
  use crate::solutions::day03::*;

  #[test]
  fn test_first_part() {
    assert_eq!(first_part(
            vec![
            vec!['.','.','#','#','.','.','.','.','.','.','.'],
            vec!['#','.','.','.','#','.','.','.','#','.','.'],
            vec!['.','#','.','.','.','.','#','.','.','#','.'],
            vec!['.','.','#','.','#','.','.','.','#','.','#'],
            vec!['.','#','.','.','.','#','#','.','.','#','.'],
            vec!['.','.','#','.','#','#','.','.','.','.','.'],
            vec!['.','#','.','#','.','#','.','.','.','.','#'],
            vec!['.','#','.','.','.','.','.','.','.','.','#'],
            vec!['#','.','#','#','.','.','.','#','.','.','.'],
            vec!['#','.','.','.','#','#','.','.','.','.','#'],
            vec!['.','#','.','.','#','.','.','.','#','.','#']
    ]), 7);
  }

  #[test]
  fn test_second_part() {
    assert_eq!(second_part(
            vec![
            vec!['.','.','#','#','.','.','.','.','.','.','.'],
            vec!['#','.','.','.','#','.','.','.','#','.','.'],
            vec!['.','#','.','.','.','.','#','.','.','#','.'],
            vec!['.','.','#','.','#','.','.','.','#','.','#'],
            vec!['.','#','.','.','.','#','#','.','.','#','.'],
            vec!['.','.','#','.','#','#','.','.','.','.','.'],
            vec!['.','#','.','#','.','#','.','.','.','.','#'],
            vec!['.','#','.','.','.','.','.','.','.','.','#'],
            vec!['#','.','#','#','.','.','.','#','.','.','.'],
            vec!['#','.','.','.','#','#','.','.','.','.','#'],
            vec!['.','#','.','.','#','.','.','.','#','.','#']
    ]), 336);
  }
}
