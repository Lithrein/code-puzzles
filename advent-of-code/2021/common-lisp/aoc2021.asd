(defsystem :aoc2021
  :description "aoc2021: My solution to Advent of Code 2021"
  :components ((:file "packages")
               (:file "day01" :depends-on ("packages"))
               (:file "day02" :depends-on ("packages"))
               (:file "day03" :depends-on ("packages"))
               (:file "day04" :depends-on ("packages"))
               (:file "day05" :depends-on ("packages"))))

