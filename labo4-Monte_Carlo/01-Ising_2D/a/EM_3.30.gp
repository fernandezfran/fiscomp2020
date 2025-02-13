set encoding utf8

#set title 'T = 3.3'
set xlabel 'MC step'
set ylabel 'E/N, M/N'
set grid
set key r b 

set yrange [-2:1]
set xrange [0:150]
p 'EM_3.30-mess.dat' u 1:3 w lp pt 7 dt 2 t 'Magnetización T_{0} desorden', \
  'EM_3.30-order.dat' u 1:3 w lp pt 9 dt 2 t 'Magnetización T_{0} orden', \
  'EM_3.30-mess.dat' u 1:2 w lp pt 11 dt 2 t 'Energía T_{0} desorden', \
  'EM_3.30-order.dat' u 1:2 w lp pt 13 dt 2 t 'Energía T_{0} orden'

set terminal postscript enhanced color eps 18
set output "EM_3.30.eps"
rep
set terminal qt
