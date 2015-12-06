	.text
	.file	"/usr/local/google/home/binji/dev/github/wasm-experimental/prototype-wasmate/third_party/llvm/test/CodeGen/WebAssembly/cfg-stackify.ll"
	.globl	test0
	.type	test0,@function
test0:
	.param  	i32
	.local  	i32
	i32.const	$1=, 0
BB0_1:
	loop    	BB0_3
	i32.const	$push0=, 1
	i32.add 	$1=, $1, $pop0
	i32.ge_s	$push1=, $1, $0
	br_if   	$pop1, BB0_3
	call    	something
	br      	BB0_1
BB0_3:
	return
func_end0:
	.size	test0, func_end0-test0

	.globl	test1
	.type	test1,@function
test1:
	.param  	i32
	.local  	i32
	i32.const	$1=, 0
BB1_1:
	loop    	BB1_3
	i32.const	$push0=, 1
	i32.add 	$1=, $1, $pop0
	i32.ge_s	$push1=, $1, $0
	br_if   	$pop1, BB1_3
	call    	something
	br      	BB1_1
BB1_3:
	return
func_end1:
	.size	test1, func_end1-test1

	.globl	test2
	.type	test2,@function
test2:
	.param  	i32, i32
	i32.const	$push0=, 1
	i32.lt_s	$push1=, $1, $pop0
	block   	BB2_2
	br_if   	$pop1, BB2_2
BB2_1:
	loop    	BB2_2
	f64.load	$push2=, 0($0)
	f64.const	$push3=, 0x1.999999999999ap1
	f64.mul 	$push4=, $pop2, $pop3
	f64.store	$discard=, 0($0), $pop4
	i32.const	$push5=, -1
	i32.add 	$1=, $1, $pop5
	i32.const	$push6=, 8
	i32.add 	$0=, $0, $pop6
	br_if   	$1, BB2_1
BB2_2:
	return
func_end2:
	.size	test2, func_end2-test2

	.globl	doublediamond
	.type	doublediamond,@function
doublediamond:
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32
	i32.const	$push0=, 0
	i32.store	$3=, 0($2), $pop0
	block   	BB3_5
	block   	BB3_2
	br_if   	$0, BB3_2
	i32.const	$push4=, 1
	i32.store	$discard=, 0($2), $pop4
	br      	BB3_5
BB3_2:
	i32.const	$push1=, 2
	i32.store	$discard=, 0($2), $pop1
	block   	BB3_4
	br_if   	$1, BB3_4
	i32.const	$push3=, 3
	i32.store	$discard=, 0($2), $pop3
	br      	BB3_5
BB3_4:
	i32.const	$push2=, 4
	i32.store	$discard=, 0($2), $pop2
BB3_5:
	i32.const	$push5=, 5
	i32.store	$discard=, 0($2), $pop5
	return  	$3
func_end3:
	.size	doublediamond, func_end3-doublediamond

	.globl	triangle
	.type	triangle,@function
triangle:
	.param  	i32, i32
	.result 	i32
	.local  	i32
	i32.const	$push0=, 0
	i32.store	$2=, 0($0), $pop0
	block   	BB4_2
	br_if   	$1, BB4_2
	i32.const	$push1=, 1
	i32.store	$discard=, 0($0), $pop1
BB4_2:
	i32.const	$push2=, 2
	i32.store	$discard=, 0($0), $pop2
	return  	$2
func_end4:
	.size	triangle, func_end4-triangle

	.globl	diamond
	.type	diamond,@function
diamond:
	.param  	i32, i32
	.result 	i32
	.local  	i32
	i32.const	$push0=, 0
	i32.store	$2=, 0($0), $pop0
	block   	BB5_3
	block   	BB5_2
	br_if   	$1, BB5_2
	i32.const	$push2=, 1
	i32.store	$discard=, 0($0), $pop2
	br      	BB5_3
BB5_2:
	i32.const	$push1=, 2
	i32.store	$discard=, 0($0), $pop1
BB5_3:
	i32.const	$push3=, 3
	i32.store	$discard=, 0($0), $pop3
	return  	$2
func_end5:
	.size	diamond, func_end5-diamond

	.globl	single_block
	.type	single_block,@function
single_block:
	.param  	i32
	.result 	i32
	i32.const	$push0=, 0
	i32.store	$push1=, 0($0), $pop0
	return  	$pop1
func_end6:
	.size	single_block, func_end6-single_block

	.globl	minimal_loop
	.type	minimal_loop,@function
minimal_loop:
	.param  	i32
	.result 	i32
	i32.const	$push0=, 0
	i32.store	$discard=, 0($0), $pop0
BB7_1:
	loop    	BB7_2
	i32.const	$push1=, 1
	i32.store	$discard=, 0($0), $pop1
	br      	BB7_1
BB7_2:
func_end7:
	.size	minimal_loop, func_end7-minimal_loop

	.globl	simple_loop
	.type	simple_loop,@function
simple_loop:
	.param  	i32, i32
	.result 	i32
	.local  	i32
	i32.const	$push0=, 0
	i32.store	$2=, 0($0), $pop0
BB8_1:
	loop    	BB8_2
	i32.const	$push1=, 1
	i32.store	$discard=, 0($0), $pop1
	i32.const	$push3=, 0
	i32.eq  	$push4=, $1, $pop3
	br_if   	$pop4, BB8_1
BB8_2:
	i32.const	$push2=, 2
	i32.store	$discard=, 0($0), $pop2
	return  	$2
func_end8:
	.size	simple_loop, func_end8-simple_loop

	.globl	doubletriangle
	.type	doubletriangle,@function
doubletriangle:
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32
	i32.const	$push0=, 0
	i32.store	$3=, 0($2), $pop0
	block   	BB9_4
	br_if   	$0, BB9_4
	i32.const	$push1=, 2
	i32.store	$discard=, 0($2), $pop1
	block   	BB9_3
	br_if   	$1, BB9_3
	i32.const	$push2=, 3
	i32.store	$discard=, 0($2), $pop2
BB9_3:
	i32.const	$push3=, 4
	i32.store	$discard=, 0($2), $pop3
BB9_4:
	i32.const	$push4=, 5
	i32.store	$discard=, 0($2), $pop4
	return  	$3
func_end9:
	.size	doubletriangle, func_end9-doubletriangle

	.globl	ifelse_earlyexits
	.type	ifelse_earlyexits,@function
ifelse_earlyexits:
	.param  	i32, i32, i32
	.result 	i32
	.local  	i32
	i32.const	$push0=, 0
	i32.store	$3=, 0($2), $pop0
	block   	BB10_4
	block   	BB10_2
	br_if   	$0, BB10_2
	i32.const	$push3=, 1
	i32.store	$discard=, 0($2), $pop3
	br      	BB10_4
BB10_2:
	i32.const	$push1=, 2
	i32.store	$discard=, 0($2), $pop1
	br_if   	$1, BB10_4
	i32.const	$push2=, 3
	i32.store	$discard=, 0($2), $pop2
BB10_4:
	i32.const	$push4=, 4
	i32.store	$discard=, 0($2), $pop4
	return  	$3
func_end10:
	.size	ifelse_earlyexits, func_end10-ifelse_earlyexits

	.globl	doublediamond_in_a_loop
	.type	doublediamond_in_a_loop,@function
doublediamond_in_a_loop:
	.param  	i32, i32, i32
	.result 	i32
BB11_1:
	loop    	BB11_7
	i32.const	$push0=, 0
	i32.store	$discard=, 0($2), $pop0
	block   	BB11_6
	block   	BB11_3
	br_if   	$0, BB11_3
	i32.const	$push4=, 1
	i32.store	$discard=, 0($2), $pop4
	br      	BB11_6
BB11_3:
	i32.const	$push1=, 2
	i32.store	$discard=, 0($2), $pop1
	block   	BB11_5
	br_if   	$1, BB11_5
	i32.const	$push3=, 3
	i32.store	$discard=, 0($2), $pop3
	br      	BB11_6
BB11_5:
	i32.const	$push2=, 4
	i32.store	$discard=, 0($2), $pop2
BB11_6:
	i32.const	$push5=, 5
	i32.store	$discard=, 0($2), $pop5
	br      	BB11_1
BB11_7:
func_end11:
	.size	doublediamond_in_a_loop, func_end11-doublediamond_in_a_loop

	.globl	test3
	.type	test3,@function
test3:
	.param  	i32
	i32.const	$push0=, 0
	block   	BB12_5
	br_if   	$pop0, BB12_5
BB12_1:
	loop    	BB12_4
	br_if   	$0, BB12_4
BB12_2:
	loop    	BB12_3
	i32.ne  	$push1=, $0, $0
	br_if   	$pop1, BB12_2
BB12_3:
	call    	bar
	br      	BB12_1
BB12_4:
	unreachable
BB12_5:
	return
func_end12:
	.size	test3, func_end12-test3


	.imports
	.import something "" something
	.import bar "" bar
