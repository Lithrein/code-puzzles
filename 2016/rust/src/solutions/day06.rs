use crate::solver::Solver;
use std::{
    io::{self, BufRead, BufReader},
    str,
};

pub struct Problem;

impl Solver for Problem {
    type Input = Vec<String>;
    type Output1 = String;
    type Output2 = String;

    fn parse_input<R: io::Read>(&self, r: R) -> Self::Input {
        BufReader::new(r)
            .lines()
            .flatten()
            .collect()
    }

    fn solve_first(&self, input: &Self::Input) -> Self::Output1 {
        part1(input)
    }

    fn solve_second(&self, input: &Self::Input) -> Self::Output2 {
        part2(input)
    }
}

fn part1(words: &Vec<String>) -> String {
    let mut freqs = vec![vec![0; 26]; words.iter().next().unwrap().len()];
    let mut res = vec![];

    for w in words.iter() {
        let mut i = 0;
        for c in w.as_bytes().iter() {
            let pos = (*c as usize) - 97;
            freqs[i][pos] += 1;
            i += 1;
        }
    }

    for f in freqs.iter() {
        let m = f.iter().enumerate().fold((0,0), |(idx, max), (i, &val)| if val > max { (i, val) } else { (idx, max) }).0;
        res.push((97 + m) as u8);
    }

    str::from_utf8(res.as_slice()).unwrap().to_string()
}

fn part2(words: &Vec<String>) -> String {
    let mut freqs = vec![vec![0; 26]; words.iter().next().unwrap().len()];
    let mut res = vec![];

    for w in words.iter() {
        let mut i = 0;
        for c in w.as_bytes().iter() {
            let pos = (*c as usize) - 97;
            freqs[i][pos] += 1;
            i += 1;
        }
    }

    for f in freqs.iter() {
        let m = f.iter().enumerate().fold((0,27), |(idx, min), (i, &val)| if val < min { (i, val) } else { (idx, min) }).0;
        res.push((97 + m) as u8);
    }

    str::from_utf8(res.as_slice()).unwrap().to_string()
}
#[cfg(test)]
mod tests {
    use crate::solutions::day06::*;

    #[test]
    fn test_first_part() {
        // assert_eq!();
    }

    #[test]
    fn test_second_part() {
    }
}
