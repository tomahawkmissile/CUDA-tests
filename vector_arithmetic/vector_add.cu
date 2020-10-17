#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <time.h>

//This program adds a vector array of FP32 and FP64 types on a single CPU core.

__global__ void run32_gpu(float* out, float* a, float* b, int n) {
    for(unsigned int i=0;i<n;i++) {
        out[i]=a[i]+b[i];
    }
}
__global__ void run64_gpu(float* out, float* a, float* b, int n) {
    for(unsigned int i=0;i<n;i++) {
        out[i]=a[i]+b[i];
    }
}

int main(int argc, char* argv[]) {

    if(argc!=1) {
        printf("Only pass 1 argument, which is the amount of array elements.\n");
        return -1;
    }
    sscanf(argv[0],"%i",&n);
    printf("Starting with %i array elements.\n", n);

    int n;

    float *fa, *fb, *fout, *gfa, *gfb, *gfout;
    double *da, *db, *dout, *gda, *gdb, *gdout; 

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

    cudaMalloc((void**)&gfa, sizeof(float)*n);
    cudaMalloc((void**)&gfb, sizeof(float)*n);
    cudaMalloc((void**)&gda, sizeof(double)*n);
    cudaMalloc((void**)&gdb, sizeof(double)*n);

    cudaMemcpy(gfa, fa, sizeof(float)*n, cudaMemcpyHostToDevice);
    cudaMemcpy(gfb, fb, sizeof(float)*n, cudaMemcpyHostToDevice);
    cudaMemcpy(gda, da, sizeof(double)*n, cudaMemcpyHostToDevice);
    cudaMemcpy(gdb, db, sizeof(double)*n, cudaMemcpyHostToDevice);

    clock_t f_start = clock();
    run32_gpu<<<1,1>>>(gfout, gfa, gfb, n);
    clock_t f_end = clock();
    printf("FP32 test took: %f\n",((double)(f_end-f_start))/CLOCKS_PER_SEC);

    clock_t d_start = clock();
    run64_gpu<<<1,1>>>(gdout, gda, gdb, n);
    clock_t d_end = clock();
    printf("FP64 test took: %f\n",((double)(d_end-d_start))/CLOCKS_PER_SEC);

    printf("Done.\n");

    return 0;
}