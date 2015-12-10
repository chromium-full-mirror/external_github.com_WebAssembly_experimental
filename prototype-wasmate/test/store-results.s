	.text
	.file	"/usr/local/google/home/binji/dev/github/wasm-experimental/prototype-wasmate/third_party/llvm/test/CodeGen/WebAssembly/store-results.ll"
	.globl	single_block
	.type	single_block,@function
single_block:
	.param  	i32
	.result 	i32
	i32.const	$push0=, 0
	i32.store	$push1=, 0($0), $pop0
	return  	$pop1
func_end0:
	.size	single_block, func_end0-single_block

	.globl	foo
	.type	foo,@function
foo:
	.local  	i32, i32
	i32.const	$0=, 0
	copy_local	$1=, $0
BB1_1:
	loop    	BB1_2
	i32.const	$push0=, pos
	i32.store	$discard=, 0($pop0), $0
	i32.const	$push1=, 1
	i32.add 	$1=, $1, $pop1
	i32.const	$push2=, 256
	i32.ne  	$push3=, $1, $pop2
	br_if   	$pop3, BB1_1
BB1_2:
	return
func_end1:
	.size	foo, func_end1-foo

	.globl	bar
	.type	bar,@function
bar:
	.local  	i32, f32
	i32.const	$0=, pos
	f32.const	$1=, 0x0p0
BB2_1:
	loop    	BB2_2
	i32.const	$push0=, 0
	i32.store	$discard=, 0($0), $pop0
	f32.const	$push1=, 0x1p0
	f32.add 	$1=, $1, $pop1
	f32.const	$push2=, 0x1p8
	f32.ne  	$push3=, $1, $pop2
	br_if   	$pop3, BB2_1
BB2_2:
	return
func_end2:
	.size	bar, func_end2-bar

	.type	pos,@object
	.data
	.globl	pos
	.align	2
pos:
	.zero	12
	.size	pos, 12


