use crate::solver::Solver;
use std::{
    collections::HashSet,
    io::{self, BufRead, BufReader},
};

pub struct Problem;

impl Solver for Problem {
    type Input = Vec<String>;
    type Output1 = isize;
    type Output2 = isize;

    fn parse_input<R: io::Read>(&self, r: R) -> Self::Input {
        let r = BufReader::new(r);
        r.lines().flatten().collect()
    }

    fn solve_first(&self, input: &Self::Input) -> Self::Output1 {
        input.iter().map(nb_visited_houses).sum()
    }

    fn solve_second(&self, input: &Self::Input) -> Self::Output2 {
        input.iter().map(nb_visited_houses_with_robot).sum()
    }
}

fn nb_visited_houses(path: &String) -> isize {
    let mut visited = HashSet::new();
    let mut cur_x = 0;
    let mut cur_y = 0;
    visited.insert((cur_x, cur_y));
    for i in path.chars() {
        match i {
            '>' => cur_x += 1,
            '<' => cur_x -= 1,
            '^' => cur_y += 1,
            'v' => cur_y -= 1,
            _ => {}
        }
        visited.insert((cur_x, cur_y));
    }
    visited.len() as isize
}

fn nb_visited_houses_with_robot(path: &String) -> isize {
    let mut visited = HashSet::new();
    let mut cur_santa_x = 0;
    let mut cur_santa_y = 0;
    let mut cur_robot_x = 0;
    let mut cur_robot_y = 0;
    let mut turn = 0;
    visited.insert((0, 0));
    for i in path.chars() {
        if turn % 2 == 0 {
            match i {
                '>' => cur_santa_x += 1,
                '<' => cur_santa_x -= 1,
                '^' => cur_santa_y += 1,
                'v' => cur_santa_y -= 1,
                _ => {}
            }
            visited.insert((cur_santa_x, cur_santa_y));
        } else {
            match i {
                '>' => cur_robot_x += 1,
                '<' => cur_robot_x -= 1,
                '^' => cur_robot_y += 1,
                'v' => cur_robot_y -= 1,
                _ => {}
            }
            visited.insert((cur_robot_x, cur_robot_y));
        }
        turn += 1
    }
    visited.len() as isize
}
#[cfg(test)]
mod tests {
    use crate::solutions::day03::*;

    #[test]
    fn test_first_part() {
        assert_eq!(nb_visited_houses(&">".to_string()), 2);
        assert_eq!(nb_visited_houses(&"^>v<".to_string()), 4);
        assert_eq!(nb_visited_houses(&"^v^v^v^v^v".to_string()), 2);
    }

    #[test]
    fn test_second_part() {
        assert_eq!(nb_visited_houses_with_robot(&">".to_string()), 2);
        assert_eq!(nb_visited_houses_with_robot(&"^v".to_string()), 3);
        assert_eq!(nb_visited_houses_with_robot(&"^>v<".to_string()), 3);
        assert_eq!(nb_visited_houses_with_robot(&"^v^v^v^v^v".to_string()), 11);
    }
}
