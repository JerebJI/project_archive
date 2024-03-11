#!/bin/bash

module load CUDA

gcc dn5.c -lm -o cpu > /dev/null
nvcc dn5.cu -o gpu 2> /dev/null

a=`srun --partition=gpu --reservation=psistemi -G1 gpu $1 gpu_$1`
b=`srun --reservation=psistemi cpu $1 cpe_$1`

echo CUDA: $a
echo CPU: $b
echo S = `echo "scale=6 ; $b / $a" | bc`