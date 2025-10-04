# crt0.S — minimal RISC-V startup for bare-metal RV32I

    .section .init
    .globl _start
_start:
    la sp, _stack_top        # initialize stack pointer
    call main                # call C main()
1:  j 1b                     # infinite loop if main returns