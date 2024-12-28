#ifndef UTIL_H

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <assert.h>

typedef struct {
    char* ptr;
    size_t len;
} String;

#define is_digit(c) ((c) >= '0' && (c) <= '9')
int parse_int(String s);
size_t parse_size(String s);
size_t count_digits(size_t n);
char* read_file(char* path);

#endif // UTIL_H
