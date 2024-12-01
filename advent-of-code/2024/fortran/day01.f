      program day01
       implicit none
       integer :: arr0(1000)
       integer :: arr1(1000)
       integer :: freqs(100000)
       integer :: i, j
       integer :: sum1, sum2
       integer :: tmp

       open (12, file="../inputs/day01", status="old")
       do i = 1, 1000, 1
        read (12, fmt="(I8,I8)") arr0(i), arr1(i)
        freqs(arr1(i)) = 1 + freqs(arr1(i))
       end do
       call my_sort(arr0,1000)
       call my_sort(arr1,1000)
       do i = 1, 1000, 1
        sum1 = sum1 + abs(arr0(i) - arr1(i))
        sum2 = sum2 + arr0(i) * freqs(arr0(i))
       end do

       print *, "Part 1: ", sum1
       print *, "Part 2: ", sum2
       close (12)

       contains

       subroutine my_sort(array, length)
         integer :: length
         integer :: array(length)
         do i = 1, length
           do j = 1, length
              if (array(i) < array(j)) then
               tmp = array(j)
               array(j) = array(i)
               array(i) = tmp
             end if
           end do
         end do
       end subroutine my_sort

      end program day01
