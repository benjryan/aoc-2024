package main

import "core:fmt"
import "core:mem"
import "core:os"
import "core:strings"
import "core:strconv"
import "core:unicode"
import "core:slice"

main :: proc() {
    data, _ := os.read_entire_file("../input.txt")
    disk: [dynamic]int
    reading_file := true
    file_count: int
    for c in data {
        n := c - '0'
        if n > 9 {
            break
        }

        if reading_file {
            for i in 0..<n {
                append(&disk, file_count)
            }
            file_count += 1
        } else {
            for i in 0..<n {
                append(&disk, -1)
            }
        }

        reading_file = !reading_file
    }

    for i := len(disk)-1; i >= 0; i-=1 {
        n := disk[i]
        if n != -1 {
            block_start: int
            block_size: int
            for tmp := i; tmp >= 0; tmp -= 1 {
                if disk[tmp] != n do break
                block_size += 1
                block_start = tmp
            }

            for start := 0; start < block_start; start += 1 {
                if disk[start] == -1 {
                    start_block_size: int
                    for tmp := start; tmp < block_start; tmp += 1 {
                        if disk[tmp] != -1 do break
                        start_block_size += 1
                    }

                    if start_block_size >= block_size {
                        // Success
                        mem.copy(&disk[start], &disk[block_start], block_size*size_of(int))
                        for tmp := block_start; tmp < block_start+block_size; tmp += 1 {
                            disk[tmp] = -1
                        }
                        break
                    } else {
                        start += start_block_size-1
                    }
                }
            }

            i -= block_size-1
        }
    }

    total: int
    for n, i in disk {
        if n == -1 {
            continue
        }
        total += n * i
    }
    fmt.println(total)
}
