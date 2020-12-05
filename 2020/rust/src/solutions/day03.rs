use crate::solver::Solver;
use std::{
    io::{self, BufRead, BufReader},
};

pub struct Problem;

impl Solver for Problem {
    type Input = Vec<Vec<char>>;
    type Output1 = usize;
    type Output2 = usize;

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

fn cnt_tree(map: &Vec<Vec<char>>, dx: usize, dy: usize) -> usize {
    let (height, width) = (map.len(), map[0].len());
    let mut pos = (0,0);
    let mut cnt = 0;
    while pos.0 < height {
        cnt += (map[pos.0][pos.1] == '#') as usize;
        pos = (pos.0 + dy, (pos.1 + dx) % width);
    }
    cnt
    // map.iter().step_by(dy).enumerate()
    //    .filter(|(y, line)| line.iter().cycle().nth(dx*y) == Some('#').as_ref()).count()
}

fn first_part (map: Vec<Vec<char>>) -> usize {
    cnt_tree(map.as_ref(), 3, 1)
}

fn second_part (map: Vec<Vec<char>>) -> usize {
    let slopes = vec![ (1, 1), (3, 1), (5, 1), (7, 1), (1, 2) ];
    slopes.iter().map(|&(dx,dy)| cnt_tree(&map, dx, dy)).product()
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
