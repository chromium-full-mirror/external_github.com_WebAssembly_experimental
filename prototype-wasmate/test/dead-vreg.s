	.text
	.file	"/usr/local/google/home/binji/dev/github/wasm-experimental/prototype-wasmate/third_party/llvm/test/CodeGen/WebAssembly/dead-vreg.ll"
	.globl	foo
	.type	foo,@function
foo:
	.param  	i32, i32, i32
	.local  	i32, i32, i32, i32, i32, i32, i32, i32, i32
	i32.const	$5=, 1
	i32.lt_s	$push0=, $2, $5
	block   	BB0_5
	br_if   	$pop0, BB0_5
	i32.const	$push1=, 2
	i32.shl 	$3=, $4, $pop1
	i32.const	$6=, 0
	copy_local	$8=, $6
BB0_2:
	loop    	BB0_5
	i32.lt_s	$push2=, $4, $5
	copy_local	$9=, $6
	copy_local	$10=, $7
	copy_local	$11=, $4
	block   	BB0_4
	br_if   	$pop2, BB0_4
BB0_3:
	loop    	BB0_4
	i32.const	$push3=, -1
	i32.add 	$11=, $11, $pop3
	i32.store	$discard=, $10, $9
	i32.const	$push4=, 4
	i32.add 	$10=, $10, $pop4
	i32.ne  	$push5=, $11, $6
	i32.add 	$9=, $9, $8
	br_if   	$pop5, BB0_3
BB0_4:
	i32.add 	$8=, $8, $5
	i32.ne  	$push6=, $8, $2
	i32.add 	$7=, $7, $3
	br_if   	$pop6, BB0_2
BB0_5:
	return
func_end0:
	.size	foo, func_end0-foo


