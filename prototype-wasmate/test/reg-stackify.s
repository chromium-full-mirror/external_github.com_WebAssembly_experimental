	.text
	.file	"/usr/local/google/home/binji/dev/github/wasm-experimental/prototype-wasmate/third_party/llvm/test/CodeGen/WebAssembly/reg-stackify.ll"
	.globl	no0
	.type	no0,@function
no0:
	.param  	i32, i32
	.result 	i32
	i32.load	$1=, 0($1)
	i32.const	$push0=, 0
	i32.store	$discard=, 0($0), $pop0
	return  	$1
func_end0:
	.size	no0, func_end0-no0

	.globl	no1
	.type	no1,@function
no1:
	.param  	i32, i32
	.result 	i32
	i32.load	$1=, 0($1)
	i32.const	$push0=, 0
	i32.store	$discard=, 0($0), $pop0
	return  	$1
func_end1:
	.size	no1, func_end1-no1

	.globl	yes0
	.type	yes0,@function
yes0:
	.param  	i32, i32
	.result 	i32
	i32.const	$push1=, 0
	i32.store	$discard=, 0($0), $pop1
	i32.load	$push0=, 0($1)
	return  	$pop0
func_end2:
	.size	yes0, func_end2-yes0

	.globl	yes1
	.type	yes1,@function
yes1:
	.param  	i32
	.result 	i32
	i32.load	$push0=, 0($0)
	return  	$pop0
func_end3:
	.size	yes1, func_end3-yes1

	.globl	stack_uses
	.type	stack_uses,@function
stack_uses:
	.param  	i32, i32, i32, i32
	.result 	i32
	.local  	i32, i32
	i32.const	$4=, 1
	i32.const	$5=, 2
	i32.lt_s	$push0=, $0, $4
	i32.lt_s	$push1=, $1, $5
	i32.xor 	$push4=, $pop0, $pop1
	i32.lt_s	$push2=, $2, $4
	i32.lt_s	$push3=, $3, $5
	i32.xor 	$push5=, $pop2, $pop3
	i32.xor 	$push6=, $pop4, $pop5
	i32.ne  	$push7=, $pop6, $4
	block   	BB4_2
	br_if   	$pop7, BB4_2
	i32.const	$push8=, 0
	return  	$pop8
BB4_2:
	return  	$4
func_end4:
	.size	stack_uses, func_end4-stack_uses


