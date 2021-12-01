(defsystem :aoc2021
  :description "aoc2021: My solution to Advent of Code 2021"
  :components ((:file "packages")
               (:file "day01" :depends-on ("packages"))))

