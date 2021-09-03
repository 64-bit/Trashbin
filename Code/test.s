addi x1, x0, 1
sw x1, 1000(x0)

addi x1, x0, 2
sw x1, 1004(x0)

addi x1, x0, 3
sw x1, 1008(x0)

addi x1, x0, 4
sw x1, 1012(x0) 

addi x1, x0, 100

lw x2, 1012(x0)
add x0, x1, x2

lw x2, 1008(x0) 
add x0, x1, x2

lw x2, 1004(x0) 
add x0, x1, x2

lw x2, 1000(x0) 
add x0, x1, x2
