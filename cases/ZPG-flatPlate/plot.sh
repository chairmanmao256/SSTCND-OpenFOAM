#!/bin/bash
UInf=$1
nuInf=$2

gnuplot<<EOF
set xlabel "Re_x"
set ylabel "C_f"
set grid
set xrange [0:1e7]
set yrange [0:0.006]
UInf = $UInf
nuInf = $nuInf
plot \
    "exp.dat" u (\$1):(\$2) title "Experiment" lw 2, \
    "tauw_CND.dat" u (\$1)*UInf/nuInf:(sqrt(\$2*\$2 + \$3*\$3 + \$4*\$4)/(0.5*UInf*UInf)) title "CND" w lines lw 2 lc "red", \
    "tauw_SST.dat" u (\$1)*UInf/nuInf:(sqrt(\$2*\$2 + \$3*\$3 + \$4*\$4)/(0.5*UInf*UInf)) title "SST" w lines lw 2 lc "blue"
set term pngcairo size 800,600
set output "print.png"
replot
EOF