use crate::solver::Solver;
use std::{
    collections::HashSet,
    io::{self, BufRead, BufReader},
};

pub struct Problem;

impl Solver for Problem {
    type Input = Vec<String>;
    type Output1 = usize;
    type Output2 = usize;

    fn parse_input<R: io::Read>(&self, r: R) -> Self::Input {
        BufReader::new(r).lines().flatten().collect()
    }

    fn solve_first(&self, input: &Self::Input) -> Self::Output1 {
        input.iter().filter(support_tls).count()
    }

    fn solve_second(&self, input: &Self::Input) -> Self::Output2 {
        input.iter().filter(support_ssl).count()
    }
}

fn reset_last(last: &mut Vec<Option<char>>) {
    for i in 0..last.len() {
        last[i] = None
    }
}

fn append_last(last: &mut Vec<Option<char>>, c: char) {
    let len = last.len();
    for i in 0..len - 1 {
        last[i] = last[i + 1]
    }
    last[len - 1] = Some(c)
}

fn support_tls(ip: &&String) -> bool {
    let mut within_brackets = false;
    let mut last = vec![None; 4];
    let mut valid = false;

    fn check_pattern(last: &Vec<Option<char>>) -> bool {
        let a = last[0];
        let b = last[1];
        a != b && a == last[3] && b == last[2]
    }

    for c in ip.chars() {
        match c {
            ']' => {
                within_brackets = false;
                reset_last(&mut last)
            }
            '[' => {
                within_brackets = true;
                reset_last(&mut last)
            }
            _ => {
                append_last(&mut last, c);
                if !within_brackets {
                    valid = valid || check_pattern(&last);
                } else {
                    if check_pattern(&last) {
                        valid = false;
                        break;
                    }
                }
            }
        }
    }
    valid
}

fn support_ssl(ip: &&String) -> bool {
    let mut within_brackets = false;
    let mut last = vec![None; 3];
    let mut valid = false;
    let mut aba_patterns = HashSet::new();
    let mut bab_patterns = HashSet::new();

    fn check_pattern(last: &Vec<Option<char>>) -> bool {
        let a = last[0];
        let b = last[1];
        a != b && a == last[2]
    }

    fn extract_pattern(last: &Vec<Option<char>>) -> Vec<char> {
        last.iter().map(|c| c.unwrap()).collect()
    }

    for c in ip.chars() {
        match c {
            ']' => {
                within_brackets = false;
                reset_last(&mut last)
            }
            '[' => {
                within_brackets = true;
                reset_last(&mut last)
            }
            _ => {
                append_last(&mut last, c);
                if check_pattern(&last) {
                    if !within_brackets {
                        aba_patterns.insert(extract_pattern(&last));
                    } else {
                        bab_patterns.insert(extract_pattern(&last));
                    }
                }
            }
        }
    }

    for c in aba_patterns.iter() {
        for d in bab_patterns.iter() {
            valid = valid || (c[0] == d[1] && c[1] == d[0])
        }
    }

    valid
}

#[cfg(test)]
mod tests {
    use crate::solutions::day07::*;

    #[test]
    fn test_support_tls() {
        assert_eq!(support_tls(&&"abba[mnop]qrst".to_string()), true);
        assert_eq!(support_tls(&&"abcd[bddb]xyyx".to_string()), false);
        assert_eq!(support_tls(&&"aaaa[qwer]tyui".to_string()), false);
        assert_eq!(support_tls(&&"ioxxoj[asdfgh]zxcvbn".to_string()), true);
    }

    #[test]
    fn test_support_ssl() {
        assert_eq!(support_ssl(&&"aba[bab]xyz".to_string()), true);
        assert_eq!(support_ssl(&&"xyx[xyx]xyx".to_string()), false);
        assert_eq!(support_ssl(&&"aaa[kek]eke".to_string()), true);
        assert_eq!(support_ssl(&&"zazbz[bzb]cdb".to_string()), true);
    }
}
