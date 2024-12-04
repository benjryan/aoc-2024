package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"
import "core:unicode"

table: [dynamic]u8
table_size: int

word_search :: proc(word: string, progress: int, pos: [2]int, step: [2]int) -> bool {
    if progress >= len(word) {
        return true
    }

    c, ok := char_lookup(pos)
    if ok && c == word[progress] {
        return word_search(word, progress + 1, pos + step, step)
    }

    return false
}

char_lookup :: proc(pos: [2]int) -> (u8, bool) {
    if pos.x < 0 || pos.x >= table_size || pos.y < 0 || pos.y >= table_size {
        return 0, false
    }

    return table[pos.y*table_size+pos.x], true
}

main :: proc() {
    data, _ := os.read_entire_file("../input.txt")
    lines := strings.split_lines(string(data))
    table_size = len(lines[0])
    table = make([dynamic]u8, table_size*table_size) 
    for i in 0..<table_size {
        copy(table[i*table_size:][:table_size], lines[i][:])
    }

    steps := [][2]int {
        {-1,-1},
        {-1,0},
        {-1,1},
        {0,-1},
        {0,1},
        {1,-1},
        {1,0},
        {1,1},
    }

    word := "XMAS"
    count: int
    for i in 0..<len(table) {
        pos := [2]int{i%table_size,i/table_size}
        for step in steps {
            if word_search(word, 0, pos, step) do count += 1
        }
    }
    fmt.println(count)
}
