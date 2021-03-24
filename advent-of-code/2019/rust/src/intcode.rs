use std::{
    fmt,
    io::{self, BufRead},
};

#[macro_export]
macro_rules! exec {
    ($x:expr) => {
        exec($x, &None, &mut None, None, None)
    };
    ($x:expr,$y:expr) => {
        exec($x, &Some($y), &mut None, None, None)
    };
    ($x:expr,$y:expr,$z:expr) => {
        exec($x, &Some($y), &mut Some($z), None, None)
    };
    ($x:expr,$y:expr,$z:expr,$u:expr) => {
        exec($x, &Some($y), &mut Some($z), Some($u), None)
    };
    ($x:expr,$y:expr,$z:expr,$u:expr,$v:expr) => {
        exec($x, &Some($y), &mut Some($z), Some($u), Some($v))
    };
}

pub struct Pair<T>(T, T);

impl<T> fmt::Display for Pair<T>
where
    T: fmt::Display,
{
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "{} {}", self.0, self.1)
    }
}

impl<T> fmt::Debug for Pair<T>
where
    T: fmt::Debug,
{
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "{:?} {:?}", self.0, self.1)
    }
}

fn parse_opcode(_op: &isize) -> (isize, isize, isize, isize, isize) {
    let mut op = *_op;
    let five = op % 10;
    op = op / 10;
    let four = op % 10;
    op = op / 10;
    let three = op % 10;
    op = op / 10;
    let two = op % 10;
    op = op / 10;
    let one = op % 10;
    (one, two, three, four, five)
}

pub fn exec(_mem: &Vec<isize>, input: &Option<&Vec<isize>>, output: &mut Option<&mut Vec<isize>>, noun: Option<isize>, verb: Option<isize>) -> isize {
    let mut i = 0;
    let mut input_idx = 0;
    let mut vec = _mem.clone();
    match noun {
        Some(n) => vec[1] = n,
        None => {}
    }
    match verb {
        Some(v) => vec[2] = v,
        None => {}
    }
    loop {
        let (a, b, c, d, e) = parse_opcode(&vec[i]);
        match d * 10 + e {
            1 => {
                let val1 = if c == 0 {
                    vec[vec[i + 1] as usize]
                } else {
                    vec[i + 1]
                };
                let val2 = if b == 0 {
                    vec[vec[i + 2] as usize]
                } else {
                    vec[i + 2]
                };
                if a == 0 {
                    let dest = vec[i + 3] as usize;
                    vec[dest] = val1 + val2
                } else {
                    vec[i + 3] = val1 + val2
                };
                i += 4;
            }
            2 => {
                let val1 = if c == 0 {
                    vec[vec[i + 1] as usize]
                } else {
                    vec[i + 1]
                };
                let val2 = if b == 0 {
                    vec[vec[i + 2] as usize]
                } else {
                    vec[i + 2]
                };
                if a == 0 {
                    let dest = vec[i + 3] as usize;
                    vec[dest] = val1 * val2
                } else {
                    vec[i + 3] = val1 * val2
                };
                i += 4;
            }
            3 => {
                let nb = match input {
                    Some(stream) => {
                        input_idx += 1;
                        stream[input_idx - 1]
                    }
                    None => {
                        let mut line = String::new();
                        io::stdin().lock().read_line(&mut line).unwrap();
                        line.trim_end().parse().unwrap()
                    }
                };
                if c == 0 {
                    let dest = vec[i + 3] as usize;
                    vec[dest] = nb
                } else {
                    vec[i + 3] = nb
                };
                i += 2;
            }
            4 => {
                if c == 0 {
                    match output {
                        Some(stream) => {
                            stream.push(vec[vec[i + 1] as usize])
                        }
                        None => println!("{}", vec[vec[i + 1] as usize])
                    }
                } else {
                    match output {
                        Some(stream) => {
                            stream.push(vec[vec[i + 1] as usize])
                        }
                        None => println!("{}", vec[vec[i + 1] as usize])
                    }
                };
                i += 2;
            }
            5 => {
                let param = if c == 0 {
                    vec[vec[i + 1] as usize]
                } else {
                    vec[i + 1]
                };
                let val = if b == 0 {
                    vec[vec[i + 2] as usize]
                } else {
                    vec[i + 2]
                };
                if param != 0 {
                    i = val as usize;
                } else {
                    i += 3
                }
            }
            6 => {
                let param = if c == 0 {
                    vec[vec[i + 1] as usize]
                } else {
                    vec[i + 1]
                };
                let val = if b == 0 {
                    vec[vec[i + 2] as usize]
                } else {
                    vec[i + 2]
                };
                if param == 0 {
                    i = val as usize;
                } else {
                    i += 3
                }
            }
            7 => {
                let val1 = if c == 0 {
                    vec[vec[i + 1] as usize]
                } else {
                    vec[i + 1]
                };
                let val2 = if b == 0 {
                    vec[vec[i + 2] as usize]
                } else {
                    vec[i + 2]
                };
                if a == 0 {
                    let dest = vec[i + 3] as usize;
                    vec[dest] = (val1 < val2) as isize
                } else {
                    vec[i + 3] = (val1 < val2) as isize
                };
                i += 4;
            }
            8 => {
                let val1 = if c == 0 {
                    vec[vec[i + 1] as usize]
                } else {
                    vec[i + 1]
                };
                let val2 = if b == 0 {
                    vec[vec[i + 2] as usize]
                } else {
                    vec[i + 2]
                };
                if a == 0 {
                    let dest = vec[i + 3] as usize;
                    vec[dest] = (val1 == val2) as isize
                } else {
                    vec[i + 3] = (val1 == val2) as isize
                };
                i += 4;
            }
            99 => break,
            _ => {}
        }
    }
    vec[0]
}

pub fn find_noun_verb(vec: &Vec<isize>, goal: isize) -> Pair<isize> {
    let mut noun = 0;
    let mut verb = 0;
    let mut stop = false;

    while noun < 100 && !stop {
        verb = 0;
        while verb < 100 && !stop {
            if exec!(vec, &vec![], &mut vec![], noun, verb) == goal {
                stop = true
            }
            verb += 1;
        }
        noun += 1;
    }
    Pair(noun - 1, verb - 1)
}
