#include <math.h>

size_t parse_size(String s) {
    size_t result = 0;
    for (size_t i = 0; i < s.len; i++) {
        char c = s.ptr[i];
        if (!is_digit(c))
            break;
        result = result * 10 + s.ptr[i] - '0';
    }
    return result;
}

int parse_int(String s) {
    int result = 0;
    if (s.len > 0) {
        int i = 0;
        int neg = 0;

        if (s.ptr[0] == '-') {
            neg = 1;
            i = 1;
        }

        for (; i < (int)s.len; i++) {
            char c = s.ptr[i];
            if (!is_digit(c))
                break;
            result = result * 10 + s.ptr[i] - '0';
        }

        if (neg)
            result = -result;
    }

    return result;
}

size_t count_digits(size_t n) {
    size_t result = 0;
    while (n > 0) {
        n /= 10;
        result++;
    }
    return result;
}

char* read_file(char* path) {
    char* result = 0;
    FILE* fp = fopen(path, "r");
    assert(fp);

    int seek;
    seek = fseek(fp, 0, SEEK_END);
    assert(seek == 0);

    long size = ftell(fp);
    assert(size > 0);
    result = (char*)malloc(size + 1);

    seek = fseek(fp, 0, SEEK_SET);
    assert(seek == 0);

    size_t read_bytes = fread(result, 1, size, fp);
    assert(!ferror(fp));

    result[read_bytes++] = 0;

    fclose(fp);

    return result;
}
