#include <stdlib.h>
#include <stdio.h>
#include <assert.h>

#include "../../lib/util.h"
#include "../../lib/list.h"
#include "../../lib/util.c"

List_Def(size_t);
List(size_t) numbers = {};

void split_number(size_t n, size_t* out1, size_t* out2) {
    char buffer[256];
    int len = sprintf(buffer, "%zu", n);
    int half = len/2;
    String str1 = {buffer, half};
    String str2 = {buffer+half, half};
    *out1 = parse_size(str1);
    *out2 = parse_size(str2);
}

void print_numbers() {
    printf("(");
    for (size_t i = 0; i < numbers.count; i++) {
        if (i == 0) {
            printf("%zu", numbers.items[i]);
        } else {
            printf(", %zu", numbers.items[i]);
        }
    }
    printf(")\n");
}

void blink() {
    for (size_t i = 0; i < numbers.count; i++) {
        size_t num = numbers.items[i];
        if (num == 0) {
            numbers.items[i] = 1;
        } else if ((count_digits(num) % 2) == 0) {
            size_t first, second;
            split_number(num, &first, &second);
            numbers.items[i] = second;
            list_insert(numbers, i, first);
            i++;
        } else {
            numbers.items[i] = num*2024;
        }
    }
}

int main() {
    FILE* file = fopen("../input.txt", "r");

    size_t num;
    while (fscanf(file, "%zu", &num) > 0) {
        list_append(numbers, num);
    }

    for (int i = 0; i < 25; i++) {
        blink();
    }

    printf("stones: %zu\n", numbers.count);
}
