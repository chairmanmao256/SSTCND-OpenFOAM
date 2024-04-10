#!/bin/bash
echo "Running the CND model ..."
cp ./constant/turbulenceProperties.CND ./constant/turbulenceProperties
decomposePar >> log.txt
mpirun -np 6 simpleFoam -parallel >> log.txt 2>&1
./postProcessing.sh
./writeShearStress.sh 5000 CND
rm -r processor*
mv 5000 5000-CND

echo "Running the SST model ..."
cp ./constant/turbulenceProperties.SST ./constant/turbulenceProperties
decomposePar >> log.txt
mpirun -np 6 simpleFoam -parallel >> log.txt 2>&1
./postProcessing.sh
./writeShearStress.sh 5000 SST
rm -r processor*
mv 5000 5000-SST

./plot.sh 69.4 1.388e-5