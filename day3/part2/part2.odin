package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"
import "core:unicode"

Token_Type :: enum {
    UNKNOWN,
    MUL,
    LPAREN,
    RPAREN,
    NUMBER,
    COMMA,
    NEW_LINE,
    DO,
    DONT,
}

Token :: struct {
    type: Token_Type,
    start: int,
    end: int,
}

is_number :: proc(s: string) -> bool {
    for c in s {
        if !unicode.is_digit(c) do return false
    }

    return true
}

find_token :: proc(s: string, token: string) -> bool {
    if len(s) < len(token) do return false
    return s[len(s)-len(token):] == token
}

get_token :: proc(data: string, start, end: int) -> Token {
    s := data[start:end]
    if find_token(s, "do(") do return Token{type=.DO}
    if find_token(s, "don't(") do return Token{type=.DONT}
    if find_token(s, "(") do return Token{type=.LPAREN}
    if find_token(s, ")") do return Token{type=.RPAREN}
    if find_token(s, ",") do return Token{type=.COMMA}
    if find_token(s, "mul") do return Token{type=.MUL}
    if is_number(s) do return Token{.NUMBER,start,end}
    if find_token(s, "\n") do return Token{type=.NEW_LINE}
    return Token{type=.UNKNOWN}
}

interpret :: proc(tokens: []Token, template: []Token_Type) -> bool {
    for t, i in template {
        if i >= len(tokens) do return false
        if tokens[i].type != t do return false
    }

    return true
}

main :: proc() {
    data, _ := os.read_entire_file("../input.txt")
    tokens: [dynamic]Token
    current_token: ^Token
    start := -1
    for i in 0..<len(data) {
        if start == -1 {
            start = i
        }

        end := i+1
        token := get_token(string(data), start, end)
        if current_token != nil && current_token.type == token.type {
            current_token.end += 1
        } else {
            // New token
            append(&tokens, token)
            if token.type == .NUMBER || token.type == .UNKNOWN {
                current_token = &tokens[len(tokens)-1]
            } else {
                current_token = nil
                start = -1
            }
        }
    }

    total := 0
    mul_template := []Token_Type { .MUL, .LPAREN, .NUMBER, .COMMA, .NUMBER, .RPAREN }
    do_template := []Token_Type { .DO, .RPAREN }
    dont_template := []Token_Type { .DONT, .RPAREN }
    enabled := true
    for i in 0..<len(tokens) {
        if interpret(tokens[i:], do_template) {
            enabled = true
        } else if interpret(tokens[i:], dont_template) {
            enabled = false
        } else if enabled && interpret(tokens[i:], mul_template) {
            token_a := tokens[i+2]
            token_b := tokens[i+4]
            a, _ := strconv.parse_int(string(data[token_a.start:token_a.end]))
            b, _ := strconv.parse_int(string(data[token_b.start:token_b.end]))
            fmt.println(a,"*",b)
            total += a*b
        }
    }

    fmt.println(total)
}
