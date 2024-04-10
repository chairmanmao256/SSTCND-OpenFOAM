#!/bin/bash
echo "Running the CND model ..."
cp ./constant/turbulenceProperties.CND ./constant/turbulenceProperties
decomposePar >> log.txt
mpirun -np 4 simpleFoam -parallel >> log.txt 2>&1
./postProcessing.sh
./writeShearStress.sh 8000 CND
rm -r processor*
mv 8000 8000-CND

echo "Running the SST model ..."
cp ./constant/turbulenceProperties.SST ./constant/turbulenceProperties
decomposePar >> log.txt
mpirun -np 4 simpleFoam -parallel >> log.txt 2>&1
./postProcessing.sh
./writeShearStress.sh 8000 SST
rm -r processor*
mv 8000 8000-SST

./plot.sh 14.88