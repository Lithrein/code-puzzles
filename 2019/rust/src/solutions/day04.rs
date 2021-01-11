use crate::solver::Solver;
use std::{
    io::{self, BufRead, BufReader},
    ops,
};

pub struct Problem;

impl Solver for Problem {
    type Input = ops::Range<usize>;
    type Output1 = usize;
    type Output2 = usize;

    fn parse_input<R: io::Read>(&self, r: R) -> Self::Input {
        let r = BufReader::new(r);
        let v: Vec<String> = r.lines().flatten().collect();

        match v.iter().next() {
            Some(l) => {
                let mut nbs = l.split("-").map(|nb| nb.parse().unwrap_or(0));
                let fst = nbs.next().unwrap_or(0);
                let snd = nbs.next().unwrap_or(0);
                ops::Range {
                    start: fst,
                    end: snd,
                }
            }
            None => 0..0,
        }
    }

    fn solve_first(&self, input: &Self::Input) -> Self::Output1 {
        input
            .clone()
            .filter(|nb| check_rules_v1(nb))
            .collect::<Vec<_>>()
            .len()
    }

    fn solve_second(&self, input: &Self::Input) -> Self::Output2 {
        input
            .clone()
            .filter(|nb| check_rules_v2(nb))
            .collect::<Vec<_>>()
            .len()
    }
}

fn check_rules_v1(nb: &usize) -> bool {
    let mut nb_digits = 0;
    let mut two_adjacent_digits = false;
    let mut last: Option<char> = None;
    let mut never_decrease = true;

    for cur in nb.to_string().chars() {
        nb_digits += 1;
        match last {
            Some(l) => {
                two_adjacent_digits = two_adjacent_digits || l == cur;
                never_decrease = never_decrease && (l <= cur);
            }
            None => {}
        }
        last = Some(cur);
    }
    (nb_digits == 6) && two_adjacent_digits && never_decrease
}

fn check_rules_v2(nb: &usize) -> bool {
    let mut nb_digits = 0;
    let mut two_adjacent_digits = false;
    let mut group_size = 0;
    let mut last: Option<char> = None;
    let mut never_decrease = true;

    for cur in nb.to_string().chars() {
        nb_digits += 1;
        match last {
            Some(l) => {
                never_decrease = never_decrease && (l <= cur);
                if l == cur {
                    group_size += 1;
                } else {
                    two_adjacent_digits = two_adjacent_digits || group_size == 2;
                    group_size = 1;
                }
            }
            None => group_size += 1,
        }
        last = Some(cur);
    }
    two_adjacent_digits = two_adjacent_digits || group_size == 2;
    (nb_digits == 6) && two_adjacent_digits && never_decrease
}

#[cfg(test)]
mod tests {
    use crate::solutions::day04::*;

    #[test]
    fn test_part1() {
        assert_eq!(check_rules_v1(&111111), true);
        assert_eq!(check_rules_v1(&223450), false);
        assert_eq!(check_rules_v1(&123789), false);
    }

    #[test]
    fn test_part2() {
        assert_eq!(check_rules_v2(&112233), true);
        assert_eq!(check_rules_v2(&123444), false);
        assert_eq!(check_rules_v2(&111122), true);
        assert_eq!(check_rules_v2(&116789), true);
    }
}
