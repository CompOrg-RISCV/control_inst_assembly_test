/*
 * control_test.s
 *
 *  Created on: April 1st, 2022
 *      Author: kgraham
 */

 // Section .crt0 is always placed from address 0
	.section .crt0, "ax"

_start:
	.global _start


/*********************************************************************************
 * Simple branch test including tests of clearing instruction after branch taken
 *********************************************************************************/
	addi x2, x0, 2			// Load 2 into x2 reg, 2 + 0 = 2
	nop
	nop
	nop
	beq x0, x2, FAIL		// x0=0, x2=2, so it should not branch
	addi x3, x0, 1			// check that x2 has been updated with the value 2 //x3 should be set to 1
	nop
	nop
	nop
	beq x0, x0, PASS1		// x=0, x=0, so branch to PASS1
	addi x4, x0, 1			// x3 = 1 // if x4 gets set to 1, the EX instruction was not cleared (NOP)
	nop
	nop
	nop
	halt					// If halt occurs, brnach instruction failed
/**************************************************************************
 * If reached this halt statement, test failure
 **************************************************************************/
 	nop
	nop
	nop
	nop
	nop
	nop
PASS2:
	nop
	nop
	nop
	nop
	halt
/**************************************************************************
 * Simple Jump instruction tests
 **************************************************************************/
 	nop						// x3 should equal to 1 since the branch beforehand was not taken
 	nop						// check here to ensure that x4 and x5 are not set, if set,
	nop						//      instruction in ID or EX stage was not cleared (NOP)
	nop						// If halts here, both positive and negative branches successful
	nop
	nop
	addi x2, x0, (RETURN1 & 0xfff)					// Save lower 12-bit return address in x2
	nop
	nop
	nop
	jal x1, JUMP1			// jump to positive offset and save return address, RETURN1 label into x1
RETURN1:
	nop
	nop
	nop
	nop
	jal x1, JUMP2
	nop
	nop
	nop
	nop
JUMP3:
	nop
	nop
	nop
	halt					// if code reaches this halt statement, and x10 = 1, your project has passed this test
/**************************************************************************
 * All tests for the control instruction tests have been completed
 **************************************************************************/
 	nop
	nop
	nop
	nop
	nop
JUMP2:
	nop
	nop
	jal x1, JUMP3			// testing negative offset jump
	nop
	nop
	nop
	nop
	nop
	halt					// if this halt is reached, there is an error in your jump routine
/**************************************************************************
 * If reached this halt statement, test failure
 **************************************************************************/
 	nop
	nop

PASS1:
	nop
	nop
	beq x0, x0, PASS2		// Testing negative offset branch
	nop
	addi x5, x0, 1			//if x5 gets set to 1, the ID instruction was not cleared (NOP)
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	halt					// reaching this break indicates a failure to branch on line 104
/**************************************************************************
 * Extra-credit Load test to validate structural hazard detected and stall
 **************************************************************************/
 	nop
	nop
	nop
	nop
	nop
	nop
JUMP1:
	addi x10, x0, 1			// Set x10 to 1 to validate jump to address is executed
	nop
	addi x3, x0, 0xff
	slli x3, x3, 4
	addi x3, x3, 0xf		// Set x3 to the mask of 0xfff
	and x3, x3, x1			// Save lower 12-bits of return address to compare with lower 12-bits of label
	nop
	nop
	nop
	nop
	nop
	bne	x3, x2, FAIL		// x2 = RETURN1.  Branch if not equal to fail
	nop
	nop
	nop
	nop
	nop
	jalr x1, 0(x1)				// Use return address saved from the jump to JUMP1

FAIL:
	nop
	nop
	nop
	nop
	nop
	halt
/**************************************************************************
 * If reached this halt statement, test failure
 **************************************************************************/
 	nop
	nop
	nop
	nop
	nop
