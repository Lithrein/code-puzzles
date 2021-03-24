use crate::solver::Solver;
use std::{
    io::{self, BufRead, BufReader},
    str,
    str::FromStr,
    string::ParseError,
};

pub struct Problem;

#[derive(Debug)]
pub struct RoomLabel {
    labels: Vec<String>,
    checksum: String,
    sector_id: isize,
}

impl FromStr for RoomLabel {
    type Err = ParseError;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let mut labels = s
            .chars()
            .take_while(|c| !c.is_digit(10))
            .collect::<String>()
            .split('-')
            .map(|s| s.to_string())
            .collect::<Vec<_>>();
        labels.retain(|s| s != "");

        let sector_id = s
            .chars()
            .skip_while(|c| !c.is_digit(10))
            .take_while(|c| *c != '[')
            .collect::<String>()
            .parse::<isize>()
            .unwrap();

        let checksum = s
            .chars()
            .skip_while(|c| *c != '[')
            .skip(1)
            .take_while(|c| *c != ']')
            .collect();

        Ok(RoomLabel { labels, checksum, sector_id })
    }
}

impl Solver for Problem {
    type Input = Vec<RoomLabel>;
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
        input
            .iter()
            .filter(|c| is_checksum_valid(c))
            .map(|rl| rl.sector_id)
            .sum()
    }

    fn solve_second(&self, input: &Self::Input) -> Self::Output2 {
        input
            .iter()
            .filter(|c| is_checksum_valid(c))
            .filter(|r| decrypt(r) == "northpole object storage")
            .map(|rl| rl.sector_id)
            .sum()
    }
}

fn is_checksum_valid(room: &RoomLabel) -> bool {
    let mut letters = vec![0; 26];
    let mut max: Vec<u8> = vec![0; 5];

    for label in room.labels.iter() {
        for c in label.as_bytes().iter() {
            letters[(c - 97) as usize] += 1
        }
    }

    for i in 0..5 {
        for j in 0..26 {
            if letters[j] > letters[max[i] as usize] {
                max[i] = j as u8
            }
        }
        letters[max[i] as usize] = -1;
    }

    room.checksum
        == str::from_utf8(
            vec![
                max[0] + 97,
                max[1] + 97,
                max[2] + 97,
                max[3] + 97,
                max[4] + 97,
            ]
            .as_slice(),
        )
        .unwrap()
}

fn label_size(room: &RoomLabel) -> usize {
    let mut sz = 0;
    for i in room.labels.iter() {
        sz += i.len() + 1
    }
    sz - 1
}

fn decrypt(room: &RoomLabel) -> String {
    let len = label_size(room);
    let mut res = vec![0; len];
    let mut idx = 0;

    for label in room.labels.iter() {
        for c in label.as_bytes().iter() {
            res[idx] = (97 + (((*c - 97) as isize) + room.sector_id) % 26) as u8;
            idx += 1;
        }
        if idx < len {
            res[idx] = 32;
            idx += 1;
        }
    }

    str::from_utf8(res.as_slice()).unwrap().to_string()
}

#[cfg(test)]
mod tests {
    use crate::solutions::day04::*;

    #[test]
    fn test_first_part() {
        assert_eq!(
            is_checksum_valid(&&"aaaaa-bbb-z-y-x-123[abxyz]".parse().unwrap()),
            true
        );
        assert_eq!(
            is_checksum_valid(&&"a-b-c-d-e-f-g-h-987[abcde]".parse().unwrap()),
            true
        );
        assert_eq!(
            is_checksum_valid(&&"not-a-real-room-404[oarel]".parse().unwrap()),
            true
        );
        assert_eq!(
            is_checksum_valid(&&"totally-real-room-200[decoy]".parse().unwrap()),
            false
        );
    }

    #[test]
    fn test_second_part() {
        assert_eq!(
            decrypt(&&"qzmt-zixmtkozy-ivhz-343[abcde]".parse().unwrap()),
            "very encrypted name".to_string()
        );
    }
}
