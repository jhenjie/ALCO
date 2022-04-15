.globl  main
.data 
	Input:	.string "Input a number:\n"
	Output:	.string "The damage:\n"
.text
main:
	# print "Input a number:\n"
	la a0 , Input
	li a7 , 4
	ecall
	
	# read input number
	li a7 , 5
	ecall
	
	# store input number
	mv t1 , a0 
	
	# call function to calculate damage
	jal function
	j end
end:
	# print "The damage:\n"
	la a0 , Output
	li a7 , 4
	ecall
	
	# print result
	mv a0 , t1
	li a7 , 1
	ecall
	
	# exit
	li a7 , 10
	ecall	
function:
	# store return address and current t1 value in stack
	addi sp , sp , -16
	sw ra , 8( sp )
	sw t1 , 0( sp )

	# set up the value used to determine which case to execute
	addi t4 , zero , 20
	addi t5 , zero , 10
	addi t6 , zero , 1
	
	# branch to different case
	bgt t1 , t4 , GT20
	bgt t1 , t5 , GT10
	bgt t1 , t6 , GT1 
	beq t1 , t6 , EQ1
	beq t1 , zero , EQ0
	blt t1 , zero , LT0
GT20:    
	# calculate x*2
         slli t2 , t1 , 1
         addi sp , sp , -8
         sw t2 , 0( sp )
         
         # calculate F(x/5)
         addi t3 , zero , 5
         div t1 , t1 , t3
         jal function
         add t3 , zero , t1
         addi sp , sp , -8
         sw t3 , 0( sp )
         
         # calculate x*2 + F(x/5)
         lw t2 , 8( sp )
         lw t3 , 0( sp )
         addi x2 , x2 , 16  
         add t1 , t2 , t3
         
         # return
         lw t0 , 8( sp )
	addi x2 , x2 , 16
	jalr t0 
GT10:        
	# calculate F(x-2)
         addi t1 , t1 , -2
         jal function
         add t2 , zero , t1
         addi sp , sp , -8
         sw t2 , 0( sp )
        
         # calculate F(x-3)
         lw t1 , 8( sp )
         addi t1 , t1 , -3
         jal function
         add t3 , zero , t1
         addi sp , sp , -8
         sw t3 , 0( sp )
         
         # calculate F(x-2) + F(x-3)
         lw t2 , 8( sp )
         lw t3 , 0( sp )
         addi x2 , x2 , 16 
         add t1 , t2 , t3
         
         # return
         lw t0 , 8( sp )
	addi x2 , x2 , 16
	jalr t0 
GT1:  
	# calculate F(x-1)
         addi t1 , t1 , -1
         jal function
         add t2 , zero , t1 
         addi sp , sp , -8
         sw t2 , 0( sp )
         
         # calculate F(x-2)
         lw t1 , 8( sp )
         addi t1 , t1 , -2
         jal function
         add t3 , zero , t1
         addi sp , sp , -8
         sw t3 , 0( sp )
         
         # calculate F(x-1) + F(x-2)
         lw t2 , 8( sp )
         lw t3 , 0( sp )
         addi x2 , x2 , 16
         add t1 , t2 , t3
         
         # return
         lw t0 , 8( sp )
	addi x2 , x2 , 16
	jalr t0 
EQ1:  
	# set up return value = 5
         addi t1 , zero , 5
         
         # return
         lw t0 , 8( sp )
	addi x2 , x2 , 16
	jalr t0 
EQ0: 
	# set up return value = 1
         addi t1 , zero , 1
         
         # return
       	lw t0 , 8( sp )
	addi x2 , x2 , 16
	jalr t0 
LT0:
	# set up return value = -1
	addi t1 , zero , -1
         
         # return
       	lw t0 , 8( sp )
	addi x2 , x2 , 16
	jalr t0 
