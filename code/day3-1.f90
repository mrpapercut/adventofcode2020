program tobogganTrajectory
implicit none

    character(len=3100), dimension(323) :: rows
    character(len=3100) :: line
    character :: hit
    integer :: i, j
    integer :: trees = 0

    ! Open filehandler
    open(1, file= '../input/day3.txt', status= 'old')

    ! Read file into rows array
    do j=1,323
        read(1,'(A)') rows(j)
    end do
    
    ! Close filehandler
    close(1)

    ! Loop through the lines in steps 3 right, 1 down
    j = 1
    i = 1
    do while (j <= 323)
        line = rows(j)

        hit = line(i:i)

        if (hit == '#') then
            trees = trees + 1
        end if

        j = j + 1
        i = i + 3
    end do

    print *, trees

end program tobogganTrajectory
