use crate::solver::Solver;
use std::io::{self, BufRead, BufReader};

pub struct Problem;

impl Solver for Problem {
    type Input = Vec<String>;
    type Output1 = usize;
    type Output2 = usize;

    fn parse_input<R: io::Read>(&self, r: R) -> Self::Input {
        let r = BufReader::new(r);
        r.lines().flatten().collect()
    }

    fn solve_first(&self, input: &Self::Input) -> Self::Output1 {
        input
            .iter()
            .filter(is_nice_string_v1)
            .collect::<Vec<&String>>()
            .len()
    }

    fn solve_second(&self, input: &Self::Input) -> Self::Output2 {
        input
            .iter()
            .filter(is_nice_string_v2)
            .collect::<Vec<&String>>()
            .len()
    }
}

fn is_nice_string_v1(s: &&String) -> bool {
    let mut last = '\0';
    let mut vowels = 0;
    let mut double_letters = 0;
    let mut valid = true;
    for cur in s.chars() {
        vowels += vec!['a', 'e', 'i', 'o', 'u'].contains(&cur) as isize;
        if cur == last {
            double_letters += 1
        } else {
            valid = valid
                && ((last != 'a' || cur != 'b')
                    && (last != 'c' || cur != 'd')
                    && (last != 'p' || cur != 'q')
                    && (last != 'x' || cur != 'y'));
        }
        last = cur;
    }
    vowels >= 3 && valid && double_letters >= 1
}

fn is_nice_string_v2(s: &&String) -> bool {
    let mut before_last = '\0';
    let mut last = '\0';
    let mut eyes = 0;
    let mut two_letters = 0;
    let mut group_of_two_letters = vec![];
    let mut overlap = false;
    for cur in s.chars() {
        eyes += (before_last == cur) as isize;
        if last != '\0' {
            let mut string: String = "".to_string();
            string.push(last);
            string.push(cur);
            group_of_two_letters.push(string)
        }

        before_last = last;
        last = cur;
    }

    let mut last: &String = &"".to_string();
    for cur in group_of_two_letters.iter() {
        overlap = overlap || (*last == *cur);
        last = cur;
    }

    group_of_two_letters.sort();
    let mut last: &String = &"".to_string();
    for cur in group_of_two_letters.iter() {
        two_letters += (*last == *cur) as isize;
        last = cur;
    }

    eyes >= 1 && two_letters >= 1 && !overlap
}

#[cfg(test)]
mod tests {
    use crate::solutions::day05::*;

    #[test]
    fn test_first_part() {
        assert_eq!(is_nice_string_v1(&&"ugknbfddgicrmopn".to_string()), true);
        assert_eq!(is_nice_string_v1(&&"aaa".to_string()), true);
        assert_eq!(is_nice_string_v1(&&"jchzalrnumimnmhp".to_string()), false);
        assert_eq!(is_nice_string_v1(&&"haegwjzuvuyypxyu".to_string()), false);
        assert_eq!(is_nice_string_v1(&&"dvszwmarrgswjxmb".to_string()), false);
    }

    #[test]
    fn test_second_part() {
        assert_eq!(is_nice_string_v2(&&"aaa".to_string()), false);
        assert_eq!(is_nice_string_v2(&&"xxyxx".to_string()), true);
        /* consider that xx is overlapping, I don't know whether this is true or false,
         * but the solution to my input is correct... */
        assert_eq!(is_nice_string_v2(&&"xxxxx".to_string()), false);
        assert_eq!(is_nice_string_v2(&&"qjhvhtzxzqqjkmpb".to_string()), true);
        assert_eq!(is_nice_string_v2(&&"uurcxstgmygtbstg".to_string()), false);
        assert_eq!(is_nice_string_v2(&&"ieodomkazucvgmuy".to_string()), false);
    }
}
