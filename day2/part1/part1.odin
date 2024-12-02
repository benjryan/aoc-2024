package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"

main :: proc() {
    data, _ := os.read_entire_file("../input.txt")
    data_str := string(data)
    lines := strings.split_lines(data_str)
    safe_count := 0
    for line in lines {
        line := strings.trim(line, " ")
        if len(line) == 0 {
            continue
        }

        numbers := strings.split(line, " ")
        safe := true
        prev_dir := 0
        for num_str, i in numbers[1:] {
            num, _ := strconv.parse_int(num_str)
            prev_num, _ := strconv.parse_int(numbers[i])

            delta := num - prev_num
            if delta == 0 {
                safe = false
                break
            }

            dir := delta > 0 ? 1 : -1
            if prev_dir != 0 && dir != prev_dir {
                safe = false
                break
            }

            if abs(delta) > 3 {
                safe = false
                break
            }

            prev_dir = dir
        }

        if safe {
            safe_count += 1
        }
    }

    fmt.println("safe count:", safe_count)
}
