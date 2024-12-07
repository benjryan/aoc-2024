package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"
import "core:unicode"
import "core:slice"

concat :: proc(a, b: int) -> int {
    buffer: [128]u8
    s := fmt.bprintf(buffer[:], "%v%v", a, b)
    n, _ := strconv.parse_int(s)
    return n
}

test_equation :: proc(goal: int, current: int, nums: []int) -> bool {
    if len(nums) == 0 {
        return current == goal
    }

    if test_equation(goal, current * nums[0], nums[1:]) ||
        test_equation(goal, current + nums[0], nums[1:]) ||
        test_equation(goal, concat(current, nums[0]), nums[1:]) {
        return true
    }

    return false
}

main :: proc() {
    data, _ := os.read_entire_file("../input.txt")
    lines := strings.split_lines(string(data))
    total: int
    for line in lines {
        split := strings.split(line, ":")
        if len(split) != 2 {
            continue
        }

        goal, _ := strconv.parse_int(split[0])
        nums: [dynamic]int
        num_split := strings.split(split[1], " ")
        for s in num_split {
            n, ok := strconv.parse_int(s)
            if ok {
                append(&nums, n)
            }
        }

        if test_equation(goal, nums[0]*nums[1], nums[2:]) || 
            test_equation(goal, nums[0]+nums[1], nums[2:]) ||
            test_equation(goal, concat(nums[0],nums[1]), nums[2:]) {
            total += goal
        }
    }

    fmt.println(total)
}
