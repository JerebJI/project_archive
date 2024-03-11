#!/bin/bash

module load Go
srun --reservation=psistemi go build ./ddn4/dn4.go
srun --reservation=psistemi go build ./clientd/client.go

sbatch run_dn4.sh

srun --reservation=psistemi client -p 9000 -n 5 > dn4-client.txt
sleep 7
cat dn4-*.txt > report.txt