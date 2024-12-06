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
    width := len(lines[0])
    visited: map[int]struct{}
    dir := [2]int{0,-1}
    pos: [2]int
    for line, y in lines {
        if x := strings.index(line, "^"); x >= 0 {
            pos = {x, y}
            break
        }
    }
    visited[pos.y*width+pos.x] = {}

    for {
        new_pos := pos + dir
        if new_pos.x < 0 || new_pos.x >= width || new_pos.y < 0 || new_pos.y >= width {
            break
        }

        if lines[new_pos.y][new_pos.x] == '#' {
            new_dir := [2]int{-dir.y,dir.x}
            dir = new_dir
        } else {
            pos = new_pos
            visited[pos.y*width+pos.x] = {}
        }
    }

    fmt.println(len(visited))
}
