package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"
import "core:unicode"
import "core:slice"

add_antinodes :: proc(antinodes: ^map[[2]int]struct{}, data: []string, start_x, start_y: int) -> int {
    count: int
    width := len(data[0])
    start_c := data[start_y][start_x]
    for y in 0..<width {
        for x in 0..<width {
            if x == start_x && y == start_y {
                continue
            }

            c := data[y][x]
            if c == '.' {
                continue
            }

            if c == start_c {
                dx := start_x - x
                dy := start_y - y
                if dx == 0 && dy == 0 {
                    continue
                }

                x0 := start_x + dx
                y0 := start_y + dy
                x1 := x - dx
                y1 := y - dy

                if x0 >= 0 && x0 < width &&
                    y0 >= 0 && y0 < width {
                    pos := [2]int{x0,y0}
                    antinodes[pos] = {}
                }

                if x1 >= 0 && x1 < width &&
                    y1 >= 0 && y1 < width {
                    pos := [2]int{x1,y1}
                    antinodes[pos] = {}
                }
            }
        }
    }
    return count
}

main :: proc() {
    data, _ := os.read_entire_file("../input.txt")
    lines := strings.split_lines(string(data))
    width := len(lines[0])
    antinodes: map[[2]int]struct{}
    total: int
    for line, y in lines {
        for c, x in line {
            if c >= '0' && c <= 'z' {
                //count_antennas(&antinodes, lines, c, [2]int{x,y})
                total += add_antinodes(&antinodes, lines, x, y)
            }
        }
    }

    fmt.println(len(antinodes))
}
