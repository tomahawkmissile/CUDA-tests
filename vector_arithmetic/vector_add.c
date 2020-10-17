#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <time.h>

//This program adds a vector array of different variable types on a single CPU core.

#define ARRAY_SIZE 1000000 //If size is larger than variable maximum value, the maximum value of the variable type will be used.

int main() {

    printf("Starting with %i array elements.", ARRAY_SIZE);

    //Output arrays
    uint16_t* shorts = (uint16_t*)malloc(sizeof(uint16_t)*ARRAY_SIZE);
    uint32_t* ints = (uint32_t*)malloc(sizeof(uint32_t)*ARRAY_SIZE);
    float* floats = (float*)malloc(sizeof(float)*ARRAY_SIZE);
    double* doubles = (double*)malloc(sizeof(double)*ARRAY_SIZE);

    uint16_t resize_index = ARRAY_SIZE>65535 ? 65535 : ARRAY_SIZE;
    //Short performance
    clock_t s_start = clock();
    for(uint16_t i=0;i<resize_index;i++) {
        shorts[i]=(i+i);
    }
    clock_t s_end = clock();
    printf("CPU time used (uint16_t vector addition): %f", ((double)(s_end-s_start))/CLOCKS_PER_SEC);

    //Integer performance
    clock_t i_start = clock();
    for(uint32_t i=0;i<ARRAY_SIZE;i++) {
        ints[i]=(i+i);
    }
    clock_t i_end = clock();
    printf("CPU time used (uint32_t vector addition): %f", ((double)(i_end-i_start))/CLOCKS_PER_SEC);

    //Float performance
    clock_t f_start = clock();
    for(uint32_t i=0;i<ARRAY_SIZE;i++) {
        floats[i]=(i+i+0.5);
    }
    clock_t f_end = clock();
    printf("CPU time used (FP32 vector addition): %f", ((double)(f_end-f_start))/CLOCKS_PER_SEC);

    //Double performance
    clock_t d_start = clock();
    for(uint32_t i=0;i<ARRAY_SIZE;i++) {
        doubles[i]=(i+i+0.5);
    }
    clock_t d_end = clock();
    printf("CPU time used (FP64 vector addition): %f", ((double)(d_end-d_start))/CLOCKS_PER_SEC);

    printf("Done.");

    return 0;
}