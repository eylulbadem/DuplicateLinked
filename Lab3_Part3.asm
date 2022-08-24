##	CS224 - Lab 3, Part 3
##	Section 3 
##	Eylül Badem - 22003079
##	14.03.2022
##
## Lab3_Part3.asm  duplicates and prints the linked list recursively
##
##	v0 - reads user input
##	t0 - holds array
##	a0 - points to output
##

###############################
#				#
#	text segment		#
#				#
###############################

	.text		
	.globl __start	

__start: 				# execution starts here
	
	li	$s1, 0
	li	$a0, 10 	#create a linked list with 10 nodes
	jal	createLinkedList
	
	# Linked list is pointed by $v0
	move	$s7, $v0	# Pass the linked list address in $a0
	move	$a0, $v0	# Pass the linked list address in $a0
	jal	printLinkedList
	
        la $a0, endl #print a space
        li $v0, 4
        syscall
	la $a0, cut #print a space
        li $v0, 4
        syscall
        la $a0, endl #print a space
        li $v0, 4
        syscall
        
	li	$a1, 10
	li	$s1, 0
	move	$a0, $s7	# Pass the linked list address in $a0 
	
   	jal duplicateListRecursive
   	
	move	$a0, $v1	# Pass the linked list address in $a0
	
	# Stop. 
	li	$v0, 10
	syscall
	
#----------------------------------------------------------------------

createLinkedList:
# $a0: No. of nodes to be created ($a0 >= 1)
# $v0: returns list head
# Node 1 contains 4 in the data field, node i contains the value 4*i in the data field.
# By 4*i inserting a data value like this
# when we print linked list we can differentiate the node content from the node sequence no (1, 2, ...).
	addi	$sp, $sp, -24
	sw	$s0, 20($sp)
	sw	$s1, 16($sp)
	sw	$s2, 12($sp)
	sw	$s3, 8($sp)
	sw	$s4, 4($sp)
	sw	$ra, 0($sp) 	# Save $ra just in case we may want to call a subprogram
	
	move	$s0, $a0	# $s0: no. of nodes to be created.
	li	$s1, 1		# $s1: Node counter
# Create the first node: header.
# Each node is 8 bytes: link field then data field.
	li	$a0, 8
	li	$v0, 9
	syscall
# OK now we have the list head. Save list head pointer 
	move	$s2, $v0	# $s2 points to the first and last node of the linked list.
	move	$s3, $v0	# $s3 now points to the list head.
	sll	$s4, $s1, 2	
# sll: So that node 1 data value will be 4, node i data value will be 4*i
	sw	$s4, 4($s2)	# Store the data value.
	
addNode:
# Are we done?
# No. of nodes created compared with the number of nodes to be created.
	beq	$s1, $s0, allDone
	addi	$s1, $s1, 1	# Increment node counter.
	li	$a0, 8 		# Remember: Node size is 8 bytes.
	li	$v0, 9
	syscall
# Connect the this node to the lst node pointed by $s2.
	sw	$v0, 0($s2)
# Now make $s2 pointing to the newly created node.
	move	$s2, $v0	# $s2 now points to the new node.
	sll	$s4, $s1, 2	
# sll: So that node 1 data value will be 4, node i data value will be 4*i
	sw	$s4, 4($s2)	# Store the data value.
	j	addNode
allDone:
# Make sure that the link field of the last node cotains 0.
# The last node is pointed by $s2.
	#sw	$zero, 0($s2)
	move	$v0, $s3	# Now $v0 points to the list head ($s3).
	
# Restore the register values
	lw	$ra, 0($sp)
	lw	$s4, 4($sp)
	lw	$s3, 8($sp)
	lw	$s2, 12($sp)
	lw	$s1, 16($sp)
	lw	$s0, 20($sp)
	addi	$sp, $sp, 24
	
	jr	$ra
	
#--------------------------------------------------------------------

duplicateListRecursive:
# $a0: No. of nodes to be created ($a0 >= 1)
# $v0: returns list head
# Node 1 contains 4 in the data field, node i contains the value 4*i in the data field.
# By 4*i inserting a data value like this
# when we print linked list we can differentiate the node content from the node sequence no (1, 2, ...).
	addi	$sp, $sp, -24
	sw	$s0, 20($sp)
	sw	$s1, 16($sp)
	sw	$s5, 12($sp)
	sw	$s6, 8($sp)
	sw	$s4, 4($sp)
	sw	$ra, 0($sp) 	# Save $ra just in case we may want to call a subprogram
	
	move	$s0, $a1	# $s0: no. of nodes to be created.
	
	addi	$s1, $s1, 1	# Increment node counter.
	bne	$s1, 11, recursive
# Create the first node: header.
	
# Are we done?
# No. of nodes created compared with the number of nodes to be created.
base:
	addi	$sp, $sp, 24
	jr	$ra 
	
recursive:
	bne	$s1,1,here
	
	first:
	
	li	$a0, 8 		# Remember: Node size is 8 bytes.
	li	$v0, 9
	syscall
	
	move	$s5, $v0	# $s5 points to the first and last node of the linked list.
	move	$s6, $v0	# $s6 now points to the list head.
	lw	$s4, 4($s7)	
	sw	$s4, 0($s5)	# Store the data value.
	
	jal myPrint
	addi $s1,$s1,1
	
	here:
	lw	$s3, 0($s7)
	move 	$s7, $s3
	
	li	$a0, 8 		# Remember: Node size is 8 bytes.
	li	$v0, 9
	syscall
# Connect the this node to the lst node pointed by $s5.
	sw	$v0, 0($s5)
# Now make $s5 pointing to the newly created node.
	move	$s5, $v0	# $s5 now points to the new node.
	lw	$s4, 4($s7)	
	sw	$s4, 0($s5)	# Store the data value.
	
	jal myPrint
	
	jal	duplicateListRecursive
	
allDone1:
# Make sure that the link field of the last node cotains 0.
# The last node is pointed by $s2.
	#sw	$zero, 0($s5)
	move	$v1, $s6	# Now $v1 points to the list head ($s3).
	
# Restore the register values
	lw	$ra, 0($sp)
	lw	$s4, 4($sp)
	lw	$s6, 8($sp)
	lw	$s5, 12($sp)
	lw	$s1, 16($sp)
	lw	$s0, 20($sp)
	addi	$sp, $sp, 24
	
	jr	$ra 

#-------------------------------------------------------------

printLinkedList:
# Print linked list nodes in the following format
# --------------------------------------
# Node No: xxxx (dec)
# Address of Current Node: xxxx (hex)
# Address of Next Node: xxxx (hex)
# Data Value of Current Node: xxx (dec)
# --------------------------------------

# Save $s registers used
	addi	$sp, $sp, -20
	sw	$s0, 16($sp)
	sw	$s1, 12($sp)
	sw	$s2, 8($sp)
	sw	$s3, 4($sp)
	sw	$ra, 0($sp) 	# Save $ra just in case we may want to call a subprogram

# $a0: points to the linked list.
# $s0: Address of current
# s1: Address of next
# $2: Data of current
# $s3: Node counter: 1, 2, ...
	move $s0, $a0	# $s0: points to the current node.
	li   $s3, 0
printNextNode:
	beq	$s0, $zero, printedAll
				# $s0: Address of current node
	lw	$s1, 0($s0)	# $s1: Address of  next node
	lw	$s2, 4($s0)	# $s2: Data of current node
	addi	$s3, $s3, 1
# $s0: address of current node: print in hex.
# $s1: address of next node: print in hex.
# $s2: data field value of current node: print in decimal.
	la	$a0, line
	li	$v0, 4
	syscall		# Print line seperator
	
	la	$a0, nodeNumberLabel
	li	$v0, 4
	syscall
	
	move	$a0, $s3	# $s3: Node number (position) of current node
	li	$v0, 1
	syscall
	
	la	$a0, addressOfCurrentNodeLabel
	li	$v0, 4
	syscall
	
	move	$a0, $s0	# $s0: Address of current node
	li	$v0, 34
	syscall

	la	$a0, addressOfNextNodeLabel
	li	$v0, 4
	syscall
	move	$a0, $s1	# $s0: Address of next node
	li	$v0, 34
	syscall	
	
	la	$a0, dataValueOfCurrentNode
	li	$v0, 4
	syscall
		
	move	$a0, $s2	# $s2: Data of current node
	li	$v0, 1		
	syscall	

# Now consider next node.
	move	$s0, $s1	# Consider next node.
	j	printNextNode
printedAll:
# Restore the register values
	lw	$ra, 0($sp)
	lw	$s3, 4($sp)
	lw	$s2, 8($sp)
	lw	$s1, 12($sp)
	lw	$s0, 16($sp)
	addi	$sp, $sp, 20
	jr	$ra

myPrint:

	la	$a0, line
	li	$v0, 4
	syscall		# Print line seperator
	
	la	$a0, nodeNumberLabel
	li	$v0, 4
	syscall
	
	move	$a0, $s1	# $s3: Node number (position) of current node
	li	$v0, 1
	syscall
	
	la	$a0, addressOfCurrentNodeLabel
	li	$v0, 4
	syscall
	
	move	$a0, $s5	# $s0: Address of current node
	li	$v0, 34
	syscall

	la	$a0, addressOfNextNodeLabel
	li	$v0, 4
	syscall
	move	$a0, $s3	# $s0: Address of next node
	li	$v0, 34
	syscall	
	
	la	$a0, dataValueOfCurrentNode
	li	$v0, 4
	syscall
		
	move	$a0, $s4	# $s2: Data of current node
	li	$v0, 1		
	syscall	
	
	jr $ra	
	
###############################
#				#
#     	 data segment		#
#				#
###############################

	.data
space: 		.asciiz " "
endl:		.asciiz "\n"
cut:		.asciiz "##################################################################"
line:	
	.asciiz "\n --------------------------------------"

nodeNumberLabel:
	.asciiz	"\n Node No.: "
	
addressOfCurrentNodeLabel:
	.asciiz	"\n Address of Current Node: "
	
addressOfNextNodeLabel:
	.asciiz	"\n Address of Next Node: "
	
dataValueOfCurrentNode:
	.asciiz	"\n Data Value of Current Node: "

##
## end of file Lab3_Part3.asm 
