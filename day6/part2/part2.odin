package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"
import "core:unicode"
import "core:slice"
import "core:time"

Key :: struct {
    idx: int,
    dir: [2]int,
}

is_looping_walk :: proc(table: []string, pos: [2]int, dir: [2]int, obstruction: [2]int) -> bool {
    pos := pos
    dir := dir
    width := len(table[0])
    visited: map[Key]struct{}
    visited[{pos.y*width+pos.x,dir}] = {}
    for {
        new_pos := pos + dir
        if new_pos.x < 0 || new_pos.x >= width || new_pos.y < 0 || new_pos.y >= width {
            break
        }

        if new_pos == obstruction || table[new_pos.y][new_pos.x] == '#' {
            new_dir := [2]int{-dir.y,dir.x}
            dir = new_dir
        } else {
            pos = new_pos
        }

        key := Key{pos.y*width+pos.x,dir}
        if key in visited {
            return true
        }
        visited[key] = {}
    }

    return false
}

main :: proc() {
    start_tick := time.tick_now()
    data, _ := os.read_entire_file("../input.txt")
    table := strings.split_lines(string(data))
    width := len(table[0])
    visited: map[Key]struct{}
    obstructions: map[int]struct{}
    o: map[[2]int]struct{}
    dir := [2]int{0,-1}
    pos: [2]int
    for row, y in table {
        if x := strings.index(row, "^"); x >= 0 {
            pos = {x, y}
            break
        }
    }
    visited[{pos.y*width+pos.x,dir}] = {}

    count: int
    for {
        new_pos := pos + dir
        if new_pos.x < 0 || new_pos.x >= width || new_pos.y < 0 || new_pos.y >= width {
            break
        }

        if table[new_pos.y][new_pos.x] == '#' {
            new_dir := [2]int{-dir.y,dir.x}
            dir = new_dir
        } else {
            // Obstruction loop check
            obstruction_idx := new_pos.y*width+new_pos.x
            if obstruction_idx not_in obstructions {
                if is_looping_walk(table, pos, [2]int{-dir.y,dir.x}, new_pos) {
                    count += 1
                }
                obstructions[obstruction_idx] = {}
            }

            pos = new_pos
        }

        key := Key{pos.y*width+pos.x,dir}
        visited[key] = {}
    }

    duration := time.tick_since(start_tick)
    fmt.println(count)
    fmt.println("duration:", time.duration_seconds(duration))
}
