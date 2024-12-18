#ifndef UTIL_H

/*
 * Guidelines
 *
 * Don't use early returns. They're bad for many reasons. 
 * - They necessitate defer.
 * - Multiple exit points causes confusion/harder to follow code.
 *
 */

typedef struct {
    char* ptr;
    int len;
} String;

typedef struct {
    char* ptr;
    int len;
    int size;
} Array;

void array_insert(Array* array, int idx, char* data) {
}

int is_digit(char c) {
    return c >= '0' && c <= '9';
}

int parse_int(String s) {
    if (s.len == 0) {
        return 0;
    }

    int result = 0;
    int i = 0;
    int neg = 0;

    if (s.ptr[0] == '-') {
        neg = 1;
        i = 1;
    }

    for (; i < s.len; i++) {
        char c = s.ptr[i];
        if (!is_digit(c))
            break;
        result = result * 10 + s.ptr[i] - '0';
    }

    if (neg)
        result = -result;

    return result;
}

int count_digits(int n) {
    char buffer[32];
    int result = sprintf(buffer, "%d", n);
    return result;
}

char* read_file(char* path) {
    char* result = 0;
    FILE* fp = fopen("../input.txt", "r");
    assert(fp);

    int seek;
    seek = fseek(fp, 0, SEEK_END);
    assert(seek == 0);

    long size = ftell(fp);
    assert(size > 0);
    result = malloc(size + 1);

    seek = fseek(fp, 0, SEEK_SET);
    assert(seek == 0);

    size_t read_bytes = fread(result, 1, size, fp);
    assert(!ferror(fp));

    result[read_bytes++] = 0;

    fclose(fp);

    return result;
}

#endif // UTIL_H
