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
            nums: [dynamic]int
            for s in input {
                n, _ := strconv.parse_int(s)
                append(&nums, n)
            }

            in_order := true
            outer: for num, i in nums {
                for prev_idx in 0..<i {
                    if nums[prev_idx] in table[num] {
                        in_order = false
                        break outer
                    }
                }
            }

            if !in_order {
                Pair :: struct { n, count: int }
                temp: [dynamic]Pair
                for n in nums {
                    count: int
                    for k in nums {
                        if k in table[n] {
                            count += 1
                        }
                    }
                    append(&temp, Pair{n,count})
                }
                less :: proc(a, b: Pair) -> bool {
                    return a.count >= b.count
                }
                slice.sort_by(temp[:], less)
                total += temp[len(temp)/2].n
            }
        }
    }

    fmt.println(total)
}
