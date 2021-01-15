use crate::solver::Solver;
use std::{
    collections::HashSet,
    io::{self, BufRead, BufReader},
};

pub struct Problem;

impl Solver for Problem {
    type Input = Vec<(char, isize)>;
    type Output1 = isize;
    type Output2 = isize;

    fn parse_input<R: io::Read>(&self, r: R) -> Self::Input {
        let line = BufReader::new(r).lines().flatten().next().unwrap();

        line.split(", ")
            .map(|s| {
                let mut iter = s.chars();
                let dir = iter.next().unwrap();
                let nb = iter.collect::<String>().parse::<isize>().unwrap();
                (dir, nb)
            })
            .collect()
    }

    fn solve_first(&self, input: &Self::Input) -> Self::Output1 {
        part1(&input)
    }

    fn solve_second(&self, input: &Self::Input) -> Self::Output2 {
        part2(&input)
    }
}

fn dir_to_dir(dir: isize) -> char {
    let reduced_dir = dir % 360;
    match reduced_dir {
        000 => 'N',
        090 => 'E',
        180 => 'S',
        270 => 'W',
        _ => panic!(),
    }
}

fn dir_to_offset(dir: char) -> isize {
    match dir {
        'R' => 90,
        'L' => -90,
        _ => panic!(),
    }
}

fn part1(instructions: &Vec<(char, isize)>) -> isize {
    let mut pos = (0, 0);
    let mut dir = 0;

    for instruction in instructions.iter() {
        dir = dir + dir_to_offset(instruction.0);
        match dir_to_dir(dir) {
            'N' => pos.1 += instruction.1,
            'E' => pos.0 += instruction.1,
            'S' => pos.1 -= instruction.1,
            'W' => pos.0 -= instruction.1,
            _ => panic!(),
        }
    }

    isize::abs(pos.0) + isize::abs(pos.1)
}

fn part2(instructions: &Vec<(char, isize)>) -> isize {
    let mut visited = HashSet::new();
    let mut pos = (0, 0);
    let mut dir = 0;
    let mut stop = false;

    visited.insert(pos);
    for instruction in instructions.iter() {
        if stop {
            break;
        }
        dir = dir + dir_to_offset(instruction.0);
        let char_dir = dir_to_dir(dir);
        for _ in 0..instruction.1 {
            if stop {
                break;
            }
            match char_dir {
                'N' => pos.1 += 1,
                'E' => pos.0 += 1,
                'S' => pos.1 -= 1,
                'W' => pos.0 -= 1,
                _ => panic!(),
            }
            if visited.contains(&pos) {
                stop = true
            } else {
                visited.insert(pos);
            }
        }
    }

    isize::abs(pos.0) + isize::abs(pos.1)
}

#[cfg(test)]
mod tests {
    use crate::solutions::day01::*;

    #[test]
    fn test_first_part() {
        assert_eq!(part1(&vec![('R', 2), ('L', 3)]), 5);
        assert_eq!(part1(&vec![('R', 2), ('R', 2), ('R', 2)]), 2);
        assert_eq!(part1(&vec![('R', 5), ('L', 5), ('R', 5), ('R', 3)]), 12);
    }

    #[test]
    fn test_second_part() {
        assert_eq!(part2(&vec![('R', 8), ('R', 4), ('R', 4), ('R', 8)]), 4);
        assert_eq!(part2(&vec![('R', 8), ('R', 8), ('R', 8), ('R', 8)]), 0);
        assert_eq!(part2(&vec![('R', 8), ('R', 8), ('R', 7), ('R', 8)]), 1);
    }
}
