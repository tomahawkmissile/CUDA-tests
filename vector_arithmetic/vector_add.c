#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <time.h>

//This program adds a vector array of FP32 and FP64 types on a single CPU core.

int n;

float *fa, *fb, *fout;
double *da, *db, *dout;

void run32_cpu() {
    for(unsigned int i=0;i<n;i++) {
        fout[i]=fa[i]+fb[i];
    }
}
void run64_cpu() {
    for(unsigned int i=0;i<n;i++) {
        dout[i]=da[i]+db[i];
    }
}

int main(int argc, char* argv[]) {

    if(argc!=2) {
        printf("Only pass 1 argument, which is the amount of array elements.\n");
        return -1;
    }
    sscanf(argv[1],"%i",&n);
    printf("Starting with %i array elements.\n", n);

    fa=(float*)malloc(sizeof(float)*n);
    fb=(float*)malloc(sizeof(float)*n);
    fout=(float*)malloc(sizeof(float)*n);
    
    da=(double*)malloc(sizeof(double)*n);
    db=(double*)malloc(sizeof(double)*n);
    dout=(double*)malloc(sizeof(double)*n);

    for(unsigned int i=0;i<n;i++) {
        fa[i]=1.0;
        fb[i]=(float)i;
        
        da[i]=1.0;
        db[i]=(double)i;
    }

    clock_t f_start = clock();
    run32_cpu();
    clock_t f_end = clock();
    printf("FP32 test took: %f\n",((double)(f_end-f_start))/CLOCKS_PER_SEC);

    clock_t d_start = clock();
    run64_cpu();
    clock_t d_end = clock();
    printf("FP64 test took: %f\n",((double)(d_end-d_start))/CLOCKS_PER_SEC);

    printf("Done.\n");

    return 0;
}
