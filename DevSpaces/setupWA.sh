#!/bin/sh

rm -rf /home/wazi/data/CBSA

wa-create.sh CBSA multi

cp /home/wazi/config/autoDB.txt /home/wazi/data/autoDB.txt

wa-scan.sh CBSA /projects/CBSA/WaziAnalyze/CBSA.dat

wa-startup.sh -p cbsacbsa -o true

