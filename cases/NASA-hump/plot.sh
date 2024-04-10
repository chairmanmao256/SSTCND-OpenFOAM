#!/bin/bash
UInf=$1

gnuplot<<EOF
set xlabel "x"
set ylabel "C_f"
set grid
set xrange [-0.1:1.5]
set yrange [-0.002:0.008]
UInf = $UInf
plot \
    "exp.dat" u (\$1):(\$2) title "Experiment" lw 2, \
    "tauw_CND.dat" u (\$1):(sqrt(\$2*\$2 + \$3*\$3 + \$4*\$4)/(0.5*UInf*UInf)*sgn(\$2)*-1.0) title "CND" w lines lw 2 lc "red", \
    "tauw_SST.dat" u (\$1):(sqrt(\$2*\$2 + \$3*\$3 + \$4*\$4)/(0.5*UInf*UInf)*sgn(\$2)*-1.0) title "SST" w lines lw 2 lc "blue"
set term pngcairo size 800,600
set output "print.png"
replot
EOF