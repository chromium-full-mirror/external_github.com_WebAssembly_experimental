	.text
	.file	"/usr/local/google/home/binji/dev/github/wasm-experimental/prototype-wasmate/third_party/llvm/test/CodeGen/WebAssembly/legalize.ll"
	.globl	shl_i3
	.type	shl_i3,@function
shl_i3:
	.param  	i32, i32, i32
	.result 	i32
	i32.const	$push0=, 7
	i32.and 	$push1=, $1, $pop0
	i32.shl 	$push2=, $0, $pop1
	return  	$pop2
func_end0:
	.size	shl_i3, func_end0-shl_i3

	.globl	shl_i53
	.type	shl_i53,@function
shl_i53:
	.param  	i64, i64, i32
	.result 	i64
	i64.const	$push0=, 9007199254740991
	i64.and 	$push1=, $1, $pop0
	i64.shl 	$push2=, $0, $pop1
	return  	$pop2
func_end1:
	.size	shl_i53, func_end1-shl_i53

	.globl	sext_in_reg_i32_i64
	.type	sext_in_reg_i32_i64,@function
sext_in_reg_i32_i64:
	.param  	i64
	.result 	i64
	.local  	i64
	i64.const	$1=, 32
	i64.shl 	$push0=, $0, $1
	i64.shr_s	$push1=, $pop0, $1
	return  	$pop1
func_end2:
	.size	sext_in_reg_i32_i64, func_end2-sext_in_reg_i32_i64

	.globl	fpext_f32_f64
	.type	fpext_f32_f64,@function
fpext_f32_f64:
	.param  	i32
	.result 	f64
	f32.load	$push0=, 0($0)
	f64.promote/f32	$push1=, $pop0
	return  	$pop1
func_end3:
	.size	fpext_f32_f64, func_end3-fpext_f32_f64

	.globl	fpconv_f64_f32
	.type	fpconv_f64_f32,@function
fpconv_f64_f32:
	.param  	i32
	.result 	f32
	f64.load	$push0=, 0($0)
	f32.demote/f64	$push1=, $pop0
	return  	$pop1
func_end4:
	.size	fpconv_f64_f32, func_end4-fpconv_f64_f32


