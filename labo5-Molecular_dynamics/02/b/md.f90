program md_lj
!Dinámica molecular en un sistema de Lennard-Jones en el ensamble
! microcanónico con reescaleo de velocidades
use precision, only  : pr        => dp
use initialization
use force, only      : forces    => forcelj126
use integrator, only : integrate => velocityverlet
use comp_exp 
implicit none
real(pr)             :: t, ti, Tsf, tail, S
integer              :: i, teq, trun, j

!### definición de parámetros iniciales
N      = 500
rho    = 0.8_pr
T0     = 1.0_pr
V      = real(N,pr)/rho
L      = V**(1._pr/3._pr)
dt     = 0.0005_pr
rcut   = 2.5_pr
ecut = 4._pr*(1._pr/(rcut**12) - 1._pr/(rcut**6))
tail = 4._pr*pi43*rho*( (2._pr/3._pr)*(1._pr/(rcut**9)) - (1._pr/(rcut**3)) )
Etail  = tail*real(N,pr)
Ptail  = tail*rho

allocate( x(N), y(N), z(N) )
allocate( ix(N), iy(N), iz(N) ) !imagen de caja en la que está la part
allocate( vx(N), vy(N), vz(N) )
allocate( fx(N), fy(N), fz(N) )

call initposfcc              !posiciones iniciales e imagenes 0
call initvelrand             !velocidades iniciales
call forces                  !fuerzas iniciales
!

!###
!
teq   = 2000
trun  = 20000
ti = 0._pr
!

open(36, file='trajectory.xyz', status='replace')
write(36,*) N; write(36,*) !write xyz
do j = 1, N; write(36,'(A,3(E15.6,2x))') 'Ar', x(j), y(j), z(j); enddo

open(47, file='thermo.dat', status='replace')
write(47,'(A,I4)') '# numero de partículas   : ', N
write(47,'(A,F6.4)') '# densidad               : ', rho
write(47,'(A,F6.4)') '# temperatura inicial    : ', T0
write(47,'(A,E9.3)') '# volumen                : ', V
write(47,'(A,F6.4)') '# rcut                   : ', rcut
write(47,'(A,F6.4)') '# paso temporal          : ', dt
write(47,'(A,I4)') '# pasos de equilibración : ', teq
write(47,'(A,I4)') '# pasos de medición      : ', trun
write(47,'(A)') '# t, Sk'

!### loop de equilibración
t = ti
        call structfact(S)
        write(*,'(2(E15.6))') t, S
do i = 1, teq
    call integrate    !con cálculo de fuerzas

    !reescaleo las velocidades
    Tsf = sqrt( T0/Temp )
    vx(:) = Tsf*vx(:)
    vy(:) = Tsf*vy(:)
    vz(:) = Tsf*vz(:)
    
    if (mod(i,100) == 0) then !: write thermo & trajectory
        write(36,*) N; write(36,*)
        do j = 1, N; write(36,'(A,3(E15.6,2x))') 'Ar', x(j), y(j), z(j); enddo
    endif

    t = ti + real(i,pr)*dt
enddo

!### loop de medición
do i = teq + 1, teq + trun
    call integrate
    
    !reescaleo de velocidades
    Tsf = sqrt( T0/Temp )
    vx(:) = Tsf*vx(:)
    vy(:) = Tsf*vy(:)
    vz(:) = Tsf*vz(:)
    
    if (mod(i,100) == 0) then !: write thermo & trajectory & medir Sk
        call structfact(S)
        write(47,'(2(E15.6))') t, S
        write(36,*) N; write(36,*)
        do j = 1, N; write(36,'(A,3(E15.6,2x))') 'Ar', x(j), y(j), z(j); enddo
    endif

    t = ti + real(i,pr)*dt
enddo


end program
