package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"
import "core:unicode"
import "core:slice"

main :: proc() {
    data, _ := os.read_entire_file("../input.txt")
    lines := strings.split_lines(string(data))
    reading_rules := true
    total := 0
    table := make_map(map[int]map[int]struct{})
    for line, i in lines {
        if reading_rules {
            input := strings.split(line, "|")
            if len(input) == 2 {
                a, _ := strconv.parse_int(input[0])
                b, _ := strconv.parse_int(input[1])
                if a not_in table {
                    table[a] = make_map(map[int]struct{})
                }
                set := &table[a]
                set[b] = {}
            } else {
                reading_rules = false
            }
        } else {
            input := strings.split(line, ",")
            in_order := true
            outer: for num, i in input {
                n, _ := strconv.parse_int(num)
                for prev_idx in 0..<i {
                    prev_num, _ := strconv.parse_int(input[prev_idx])
                    if prev_num in table[n] {
                        in_order = false
                        break outer
                    }
                }
            }

            if in_order {
                n, _ := strconv.parse_int(input[len(input)/2])
                total += n
            }
        }
    }

    fmt.println(total)
}
