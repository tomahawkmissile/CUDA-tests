#!/bin/bash

echo "Compiling..."

gcc -O3 vector_add.c -o vector_add.o

#NVIDIA Tesla K80
nvcc -O3 -arch=sm_37 vector_add.cu -o vector_add.co

echo "Done."