set encoding utf8

set xlabel 'T/T_C'
set ylabel 'Calor específico'
set grid
set key r t 


p 'tmxiecv10.dat' u 1:(10*10*$5) w lp pt 11 dt 2 t 'L=10', \
  'tmxiecv20.dat' u 1:(20*20*$5) w lp pt 9  dt 2 t 'L=20', \
  'tmxiecv40.dat' u 1:(40*40*$5) w lp pt 7  dt 2 t 'L=40', \
  'tmxiecv128.dat' u 1:(128*128*$5) w lp pt 5 dt 2 t 'L=128'


set terminal postscript enhanced color eps 18
set output "graf-cv.eps"
rep
set terminal qt