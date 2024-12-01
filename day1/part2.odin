package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"
import "core:slice"

main :: proc() {
    data, _ := os.read_entire_file("../input.txt")
    data_str := string(data)
    lines := strings.split_lines(data_str)
    list_a, list_b: [dynamic]int
    for line in lines {
        line_len := len(line)
        if line_len > 0 {
            num_a, _ := strconv.parse_int(line[:5])
            num_b, _ := strconv.parse_int(line[len(line)-5:len(line)])
            append(&list_a, num_a)
            append(&list_b, num_b)
        }
    }

    total: int
    for num_a in list_a {
        count: int
        for num_b in list_b {
            if num_b == num_a {
                count += 1
            }
        }

        total += num_a * count
    }

    fmt.println(total)
}
