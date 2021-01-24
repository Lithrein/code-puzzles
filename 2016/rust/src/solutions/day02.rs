use crate::solver::Solver;
use std::{
    cmp,
    io::{self, BufRead, BufReader},
};

pub struct Problem;

impl Solver for Problem {
    type Input = Vec<String>;
    type Output1 = isize;
    type Output2 = String;

    fn parse_input<R: io::Read>(&self, r: R) -> Self::Input {
        BufReader::new(r).lines().flatten().collect()
    }

    fn solve_first(&self, input: &Self::Input) -> Self::Output1 {
        part1(&input)
    }

    fn solve_second(&self, input: &Self::Input) -> Self::Output2 {
        part2(&input)
    }
}


fn part1(instructions: &[String]) -> isize {
    let numpad = vec![
        vec![1, 2, 3],
        vec![4, 5, 6],
        vec![7, 8, 9],
    ];

    let mut code = 0;
    let mut pos = (1,1); // numpad 5

    for s in instructions.iter() {
        for c in s.chars() {
            match c {
              'L' => pos.1 = cmp::max(pos.1 - 1, 0),
              'R' => pos.1 = cmp::min(pos.1 + 1, 2),
              'U' => pos.0 = cmp::max(pos.0 - 1, 0),
              'D' => pos.0 = cmp::min(pos.0 + 1, 2),
               _  => panic!()
            }
        }
        code = code * 10 + numpad[pos.0 as usize][pos.1 as usize]
    }
    code
}

fn part2(instructions: &[String]) -> String {
    let numpad = vec![
        vec!['.', '.', '1', '.', '.'],
        vec!['.', '2', '3', '4', '.'],
        vec!['5', '6', '7', '8', '9'],
        vec!['.', 'A', 'B', 'C', '.'],
        vec!['.', '.', 'D', '.', '.'],
    ];

    let mut code = vec![];
    let mut pos = (2,0); // numpad 5

    for s in instructions.iter() {
        for c in s.chars() {
            match c {
              'L' => pos.1 = if pos.1 > 0 && numpad[pos.0 as usize][(pos.1 - 1) as usize] != '.' { pos.1 - 1 } else { pos.1 },
              'R' => pos.1 = if pos.1 < 4 && numpad[pos.0 as usize][(pos.1 + 1) as usize] != '.' { pos.1 + 1 } else { pos.1 },
              'U' => pos.0 = if pos.0 > 0 && numpad[(pos.0 - 1) as usize][pos.1 as usize] != '.' { pos.0 - 1 } else { pos.0 },
              'D' => pos.0 = if pos.0 < 4 && numpad[(pos.0 + 1) as usize][pos.1 as usize] != '.' { pos.0 + 1 } else { pos.0 },
               _  => panic!()
            }
        }
        code.push(numpad[pos.0 as usize][pos.1 as usize])
    }
    code.iter().collect()
}

#[cfg(test)]
mod tests {
    use crate::solutions::day02::*;

    #[test]
    fn test_first_part() {
       assert_eq!(part1(&vec!["ULL".to_string(),"RRDDD".to_string(),"LURDL".to_string(),"UUUUD".to_string()]), 1985);
    }

    #[test]
    fn test_second_part() {
       assert_eq!(part2(&vec!["ULL".to_string(),"RRDDD".to_string(),"LURDL".to_string(),"UUUUD".to_string()]), "5DB3".to_string());
    }
}
