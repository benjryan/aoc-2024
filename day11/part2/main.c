#include <stdlib.h>
#include <stdio.h>
#include <assert.h>

#include "../../lib/util.h"
#include "../../lib/util.c"

typedef struct {
    void* ptr;
    size_t pos;
    size_t cap;
} Arena;

typedef struct {
    size_t key;
    size_t value;
    void* next;
    void* prev;
} Stone_Entry;

int pow10[64];

#define ARRAY_COUNT(x) (sizeof(x)/sizeof(x[0]))
Stone_Entry stone_cache[1024*1024];
size_t stone_count;
Arena arena;

size_t stone_key(size_t stone, int blinks) {
    return (stone << 8) | blinks;
}

Stone_Entry* get_stone(size_t stone, int blinks) {
    size_t key = stone_key(stone, blinks);
    size_t slot = key % ARRAY_COUNT(stone_cache);
    Stone_Entry* node = &stone_cache[slot];
    while (node && node->key != key) {
        node = node->next;
    }
    return node;
}

void store_stone(size_t stone, int blinks, size_t value) {
    size_t key = stone_key(stone, blinks);
    size_t slot = key % ARRAY_COUNT(stone_cache);
    Stone_Entry* node = &stone_cache[slot];
    while (node && node->next) {
        node = node->next;
    }
    Stone_Entry* entry = arena.ptr + arena.pos;
    arena.pos += sizeof(Stone_Entry);
    entry->key = key;
    entry->value = value;
    entry->next = 0;
    entry->prev = node;
    node->next = entry;
}

size_t blink(size_t stone, int blinks) {
    if (blinks == 0) return 1;
    Stone_Entry* node = get_stone(stone, blinks);
    size_t stone_count = 0;
    if (node) {
        stone_count = node->value;
    } else {
        if (stone == 0) {
            stone_count = blink(1, blinks-1);
        } else {
            size_t digits = count_digits(stone);
            if (digits % 2 == 0) {
                size_t div = pow10[digits/2];
                size_t stone1 = stone/div;
                size_t stone2 = stone%div;
                stone_count = blink(stone1, blinks-1);
                stone_count += blink(stone2, blinks-1);
            } else {
                stone_count = blink(stone*2024, blinks-1);
            }
        }
        store_stone(stone, blinks, stone_count);
    }
    return stone_count;
}

int main() {
    FILE* file = fopen("../input.txt", "r");

    pow10[0] = 1;
    for (int i = 1; i < 64; ++i) {
        pow10[i] = pow10[i-1]*10;
    }

    arena.pos = 0;
    arena.cap = 1024*1024*100;
    arena.ptr = malloc(arena.cap);

    size_t num;
    size_t stone_count = 0;
    while (fscanf(file, "%zu", &num) > 0) {
        stone_count += blink(num, 75);
    }

    printf("stones: %zu\n", stone_count);
}
