	.text
	.file	"/usr/local/google/home/binji/dev/github/wasm-experimental/prototype-wasmate/third_party/llvm/test/CodeGen/WebAssembly/select.ll"
	.globl	select_i32
	.type	select_i32,@function
select_i32:
	.param  	i32, i32, i32
	.result 	i32
	i32.const	$push0=, 0
	i32.eq  	$push1=, $2, $pop0
	i32.select	$push2=, $pop1, $0, $1
	return  	$pop2
func_end0:
	.size	select_i32, func_end0-select_i32

	.globl	select_i64
	.type	select_i64,@function
select_i64:
	.param  	i64, i64, i32
	.result 	i64
	i32.const	$push0=, 0
	i32.eq  	$push1=, $2, $pop0
	i64.select	$push2=, $pop1, $0, $1
	return  	$pop2
func_end1:
	.size	select_i64, func_end1-select_i64

	.globl	select_f32
	.type	select_f32,@function
select_f32:
	.param  	f32, f32, i32
	.result 	f32
	i32.const	$push0=, 0
	i32.eq  	$push1=, $2, $pop0
	f32.select	$push2=, $pop1, $0, $1
	return  	$pop2
func_end2:
	.size	select_f32, func_end2-select_f32

	.globl	select_f64
	.type	select_f64,@function
select_f64:
	.param  	f64, f64, i32
	.result 	f64
	i32.const	$push0=, 0
	i32.eq  	$push1=, $2, $pop0
	f64.select	$push2=, $pop1, $0, $1
	return  	$pop2
func_end3:
	.size	select_f64, func_end3-select_f64


