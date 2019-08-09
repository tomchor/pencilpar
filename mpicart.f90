program cartesian
include 'mpif.h'

integer SIZE, UP, DOWN, LEFT, RIGHT
parameter(SIZE=9)
parameter(UP=1)
parameter(DOWN=2)
parameter(LEFT=3)
parameter(RIGHT=4)
integer numtasks, rank, source, dest, outbuf, i, tag, ierr, &
        inbuf(4), nbrs(4), dims(2), coords(2), periods(2), reorder
integer stats(MPI_STATUS_SIZE, 8), reqs(8)
integer cartcomm   ! required variable
data inbuf /MPI_PROC_NULL,MPI_PROC_NULL,MPI_PROC_NULL,MPI_PROC_NULL/, &
     tag /1/, periods /1,1/, reorder /0/ 
dims = [ int(sqrt(real(size))), int(sqrt(real(size))) ]

call MPI_INIT(ierr)
call MPI_COMM_SIZE(MPI_COMM_WORLD, numtasks, ierr)
  
if (numtasks .eq. SIZE) then
   ! create cartesian virtual topology, get rank, coordinates, neighbor ranks
   call MPI_CART_CREATE(MPI_COMM_WORLD, 2, dims, periods, reorder, &
                        cartcomm, ierr)
   call MPI_COMM_RANK(cartcomm, rank, ierr)
   call MPI_CART_COORDS(cartcomm, rank, 2, coords, ierr)
   call MPI_CART_SHIFT(cartcomm, 0, 1, nbrs(UP), nbrs(DOWN), ierr)
   call MPI_CART_SHIFT(cartcomm, 1, 1, nbrs(LEFT), nbrs(RIGHT), ierr)

   write(*,20) rank,coords(1),coords(2),nbrs(UP),nbrs(DOWN), &
               nbrs(LEFT),nbrs(RIGHT)

else
  print *, 'Must specify',SIZE,' processors.  Terminating.' 
endif

call MPI_FINALIZE(ierr)

20 format('rank= ',I3,' coords= ',I2,I2, &
          ' neighbors(u,d,l,r)= ',I3,I3,I3,I3 )

end



