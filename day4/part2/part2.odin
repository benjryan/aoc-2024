package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"
import "core:unicode"

table: [dynamic]u8
table_size: int

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

    count: int
    for i in 0..<len(table) {
        pos := [2]int{i%table_size,i/table_size}
        c: u8
        ok: bool
        c, ok = char_lookup(pos)
        if ok && c == 'A' {
            tl, tl_ok := char_lookup(pos+{-1,-1})
            tr, tr_ok := char_lookup(pos+{1,-1})
            bl, bl_ok := char_lookup(pos+{-1,1})
            br, br_ok := char_lookup(pos+{1,1})
            if (tl_ok && tr_ok && bl_ok && br_ok) &&
                ((tl == 'M' && br == 'S') || (tl == 'S' && br == 'M')) &&
                ((bl == 'M' && tr == 'S') || (bl == 'S' && tr == 'M')) {
                count += 1
            }
        }
    }
    fmt.println(count)
}
