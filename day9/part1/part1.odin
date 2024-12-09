package main

import "core:fmt"
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

    for n, i in disk {
        if n == -1 {
            for end := len(disk)-1; end > i; end -= 1 {
                if disk[end] != -1 {
                    disk[i] = disk[end]
                    disk[end] = -1
                    break
                }
            }
        }
    }

    total: int
    for n, i in disk {
        if n == -1 {
            break
        }
        total += n * i
    }
    fmt.println(total)
}
