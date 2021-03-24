use crate::solver::Solver;
use std::io::{self, BufRead, BufReader};

pub struct Problem;

impl Solver for Problem {
    type Input = Vec<String>;
    type Output1 = usize;
    type Output2 = usize;

    fn parse_input<R: io::Read>(&self, r: R) -> Self::Input {
        BufReader::new(r).lines().flatten().collect()
    }

    fn solve_first(&self, input: &Self::Input) -> Self::Output1 {
        input
            .iter()
            .map(|s| decompress_v1(s))
            .map(|s| s.len())
            .sum()
    }

    fn solve_second(&self, input: &Self::Input) -> Self::Output2 {
        input
            .iter()
            .map(|s| decompress_v2(s))
            .sum()
    }
}

fn decompress_v1(s: &str) -> String {
    let mut res: Vec<char> = vec![];
    let mut sub: Vec<char> = vec![];
    let mut cnt;
    let mut s_iter = s.chars();
    let mut within_brackets = false;

    while let Some(c) = s_iter.next() {
        match c {
            '(' => within_brackets = true,
            ')' => {
                within_brackets = false;
                let vals = sub
                    .iter()
                    .collect::<String>()
                    .split('x')
                    .map(|x| x.parse().unwrap())
                    .collect::<Vec<_>>();
                let sz = vals[0];
                cnt = vals[1];
                sub.clear();
                for _ in 0..sz {
                    sub.push(s_iter.next().unwrap());
                }
                for _ in 0..cnt {
                    for c in sub.iter() {
                        res.push(*c);
                    }
                }
                sub.clear();
            }
            _ => {
                if within_brackets {
                    sub.push(c)
                } else {
                    res.push(c)
                }
            }
        }
    }

    res.iter().collect()
}

fn decompress_v2(s: &str) -> usize {
    let mut res: usize = 0;
    let mut sub: Vec<char> = vec![];
    let mut s_iter = s.chars();
    let mut within_brackets = false;

    while let Some(c) = s_iter.next() {
        match c {
            '(' => within_brackets = true,
            ')' => {
                within_brackets = false;
                let vals = sub
                    .iter()
                    .collect::<String>()
                    .split('x')
                    .map(|x| x.parse().unwrap())
                    .collect::<Vec<_>>();
                let sz = vals[0];
                let cnt = vals[1];
                let mut tmp = vec![];
                for _ in 0..sz {
                    tmp.push(s_iter.next().unwrap());
                }
                res += cnt * decompress_v2(&tmp.iter().collect::<String>());
                sub.clear();
            }
            _ => {
                if within_brackets {
                    sub.push(c)
                } else {
                    res += 1
                }
            }
        }
    }

    res
}

#[cfg(test)]
mod tests {
    use crate::solutions::day09::*;

    #[test]
    fn test_decompress_v1() {
        assert_eq!(decompress_v1(&"ADVENT".to_string()), "ADVENT".to_string());
        assert_eq!(decompress_v1(&"A(1x5)BC".to_string()), "ABBBBBC".to_string());
        assert_eq!(decompress_v1(&"(3x3)XYZ".to_string()), "XYZXYZXYZ".to_string());
        assert_eq!(decompress_v1(&"A(2x2)BCD(2x2)EFG".to_string()), "ABCBCDEFEFG".to_string());
        assert_eq!(decompress_v1(&"(6x1)(1x3)A".to_string()), "(1x3)A".to_string());
        assert_eq!(decompress_v1(&"X(8x2)(3x3)ABCY".to_string()), "X(3x3)ABC(3x3)ABCY".to_string());
    }

    #[test]
    fn test_decompress_v2() {
        assert_eq!(decompress_v2(&"ADVENT".to_string()), 6);
        assert_eq!(decompress_v2(&"(3x3)XYZ".to_string()), 9);
        assert_eq!(decompress_v2(&"A(2x2)BCD(2x2)EFG".to_string()), 11);
        assert_eq!(decompress_v2(&"(6x1)(1x3)A".to_string()), 3);
        assert_eq!(decompress_v2(&"X(8x2)(3x3)ABCY".to_string()), 20);
        assert_eq!(decompress_v2(&"(27x12)(20x12)(13x14)(7x10)(1x12)A".to_string()), 241920);
        assert_eq!(decompress_v2(&"(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN".to_string()), 445);
    }
}
