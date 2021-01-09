use crate::solver::Solver;
use std::{
    cmp::Ordering,
    collections::HashSet,
    fmt,
    io::{self, BufRead, BufReader},
};

pub struct Problem;

#[derive(Debug,Hash,Clone,Copy)]
pub struct Pair<T>(T, T);

impl<T> PartialEq for Pair<T> where T: PartialEq {
    fn eq(&self, other: &Self) -> bool {
        self.0 == other.0 && self.1 == other.1
    }
}

impl<T> Eq for Pair<T> where T: Eq {
}

impl<T> PartialOrd for Pair<T> where T: PartialOrd {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(match self.0 == other.0 {
            true => {
                match self.1 == other.1 {
                    true => Ordering::Equal,
                    false => match self.1 < other.1 {
                        true => Ordering::Less,
                        false => Ordering::Greater,
                    }
                }
            } ,
            false => {
                match self.0 < other.0 {
                    true => Ordering::Less,
                    false => Ordering::Greater,
                }
            }
        })
    }
}

impl<T> Ord for Pair<T> where T: Ord {
    fn cmp(&self, other: &Self) -> Ordering {
        match self.0 == other.0 {
            true => {
                match self.1 == other.1 {
                    true => Ordering::Equal,
                    false => match self.1 < other.1 {
                        true => Ordering::Less,
                        false => Ordering::Greater,
                    }
                }
            } ,
            false => {
                match self.0 < other.0 {
                    true => Ordering::Less,
                    false => Ordering::Greater,
                }
            }
        }
    }
}

impl Solver for Problem {
    type Input = Pair<Vec<(char,isize)>>;
    type Output1 = isize;
    type Output2 = isize;

    fn parse_input<R: io::Read>(&self, r: R) -> Self::Input {
        let r = BufReader::new(r);
        let mut v = r.lines().flatten();

        let fst = match v.next() {
            Some(l) =>
                l.split(",")
                 .map(|item| {
                     let mut item_iter = item.chars();
                     let dir = item_iter.next().unwrap();
                     let val = item_iter.collect::<String>().parse().unwrap();
                     (dir, val)
                 }).collect(),
            None => vec![]
        };
        let snd = match v.next() {
            Some(l) =>
                l.split(",")
                 .map(|item| {
                     let mut item_iter = item.chars();
                     let dir = item_iter.next().unwrap();
                     let val = item_iter.collect::<String>().parse().unwrap();
                     (dir, val)
                 }).collect(),
            None => vec![]
        };
        Pair(fst, snd)
    }

    fn solve_first(&self, input: &Self::Input) -> Self::Output1 {
        part1(&input)
    }

    fn solve_second(&self, input: &Self::Input) -> Self::Output2 {
        0
    }
}

fn path_from_directions(dirs: &Vec<(char,isize)>) -> HashSet<Pair<isize>> {
    let mut cur_pos = (0,0);
    let mut path = HashSet::new();
    for dir in dirs {
        match dir {
            ('U', nb) => {
                for i in 1..=*nb {
                    cur_pos.1 += 1;
                    path.insert(Pair(cur_pos.0, cur_pos.1));
                }},
            ('D', nb) => {
                for i in 1..=*nb {
                    cur_pos.1 -= 1;
                    path.insert(Pair(cur_pos.0, cur_pos.1));
                }},
            ('L', nb) => {
                for i in 1..=*nb {
                    cur_pos.0 -= 1;
                    path.insert(Pair(cur_pos.0, cur_pos.1));
                }},
            ('R', nb) => {
                for i in 1..=*nb {
                    cur_pos.0 += 1;
                    path.insert(Pair(cur_pos.0, cur_pos.1));
                }},
                _     => {}
        }
    }
    path
}

fn part1(input: &Pair<Vec<(char,isize)>>) -> isize {
    let path1 = path_from_directions(&input.0);
    let path2 = path_from_directions(&input.1);
    let pts:Vec<_> = path1.intersection(&path2).collect();
    pts.iter().map(|pt| isize::abs(pt.0) + isize::abs(pt.1)).min().unwrap()
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
