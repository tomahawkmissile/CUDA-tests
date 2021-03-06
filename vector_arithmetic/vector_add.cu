#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <time.h>

//This program adds a vector array of FP32 and FP64 types on a single GPU thread.

__global__ void run32_gpu(float* out, float* a, float* b, int n) {
    for(unsigned int i=0;i<n;i++) {
        out[i]=a[i]+b[i];
    }
}
__global__ void run64_gpu(double* out, double* a, double* b, int n) {
    for(unsigned int i=0;i<n;i++) {
        out[i]=a[i]+b[i];
    }
}
__global__ void run32_parallel(float* out, float* a, float* b, int n) {
    int xid = blockIdx.x * blockDim.x + threadIdx.x;
    if(n<xid) {
        out[xid]=a[xid]+b[xid];
    }
}
__global__ void run64_parallel(double* out, double* a, double* b, int n) {
    int xid = blockIdx.x * blockDim.x + threadIdx.x;
    if(n<xid) {
        out[xid]=a[xid]+b[xid];
    }
}

int main(int argc, char* argv[]) {

    if(argc!=2) {
        printf("Only pass 1 argument, which is the amount of array elements.\n");
        return -1;
    }

    int n=0;

    sscanf(argv[1],"%i",&n);
    printf("Starting with %i array elements.\n", n);

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

    cudaMalloc((void**)&gfout, sizeof(float)*n);
    cudaMalloc((void**)&gdout, sizeof(double)*n);

    cudaMemcpy(gfa, fa, sizeof(float)*n, cudaMemcpyHostToDevice);
    cudaMemcpy(gfb, fb, sizeof(float)*n, cudaMemcpyHostToDevice);
    cudaMemcpy(gda, da, sizeof(double)*n, cudaMemcpyHostToDevice);
    cudaMemcpy(gdb, db, sizeof(double)*n, cudaMemcpyHostToDevice);

    clock_t f_start = clock();
    run32_gpu<<<1,1>>>(gfout, gfa, gfb, n);
    clock_t f_end = clock();
    printf("FP32 single-thread test took: %f\n",((double)(f_end-f_start))/CLOCKS_PER_SEC);

    clock_t d_start = clock();
    run64_gpu<<<1,1>>>(gdout, gda, gdb, n);
    clock_t d_end = clock();
    printf("FP64 single-thread test took: %f\n",((double)(d_end-d_start))/CLOCKS_PER_SEC);


    f_start = clock();
    run32_parallel<<<1,256>>>(gfout, gfa, gfb, n);
    f_end = clock();
    printf("FP32 single-thread test took: %f\n",((double)(f_end-f_start))/CLOCKS_PER_SEC);

    d_start = clock();
    run64_parallel<<<1,256>>>(gdout, gda, gdb, n);
    d_end = clock();
    printf("FP64 single-thread test took: %f\n",((double)(d_end-d_start))/CLOCKS_PER_SEC);


    printf("Done.\n");

    cudaFree(gfa);
    cudaFree(gfb);
    cudaFree(gfout);
    cudaFree(gda);
    cudaFree(gdb);
    cudaFree(gdout);

    free(fa);
    free(fb);
    free(fout);
    free(da);
    free(db);
    free(dout);

    return 0;
}
