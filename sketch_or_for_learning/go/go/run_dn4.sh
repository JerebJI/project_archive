#!/bin/bash
#SBATCH --nodes=1
#SBATCH --array=0-4
#SBATCH --reservation=psistemi
#SBATCH --output=dn4-%a.txt

srun dn4 -p 9000 -id $SLURM_ARRAY_TASK_ID -n $SLURM_ARRAY_TASK_COUNT