addi x1, x0, 1
addi x2, x0, 2
addi x3, x0, 3
addi x4, x0, 4

bne x0, x1, skip

addi x5, x0, 10
addi x5, x0, 10

skip: 

addi x5, x0, 20
addi x5, x0, 20

beq x0, x1, dontskip

addi x5, x0, 30
addi x5, x0, 30

dontskip:

addi x5, x0, 40
addi x5, x0, 40