use crate::solver::Solver;
use std::{
    io::{self, BufRead, BufReader},
    str::{self, FromStr},
};

#[derive(Debug, Copy, Clone)]
pub enum Node {
    Bot(usize),
    Input(usize),
    Output(usize),
}

#[derive(Debug, Copy, Clone)]
pub enum Branch {
    Low,
    High,
    Input,
}

#[derive(Debug, Copy, Clone)]
pub struct Rel(Node, Branch, Node);

#[derive(Debug)]
pub struct Rels(Vec<Rel>);

impl FromStr for Rels {
    type Err = ();

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        use std::borrow::Cow;

        let mut s_iter = s.chars();
        let instr: &str = &s_iter
            .by_ref()
            .take_while(|c| *c != ' ')
            .collect::<Cow<'_, str>>();

        fn next_number(it: &mut dyn std::iter::Iterator<Item = char>) -> Result<usize, ()> {
            Ok(it
                .skip_while(|c| !c.is_digit(10))
                .take_while(|c| *c != ' ')
                .collect::<Cow<'_, str>>()
                .parse()
                .map_err(|_| ())?)
        }

        fn next_word(it: &mut dyn std::iter::Iterator<Item = char>) -> String {
            it.skip_while(|c| !c.is_alphabetic())
                .take_while(|c| *c != ' ')
                .collect()
        }

        fn next_keyword(mut it: &mut dyn std::iter::Iterator<Item = char>) -> String {
            let mut s = next_word(&mut it);
            while s != "bot" && s != "output" {
                s = next_word(&mut it);
            }
            s
        }

        match instr {
            "value" => {
                let val = Node::Input(next_number(&mut s_iter)?);
                let bot = Node::Bot(next_number(&mut s_iter)?);
                Ok(Rels(vec![Rel(val, Branch::Input, bot)]))
            }
            "bot" => {
                let bot = Node::Bot(next_number(&mut s_iter)?);
                match next_keyword(&mut s_iter).as_str() {
                    "output" => {
                        let out1 = Node::Output(next_number(&mut s_iter)?);
                        match next_keyword(&mut s_iter).as_str() {
                            "output" => {
                                let out2 = Node::Output(next_number(&mut s_iter)?);
                                Ok(Rels(vec![
                                    Rel(bot, Branch::Low, out1),
                                    Rel(bot, Branch::High, out2),
                                ]))
                            }
                            "bot" => {
                                let bot1 = Node::Bot(next_number(&mut s_iter)?);
                                Ok(Rels(vec![
                                    Rel(bot, Branch::Low, out1),
                                    Rel(bot, Branch::High, bot1),
                                ]))
                            }
                            _ => Err(()),
                        }
                    }
                    "bot" => {
                        let bot1 = Node::Bot(next_number(&mut s_iter)?);
                        match next_keyword(&mut s_iter).as_str() {
                            "output" => {
                                let out1 = Node::Output(next_number(&mut s_iter)?);
                                Ok(Rels(vec![
                                    Rel(bot, Branch::Low, bot1),
                                    Rel(bot, Branch::High, out1),
                                ]))
                            }
                            "bot" => {
                                let bot2 = Node::Bot(next_number(&mut s_iter)?);
                                Ok(Rels(vec![
                                    Rel(bot, Branch::Low, bot1),
                                    Rel(bot, Branch::High, bot2),
                                ]))
                            }
                            _ => Err(()),
                        }
                    }
                    _ => Err(()),
                }
            }
            _ => Err(()),
        }
    }
}

pub struct Problem;

impl Solver for Problem {
    type Input = (usize, usize);
    type Output1 = usize;
    type Output2 = usize;

    fn parse_input<R: io::Read>(&self, r: R) -> Self::Input {
        solve(&
        BufReader::new(r)
            .lines()
            .flatten()
            .map(|l| l.parse::<Rels>().unwrap())
            .fold(vec![], |mut acc, mut v| {
                acc.append(&mut v.0);
                acc
            }))
    }

    fn solve_first(&self, input: &Self::Input) -> Self::Output1 {
        input.0
    }

    fn solve_second(&self, input: &Self::Input) -> Self::Output2 {
        input.1
    }
}

fn solve(input: &[Rel]) -> (usize, usize) {
    let mut outputs = vec![0; 50];
    let mut bots = vec![vec![]; 300];
    let mut part1 = None;

    fn can_be_applied(r: &Rel, s: &[Vec<usize>]) -> bool {
        match r.0 {
            Node::Input(_) => true,
            Node::Bot(n) => s[n].len() == 2,
            _ => false,
        }
    }

    let (mut now, mut later): (Vec<Rel>, Vec<Rel>) =
        input.iter().partition(|r| can_be_applied(r, &bots));

    while !now.is_empty() {
        for Rel(a, b, c) in now.iter() {
            match a {
                Node::Input(i) => match c {
                    Node::Bot(n) => {
                        bots[*n].push(*i);
                    }
                    Node::Output(o) => {
                        outputs[*o] = *i;
                    }
                    _ => {}
                },
                Node::Bot(n) => {
                    if bots[*n].len() == 2
                        && ((bots[*n][0] == 17 && bots[*n][1] == 61)
                            || (bots[*n][0] == 61 && bots[*n][1] == 17))
                    {
                        part1 = Some(*n);
                    }
                    match b {
                        Branch::Low => {
                            let min = bots[*n].iter().min().unwrap().clone();
                            match c {
                                Node::Bot(n1) => {
                                    bots[*n1].push(min);
                                }
                                Node::Output(o) => {
                                    outputs[*o] = min;
                                }
                                _ => {}
                            }
                            bots[*n].retain(|e| e != &min);
                        }
                        Branch::High => {
                            let max = bots[*n].iter().max().unwrap().clone();
                            match c {
                                Node::Bot(n1) => {
                                    bots[*n1].push(max);
                                }
                                Node::Output(o) => {
                                    outputs[*o] = max;
                                }
                                _ => {}
                            }
                            bots[*n].retain(|e| e != &max);
                        }
                        _ => {}
                    }
                }
                _ => {}
            }
        }
        let (n_now, n_later) = later.iter().partition(|r| can_be_applied(r, &bots));
        now = n_now;
        later = n_later;
    }

    (part1.unwrap(), outputs[0] * outputs[1] * outputs[2])
}

#[cfg(test)]
mod tests {
    use crate::solutions::day10::*;

    #[test]
    fn test_first_part() {}

    #[test]
    fn test_second_part() {}
}
