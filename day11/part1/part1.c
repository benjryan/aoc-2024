#include <stdlib.h>
#include <stdio.h>
#include <assert.h>

#include "..\util.h"

int numbers[32];
int number_count = 0;

void split_number(int n, int* out1, int* out2) {
    char buffer[32];
    int len = sprintf(buffer, "%d", n);
    int half = len/2;
    String str1 = {buffer, half};
    String str2 = {buffer+half, half};
    *out1 = parse_int(str1);
    *out2 = parse_int(str2);
}

void blink() {
    for (int i = 0; i < number_count; i++) {
        int num = numbers[i];
        if (num == 0) {
            numbers[i] = 1;
        } else if ((count_digits(num) % 2) == 0) {

        }
    }
}

int main() {
    FILE* file = fopen("../input.txt", "r");

    int num;
    while (fscanf(file, "%d", &num) > 0) {
        numbers[number_count++] = num;
    }

    int a,b;
    split_number(8076, &a, &b);
    printf("a: %d, b: %d\n", a, b);
    
    //for (int i = 0; i < 6; i++) {
    //    blink();
    //}
}
