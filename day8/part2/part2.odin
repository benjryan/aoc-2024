package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"
import "core:unicode"
import "core:slice"

add_antinodes :: proc(antinodes: ^map[[2]int]struct{}, data: []string, start_x, start_y: int) {
    width := len(data[0])
    start_c := data[start_y][start_x]
    for y in 0..<width {
        for x in 0..<width {
            c := data[y][x]
            if c == '.' {
                continue
            }

            if c == start_c {
                dx := x - start_x
                dy := y - start_y
                if dx == 0 && dy == 0 {
                    continue
                }

                x0 := x + dx
                y0 := y + dy
                for x0 >= 0 && x0 < width &&
                    y0 >= 0 && y0 < width {
                    pos := [2]int{x0,y0}
                    antinodes[pos] = {}
                    x0 += dx
                    y0 += dy
                }

                x1 := start_x - dx
                y1 := start_y - dy
                for x1 >= 0 && x1 < width &&
                    y1 >= 0 && y1 < width {
                    pos := [2]int{x1,y1}
                    antinodes[pos] = {}
                    x1 -= dx
                    y1 -= dy
                }
            }
        }
    }
}

main :: proc() {
    data, _ := os.read_entire_file("../input.txt")
    lines := strings.split_lines(string(data))
    width := len(lines[0])
    antinodes: map[[2]int]struct{}
    for line, y in lines {
        for c, x in line {
            if c >= '0' && c <= 'z' {
                pos := [2]int{x,y}
                antinodes[pos] = {}
                add_antinodes(&antinodes, lines, x, y)
            }
        }
    }

    fmt.println(len(antinodes))
}
