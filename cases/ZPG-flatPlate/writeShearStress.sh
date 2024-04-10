#!/bin/bash
timeDir=$1
model=$2

foamDictionary -entry boundaryField.bottomWall.value -value $timeDir/Cx | \
    sed -n '/(/,/)/p' | sed -e 's/[()]//g;/^\s*$/d' > Cx.$$
foamDictionary -entry boundaryField.bottomWall.value -value $timeDir/wallShearStress | \
    sed -n '/(/,/)/p' | sed -e 's/[()]//g;/^\s*$/d' > tau.$$

echo "# ccx tau_xx tau_yy tau_zz" > tauw_${model}.dat
paste -d ' ' Cx.$$ tau.$$ >> tauw_${model}.dat
\rm -f Cx.$$ tau.$$
