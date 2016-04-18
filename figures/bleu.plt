#!/usr/bin/gnuplot -persist
set term postscript eps color
set size 0.7,0.7
set key right bottom
set style data linespoints
set style fill solid noborder
set xrange[10:250]
set logscale x
set xlabel 'Seconds / Sentence (log scale)'
set ylabel 'BLEU'
plot 'cost_b_n_early' using 4:2 title '(b,n)-early' lw 2, \
     'cost_b_n_late' using 4:2 title '(b,n)-late' lw 2,\
     'cost_b_e_n_early' using 4:2 title '(b,e,n)-early' lw 2,\
     'cost_b_e_n_late' using 4:2 title '(b,e,n)-late' lw 2
