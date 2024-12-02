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

        numbers: [dynamic]int
        for it in strings.split_by_byte_iterator(&line, ' ') {
            num, ok := strconv.parse_int(it)
            if ok {
                append(&numbers, num)
            }
        }

        if len(numbers) == 0 {
            continue
        }

        for i in -1..<len(numbers) {
            if check_safety(numbers, i) {
                safe_count += 1
                break
            }
        }
    }

    fmt.println("safe count:", safe_count)
}


check_safety :: proc(numbers: [dynamic]int, exclude: int = -1) -> bool {
    prev_dir := 0
    prev_idx := -1
    for i in 0..<len(numbers) {
        if i == exclude {
            continue
        }

        if prev_idx == -1 {
            prev_idx = i
            continue
        }

        prev := numbers[prev_idx]
        curr := numbers[i]

        delta := curr - prev
        if delta == 0 {
            return false
        }

        dir := delta > 0 ? 1 : -1
        if prev_dir != 0 && dir != prev_dir {
            return false
        }

        if abs(delta) > 3 {
            return false
        }

        prev_dir = dir
        prev_idx = i
    }

    return true
}
