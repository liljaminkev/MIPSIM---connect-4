	.data
gridDisplay: .ascii "    _________________________\n"
 .ascii	"    |   |   |   |   |   |   |\n"
 .ascii	"    |   |   |   |   |   |   |\n"
 .ascii	"    |___|___|___|___|___|___|\n"
 .ascii	"    |   |   |   |   |   |   |\n"
 .ascii	"    |   |   |   |   |   |   |\n"
 .ascii	"    |___|___|___|___|___|___|\n"
 .ascii	"    |   |   |   |   |   |   |\n"
 .ascii	"    |   |   |   |   |   |   |\n"
 .ascii	"    |___|___|___|___|___|___|\n"
 .ascii	"    |   |   |   |   |   |   |\n"
 .ascii	"    |   |   |   |   |   |   |\n"
 .asciiz	"    |___|___|___|___|___|___|\n"

uwin: .asciiz "USER WINS!!"
cwin: .asciiz	"COMPUTER WINS!!"
tie: .asciiz	"GRID IS FULL. TIE!! "

blankChar:	.asciiz	" "
playerChar:	.asciiz "O"
compChar:	.asciiz "X"

compInput:	.asciiz "Computer chooses col "
grid: .space 24		# begins at an address that's a multiple of 4
colFull:	.asciiz "That col is full - please pick another spot: "
inputPrompt:	.asciiz "Please pick a number 1-6: "						
againMsg:	.asciiz	"PLAY AGAIN (Nonzero=YES, 0=NO)? "
welcome:	.asciiz	"WELCOME TO THE MIPSYM VERSION OF CONNECT-4!"
clear_prompt:	.asciiz "                                               "
	.code
	.globl main
main:
#	jal	resetdisplay		# clear the console
	jal	initialize_grid
	jal	print_game
	jal	userInput
	jal	computerInput
	syscall	$exit
	
resetdisplay:
# function code implementation
	addi	$a0,$0,'.		# clear screen character
	syscall	$print_char
	jr	$ra

##################################################
# function loads grid and sets all values to space
##################################################
initialize_grid:
	la	$t0,grid	#t0 = grid array
	la	$t2,blankChar	#load ascii 0
	addi	$t1,$0,24	#counter

#set arr to 0
	lb	$t3,($t2)		#x = '0'
1:	sb	$t3,($t0)		#store in to board
	addi	$t0,$t0,1
	addi	$t1,$t1,-1
	bgtz	$t1,1b

#print array
#	la	$a0,grid
#	syscall	$print_string
	
	jr	$ra



###############################################################################
# void print_game(void)
#
###############################################################################
# Description: 
# This function prints a 4 row-by-6 column grid onto the console. The grid lines
# are comprised of underscore characters separating the rows, and the vertical
# bar (ASCII byte 0x7C) separating the columns. Each grid cell has a height of
# 3 spaces in the vertical direction, and 3 spaces in the horizontal direction.
# The vertical bars forming the vertical boundaries of cells must be separated 4 spaces 
# from each one another. The underscore characters forming the horizontal boundaries
# of the cells must be separated by 3 rows from one another.
 
# The contents within each grid cell is stored in a 24-byte "grid" byte array. If
# a particular element of the "grid" array contains a value of 0, then the corresponding 
# grid cell is empty, and nothing is visually written into each cell. If an element
# contains a value of 1, then an "O" is placed in the center of a grid cell. If an 
# element contains a value of 2, then an "X" is placed in the center of the grid cell.

###############################################################################
#  Register usage: <list any t0-t9 registers used by the function>
###############################################################################

print_game:
	addi	$a0,$0,0	#set x = 0
	addi	$a1,$0,0	#set y = 0
	syscall	$xy		#set cursor at 0,0
	la	$a0,gridDisplay	#a0 = gridDisplay
	syscall	$print_string	#print gridDisplay
	
	addi	$a0,$0,35	#set x at 35
	addi	$a1,$0,5	#set y at 5
	syscall	$xy		#set cursor at 35,5
	
	la	$a0,welcome
	syscall	$print_string	#print message


# loop through grid array to place Os and Xs onto the console
	la	$t0,grid	#load grid array t0
	addi	$t1,$0,6	#Col counter = 6
	addi	$t4,$0,4	#row counter = 4
	addi	$t2,$0,6	#x pos
	addi	$t3,$0,2	#y pos

1:	
2:	add	$a0,$t2,$0	#load x
	add	$a1,$t3,$0	#load y
	syscall $xy		#move cursor
	lb	$a0,($t0)	#get piece from arr
	syscall	$print_char	#print game piece
	addi	$t2,$t2,4	#inc x by 4
	addi	$t0,$t0,1	#inc arr pointer
	addi	$t1,$t1,-1	#dec col counter
	
	bgtz	$t1,2b		#while col not 0
	
	addi	$t3,$t3,3	#inc row pos by 3
	addi	$t2,$0,6	#reset col pos back to 6
	addi	$t1,$0,6	#add 6 back to row counter
	addi	$t4,$t4,-1	#dec row counter
	bgtz	$t4,1b		#while row not 0
	jr	$ra

#######################################
#prompt user to enter a number from 1-6 
#prompt is printer on line 14
#######################################
userInput:
	add 	$a0,$0,$0
	addi 	$a1,$0,14
	syscall	$xy
	la	$a0,inputPrompt
	syscall $print_string
	syscall $read_int
	jr	$ra

########################################
#computer picks a number for col 1-6
########################################
computerInput:
	add 	$a0,$0,$0
	addi 	$a1,$0,14
	syscall	$xy
	la 	$a0,clear_prompt
	syscall	$print_string

	add 	$a0,$0,$0
	syscall	$xy
	
	addi	$t0,$0,7
	la	$a0,compInput
1:	syscall $print_string
	syscall $random
	and	$a0,$v0,$t0
	beq	$t0,$a0,1b
	beqz	$a0,1b
	syscall	$print_int
	jr	$ra


