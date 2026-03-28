// mult.asm
// calculate R2 = R0 * R1
// and check the result.

// Load test data: R0 = 13, R1 = 55, R2 = 42
// and set LED to 01 (nothing calculated yet!)
@13
D=A
@R0
MD=D
@DEBUG0
M=D

@55
D=A
@R1
MD=D
@DEBUG1
M=D

@42
D=A
@R2
MD=D
@DEBUG2
M=D

@LED
M=1

// Put your code here:
// R2 = R0 * R1 (repeated addition)
// R2 = 0
@R2
M=0

(LOOP)
  // if R1 == 0, goto END
  @R1
  D=M
  @END
  D;JEQ

  // R2 = R2 + R0
  @R0
  D=M
  @R2
  M=D+M

  // R1 = R1 - 1
  @R1
  M=M-1

  // goto LOOP
  @LOOP
  0;JMP


// till here!

// Check result according to
// LED = 2 (correct result)
// LED = 3 (wrong result)
// and HALT
(END)
@R2
D=M
@715
D=D-A
@OK
D;JEQ

(NOK)
@3
D=A
@LED
M=D
@HALT
0;JMP

(OK)
@2
D=A
@LED
M=D

(HALT)
@HALT
0;JMP
