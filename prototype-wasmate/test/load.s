	.text
	.file	"/s/llvm/llvm/test/CodeGen/WebAssembly/load.ll"
	.globl	ldi32
	.type	ldi32,@function
ldi32:                                  # @ldi32
	.param  	i32
	.result 	i32
# BB#0:
	i32.load	$push0=, 0($0)
	return  	$pop0
func_end0:
	.size	ldi32, func_end0-ldi32

	.globl	ldi64
	.type	ldi64,@function
ldi64:                                  # @ldi64
	.param  	i32
	.result 	i64
# BB#0:
	i64.load	$push0=, 0($0)
	return  	$pop0
func_end1:
	.size	ldi64, func_end1-ldi64

	.globl	ldf32
	.type	ldf32,@function
ldf32:                                  # @ldf32
	.param  	i32
	.result 	f32
# BB#0:
	f32.load	$push0=, 0($0)
	return  	$pop0
func_end2:
	.size	ldf32, func_end2-ldf32

	.globl	ldf64
	.type	ldf64,@function
ldf64:                                  # @ldf64
	.param  	i32
	.result 	f64
# BB#0:
	f64.load	$push0=, 0($0)
	return  	$pop0
func_end3:
	.size	ldf64, func_end3-ldf64


	.section	".note.GNU-stack","",@progbits
