	.text
	.file	"/usr/local/google/home/binji/dev/github/wasm-experimental/prototype-wasmate/third_party/llvm/test/CodeGen/WebAssembly/reg-stackify.ll"
	.globl	no0
	.type	no0,@function
no0:
	.param  	i32, i32
	.result 	i32
	i32.load	$1=, $1
	i32.const	$push0=, 0
	i32.store	$discard=, $0, $pop0
	return  	$1
func_end0:
	.size	no0, func_end0-no0

	.globl	no1
	.type	no1,@function
no1:
	.param  	i32, i32
	.result 	i32
	i32.load	$1=, $1
	i32.const	$push0=, 0
	i32.store	$discard=, $0, $pop0
	return  	$1
func_end1:
	.size	no1, func_end1-no1

	.globl	yes0
	.type	yes0,@function
yes0:
	.param  	i32, i32
	.result 	i32
	i32.const	$push1=, 0
	i32.store	$discard=, $0, $pop1
	i32.load	$push0=, $1
	return  	$pop0
func_end2:
	.size	yes0, func_end2-yes0

	.globl	yes1
	.type	yes1,@function
yes1:
	.param  	i32
	.result 	i32
	i32.load	$push0=, $0
	return  	$pop0
func_end3:
	.size	yes1, func_end3-yes1


