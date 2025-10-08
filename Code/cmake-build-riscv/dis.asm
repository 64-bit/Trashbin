
/home/FemboyWarlord/repos/Trashbin/Code/cmake-build-riscv/output/firmware_no_comments.elf:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00010117          	auipc	sp,0x10
   4:	00010113          	mv	sp,sp
   8:	008000ef          	jal	10 <main>
   c:	0000006f          	j	c <_start+0xc>

00000010 <main>:
  10:	000106b7          	lui	a3,0x10
  14:	0106a783          	lw	a5,16(a3) # 10010 <_stack_top+0x10>
  18:	01068693          	addi	a3,a3,16
  1c:	0017f793          	andi	a5,a5,1
  20:	02079463          	bnez	a5,48 <main+0x38>
  24:	00010637          	lui	a2,0x10
  28:	00460613          	addi	a2,a2,4 # 10004 <_stack_top+0x4>
  2c:	00000713          	li	a4,0
  30:	40875793          	srai	a5,a4,0x8
  34:	00f62023          	sw	a5,0(a2)
  38:	0006a783          	lw	a5,0(a3)
  3c:	00170713          	addi	a4,a4,1
  40:	0017f793          	andi	a5,a5,1
  44:	fe0786e3          	beqz	a5,30 <main+0x20>
  48:	00010637          	lui	a2,0x10
  4c:	00060693          	mv	a3,a2
  50:	00868693          	addi	a3,a3,8
  54:	00460613          	addi	a2,a2,4 # 10004 <_stack_top+0x4>
  58:	00000793          	li	a5,0
  5c:	000105b7          	lui	a1,0x10
  60:	4087d713          	srai	a4,a5,0x8
  64:	00e5a023          	sw	a4,0(a1) # 10000 <_stack_top>
  68:	4107d713          	srai	a4,a5,0x10
  6c:	00e62023          	sw	a4,0(a2)
  70:	00e6a023          	sw	a4,0(a3)
  74:	00178793          	addi	a5,a5,1
  78:	fe9ff06f          	j	60 <main+0x50>

Disassembly of section .riscv.attributes:

00000000 <.riscv.attributes>:
   0:	1b41                	.insn	2, 0x1b41
   2:	0000                	.insn	2, 0x
   4:	7200                	.insn	2, 0x7200
   6:	7369                	.insn	2, 0x7369
   8:	01007663          	bgeu	zero,a6,14 <main+0x4>
   c:	0011                	.insn	2, 0x0011
   e:	0000                	.insn	2, 0x
  10:	1004                	.insn	2, 0x1004
  12:	7205                	.insn	2, 0x7205
  14:	3376                	.insn	2, 0x3376
  16:	6932                	.insn	2, 0x6932
  18:	7032                	.insn	2, 0x7032
  1a:	0031                	.insn	2, 0x0031
