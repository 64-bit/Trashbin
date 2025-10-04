
firmware:     file format elf32-littleriscv


Disassembly of section .text:

00000000 <_start>:
   0:	00010117          	auipc	sp,0x10
   4:	00010113          	mv	sp,sp
   8:	008000ef          	jal	10 <main>
   c:	0000006f          	j	c <_start+0xc>

00000010 <main>:
  10:	04402603          	lw	a2,68(zero) # 44 <LED_Red>
  14:	04802583          	lw	a1,72(zero) # 48 <LED_Green>
  18:	04002683          	lw	a3,64(zero) # 40 <HexDisplay>
  1c:	00000793          	li	a5,0
  20:	00f5a023          	sw	a5,0(a1)
  24:	4087d713          	srai	a4,a5,0x8
  28:	00e62023          	sw	a4,0(a2)
  2c:	00f6a023          	sw	a5,0(a3)
  30:	00178793          	addi	a5,a5,1
  34:	fedff06f          	j	20 <main+0x10>

Disassembly of section .sdata:

00000038 <Keys>:
  38:	1004                	.insn	2, 0x1004
  3a:	0001                	.insn	2, 0x0001

0000003c <Switches>:
  3c:	1000                	.insn	2, 0x1000
  3e:	0001                	.insn	2, 0x0001

00000040 <HexDisplay>:
  40:	0008                	.insn	2, 0x0008
  42:	0001                	.insn	2, 0x0001

00000044 <LED_Red>:
  44:	0004                	.insn	2, 0x0004
  46:	0001                	.insn	2, 0x0001

00000048 <LED_Green>:
  48:	0000                	.insn	2, 0x
  4a:	0001                	.insn	2, 0x0001

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

Disassembly of section .comment:

00000000 <.comment>:
   0:	3a434347          	.insn	4, 0x3a434347
   4:	2820                	.insn	2, 0x2820
   6:	7241                	.insn	2, 0x7241
   8:	55206863          	bltu	zero,s2,558 <LED_Green+0x510>
   c:	20726573          	.insn	4, 0x20726573
  10:	6552                	.insn	2, 0x6552
  12:	6f70                	.insn	2, 0x6f70
  14:	6f746973          	.insn	4, 0x6f746973
  18:	7972                	.insn	2, 0x7972
  1a:	2029                	.insn	2, 0x2029
  1c:	3431                	.insn	2, 0x3431
  1e:	322e                	.insn	2, 0x322e
  20:	302e                	.insn	2, 0x302e
	...
