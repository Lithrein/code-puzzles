use crate::solver::Solver;
use std::{
    io::{self, BufRead, BufReader},
};

#[derive(Clone)]
pub struct Instance {
    min:      usize,
    max:      usize,
    letter:   char,
    password: String
}

fn read_instance (l: &str) -> Instance {
    let mut iter = l.split(char::is_whitespace);
    let policy = iter.next().and_then(|word| word.parse::<String>().ok()).unwrap();
    let letter:char = iter.next().and_then(|word| word.parse::<String>().ok()).unwrap().chars().nth(0).unwrap();
    let password = iter.next().and_then(|word| word.parse::<String>().ok()).unwrap();

    let mut policyiter = policy.split('-');
    let min = policyiter.next().and_then(|word| word.parse::<usize>().ok()).unwrap();
    let max = policyiter.next().and_then(|word| word.parse::<usize>().ok()).unwrap();

    Instance { min, max, letter, password }
}

pub struct Problem;

impl Solver for Problem {
    type Input   = Vec<Instance>;
    type Output1 = usize;
    type Output2 = usize;

    fn parse_input<R: io::Read>(&self, r: R) -> Self::Input {
        let r = BufReader::new(r);
        r.lines().flatten().map(|l| read_instance(&l)).collect()
    }

    fn solve_first(&self, input: &Self::Input) -> Self::Output1 {
        first_part(input.to_vec())
    }

    fn solve_second(&self, input: &Self::Input) -> Self::Output2 {
        second_part(input.to_vec())
    }
}

fn is_valid_first_policy (instance: &Instance) -> bool {
    let mut count = 0;
    for c in instance.password.chars() {
        if c == instance.letter {
            count += 1
        }
    }
    (instance.min <= count && count <= instance.max)
}

fn xor (a: bool, b: bool) -> bool {
    (a && !b) || (!a && b)
}

fn is_valid_second_policy (instance: &Instance) -> bool {
    let pos1 = instance.password.chars().nth(instance.min - 1).unwrap();
    let pos2 = instance.password.chars().nth(instance.max - 1).unwrap();
    xor(pos1 == instance.letter,pos2 == instance.letter)
}

fn first_part (instances: Vec<Instance>) -> usize {
    let mut nb_valid = 0;
    for i in instances.iter() {
        if is_valid_first_policy(i) {
            nb_valid += 1;
        }
    }
    nb_valid
}

fn second_part (instances: Vec<Instance>) -> usize {
    let mut nb_valid = 0;
    for i in instances.iter() {
        if is_valid_second_policy(i) {
            nb_valid += 1;
        }
    }
    nb_valid
}

#[cfg(test)]
mod tests {
  use crate::solutions::day02::*;

  #[test]
  fn test_first_part() {
    assert_eq!(first_part(
            vec![
                Instance { min:1, max:3, letter:'a', password:"abcde".to_string() },
                Instance { min:1, max:3, letter:'b', password:"cdefg".to_string() },
                Instance { min:2, max:9, letter:'c', password:"ccccccccc".to_string() }
            ]), 2);
  }

  #[test]
  fn test_second_part() {
    assert_eq!(second_part(
            vec![
                Instance { min:1, max:3, letter:'a', password:"abcde".to_string() },
                Instance { min:1, max:3, letter:'b', password:"cdefg".to_string() },
                Instance { min:2, max:9, letter:'c', password:"ccccccccc".to_string() }
            ]), 1);
  }
}
