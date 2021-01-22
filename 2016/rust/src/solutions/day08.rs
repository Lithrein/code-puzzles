use crate::solver::Solver;
use std::{
    io::{self, BufRead, BufReader},
    str::{self, FromStr},
};

#[derive(Debug)]
pub enum ScreenOp {
    Rect(usize, usize),
    RotateRow(usize, usize),
    RotateCol(usize, usize),
}

impl FromStr for ScreenOp {
    type Err = String;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        use std::borrow::Cow;
        let op: &str = &s
            .chars()
            .take_while(|c| *c != ' ')
            .collect::<Cow<'_, str>>();

        match op {
            "rect" => {
                let dims: Vec<_> = s
                    .chars()
                    .skip_while(|c| !c.is_digit(10))
                    .collect::<String>()
                    .split("x")
                    .map(|x| x.parse::<usize>())
                    .collect();
                Ok(ScreenOp::Rect(
                    *dims[0].as_ref().unwrap(),
                    *dims[1].as_ref().unwrap(),
                ))
            }
            "rotate" => {
                let subop: &str = &s
                    .chars()
                    .skip_while(|c| *c != ' ')
                    .skip(1)
                    .take_while(|c| *c != ' ')
                    .collect::<Cow<'_, str>>();

                let params: Vec<_> = s
                    .chars()
                    .skip_while(|c| !c.is_digit(10))
                    .collect::<String>()
                    .split(" by ")
                    .map(|x| x.parse::<usize>())
                    .collect();

                match subop {
                    "row" => Ok(ScreenOp::RotateRow(
                        *params[0].as_ref().unwrap(),
                        *params[1].as_ref().unwrap(),
                    )),
                    "column" => Ok(ScreenOp::RotateCol(
                        *params[0].as_ref().unwrap(),
                        *params[1].as_ref().unwrap(),
                    )),
                    _ => Err("".to_string()),
                }
            }
            _ => Err("".to_string()),
        }
    }
}

pub struct Problem;

impl Solver for Problem {
    type Input = Vec<ScreenOp>;
    type Output1 = isize;
    type Output2 = isize;

    fn parse_input<R: io::Read>(&self, r: R) -> Self::Input {
        BufReader::new(r)
            .lines()
            .flatten()
            .map(|l| l.parse().unwrap())
            .collect()
    }

    fn solve_first(&self, input: &Self::Input) -> Self::Output1 {
        part1(&input)
    }

    fn solve_second(&self, _input: &Self::Input) -> Self::Output2 {
        0
    }
}

fn part1(ops: &Vec<ScreenOp>) -> isize {
    let mut screen = vec![vec![false; 50]; 6]; // 50 wide x 6 tall screen

    for op in ops.iter() {
        match op {
            ScreenOp::Rect(x,y) => {
                for i in 0..*y {
                    for j in 0..*x {
                        screen[i][j] = true
                    }
                }
            },
            ScreenOp::RotateRow(row,offset) => {
                let mut new_row = vec![false; 50];
                for i in 0..50 {
                    new_row[(i + offset) % 50] = screen[*row][i]
                }
                for i in 0..50 {
                    screen[*row][i] = new_row[i]
                }
            },
            ScreenOp::RotateCol(col,offset) => {
                let mut new_col = vec![false; 6];
                for i in 0..6 {
                    new_col[(i + offset) % 6] = screen[i][*col]
                }
                for i in 0..6 {
                    screen[i][*col] = new_col[i]
                }
            },
        }
    }
    for row in screen.iter() {
        println!("{}", row.iter().map(|&c| if c { '#' } else { ' ' }).collect::<String>());
    }
    screen.iter().fold(0, |acc, row| (acc + (row.iter().filter(|&&x| x == true).count() as isize)))
}

#[cfg(test)]
mod tests {
    use crate::solutions::day08::*;
}
