package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"
import "core:unicode"
import "core:slice"

get_height :: proc(data: []string, pos: [2]int) -> u8 {
    if pos.x < 0 || pos.x >= len(data[0]) || pos.y < 0 || pos.y >= len(data[0]) {
        return 0
    }

    return data[pos.y][pos.x]
}

search :: proc(destinations: ^map[[2]int]struct{}, data: []string, pos: [2]int, target: u8) {
    offsets := [][2]int { {-1, 0}, {0, -1}, {1, 0}, {0, 1} }
    for offset in offsets {
        if get_height(data, pos+offset) == target {
            if target == '9' {
                destinations[pos+offset] = {}
            } else {
                search(destinations, data, pos+offset, target+1)
            }
        }
    }
}

main :: proc() {
    data, _ := os.read_entire_file("../input.txt")
    disk: [dynamic]int
    reading_file := true
    file_count: int
    lines := strings.split_lines(string(data))
    total: int
    outer: for line, y in lines {
        for c, x in line {
            search_char := '0'
            if c == search_char {
                destinations: map[[2]int]struct{}
                search(&destinations, lines, [2]int{x,y}, u8(c+1))
                count := len(destinations)
                total += count
            }
        }
    }

    fmt.println(total)
}
