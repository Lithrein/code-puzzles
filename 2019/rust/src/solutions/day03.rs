use crate::solver::Solver;
use std::{
    cmp::Ordering,
    collections::HashSet,
    io::{self, BufRead, BufReader},
};

pub struct Problem;

#[derive(Debug, Hash, Clone, Copy)]
pub struct Pair<T>(T, T);

impl<T> PartialEq for Pair<T>
where
    T: PartialEq,
{
    fn eq(&self, other: &Self) -> bool {
        self.0 == other.0 && self.1 == other.1
    }
}

impl<T> Eq for Pair<T> where T: Eq {}

impl<T> PartialOrd for Pair<T>
where
    T: PartialOrd,
{
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(match self.0 == other.0 {
            true => match self.1 == other.1 {
                true => Ordering::Equal,
                false => match self.1 < other.1 {
                    true => Ordering::Less,
                    false => Ordering::Greater,
                },
            },
            false => match self.0 < other.0 {
                true => Ordering::Less,
                false => Ordering::Greater,
            },
        })
    }
}

impl<T> Ord for Pair<T>
where
    T: Ord,
{
    fn cmp(&self, other: &Self) -> Ordering {
        match self.0 == other.0 {
            true => match self.1 == other.1 {
                true => Ordering::Equal,
                false => match self.1 < other.1 {
                    true => Ordering::Less,
                    false => Ordering::Greater,
                },
            },
            false => match self.0 < other.0 {
                true => Ordering::Less,
                false => Ordering::Greater,
            },
        }
    }
}

impl Solver for Problem {
    type Input = (Pair<Vec<Pair<isize>>>, Vec<Pair<isize>>);
    type Output1 = usize;
    type Output2 = usize;

    fn parse_input<R: io::Read>(&self, r: R) -> Self::Input {
        let r = BufReader::new(r);
        let mut v = r.lines().flatten().map(|l| {
            l.split(",")
                .map(|item| {
                    let mut item_iter = item.chars();
                    let dir = item_iter.next().unwrap();
                    let val = item_iter.collect::<String>().parse().unwrap();
                    (dir, val)
                })
                .collect()
        });

        let fst = v.next().unwrap_or(vec![]);
        let snd = v.next().unwrap_or(vec![]);
        let path1 = path_from_directions(&fst);
        let path2 = path_from_directions(&snd);
        let inter = find_intersections(&fst, &snd);
        (Pair(path1, path2), inter)
    }

    fn solve_first(&self, input: &Self::Input) -> Self::Output1 {
        part1(&input)
    }

    fn solve_second(&self, input: &Self::Input) -> Self::Output2 {
        part2(&input)
    }
}

fn path_from_directions(dirs: &Vec<(char, isize)>) -> Vec<Pair<isize>> {
    let mut cur_pos = (0, 0);
    let mut path = vec![];
    for dir in dirs {
        match dir {
            ('U', nb) => {
                for _ in 1..=*nb {
                    cur_pos.1 += 1;
                    path.push(Pair(cur_pos.0, cur_pos.1));
                }
            }
            ('D', nb) => {
                for _ in 1..=*nb {
                    cur_pos.1 -= 1;
                    path.push(Pair(cur_pos.0, cur_pos.1));
                }
            }
            ('L', nb) => {
                for _ in 1..=*nb {
                    cur_pos.0 -= 1;
                    path.push(Pair(cur_pos.0, cur_pos.1));
                }
            }
            ('R', nb) => {
                for _ in 1..=*nb {
                    cur_pos.0 += 1;
                    path.push(Pair(cur_pos.0, cur_pos.1));
                }
            }
            _ => {}
        }
    }
    path
}

fn find_intersections(dirs1: &Vec<(char, isize)>, dirs2: &Vec<(char, isize)>) -> Vec<Pair<isize>> {
    let path1: HashSet<_> = path_from_directions(dirs1).into_iter().collect();
    let path2: HashSet<_> = path_from_directions(dirs2).into_iter().collect();
    path1.intersection(&path2).copied().collect()
}

fn manhattan_distance(pt: &Pair<isize>) -> usize {
    (isize::abs(pt.0) + isize::abs(pt.1)) as usize
}

fn part1(input: &(Pair<Vec<Pair<isize>>>, Vec<Pair<isize>>)) -> usize {
    input
        .1
        .iter()
        .map(|pt| manhattan_distance(pt))
        .min()
        .unwrap()
}

fn path_index<'a, 'b>(
    path: &'a Vec<Pair<isize>>,
    inters: &'b Vec<Pair<isize>>,
) -> Vec<(usize, &'a Pair<isize>)> {
    let mut path_index: Vec<_> = path
        .iter()
        .enumerate()
        .filter(|(_, elt)| inters.contains(elt))
        .collect();
    path_index.sort_by(|a, b| a.1.cmp(&b.1));
    path_index
}

fn part2(input: &(Pair<Vec<Pair<isize>>>, Vec<Pair<isize>>)) -> usize {
    let path1 = &(input.0).0;
    let path2 = &(input.0).1;
    let inters = &input.1;

    let path1_index = path_index(path1, inters);
    let path2_index = path_index(path2, inters);

    path1_index
        .iter()
        .zip(path2_index)
        .map(|(a, b)| (a.0 + b.0 + 2, a.1))
        .min_by(|a, b| a.0.cmp(&b.0))
        .unwrap()
        .0
}

// #[cfg(test)]
// mod tests {
//   use crate::solutions::day03::*;

//   #[test]
//   fn test_part1() {
//   }

//   #[test]
//   fn test_part2() {
//   }
// }
