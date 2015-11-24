	.text
	.file	"/usr/local/google/home/binji/dev/github/wasm-experimental/prototype-wasmate/third_party/llvm/test/CodeGen/WebAssembly/conv.ll"
	.globl	i32_wrap_i64
	.type	i32_wrap_i64,@function
i32_wrap_i64:
	.param  	i64
	.result 	i32
	i32.wrap/i64	$push0=, $0
	return  	$pop0
func_end0:
	.size	i32_wrap_i64, func_end0-i32_wrap_i64

	.globl	i64_extend_s_i32
	.type	i64_extend_s_i32,@function
i64_extend_s_i32:
	.param  	i32
	.result 	i64
	i64.extend_s/i32	$push0=, $0
	return  	$pop0
func_end1:
	.size	i64_extend_s_i32, func_end1-i64_extend_s_i32

	.globl	i64_extend_u_i32
	.type	i64_extend_u_i32,@function
i64_extend_u_i32:
	.param  	i32
	.result 	i64
	i64.extend_u/i32	$push0=, $0
	return  	$pop0
func_end2:
	.size	i64_extend_u_i32, func_end2-i64_extend_u_i32

	.globl	i32_trunc_s_f32
	.type	i32_trunc_s_f32,@function
i32_trunc_s_f32:
	.param  	f32
	.result 	i32
	i32.trunc_s/f32	$push0=, $0
	return  	$pop0
func_end3:
	.size	i32_trunc_s_f32, func_end3-i32_trunc_s_f32

	.globl	i32_trunc_u_f32
	.type	i32_trunc_u_f32,@function
i32_trunc_u_f32:
	.param  	f32
	.result 	i32
	i32.trunc_u/f32	$push0=, $0
	return  	$pop0
func_end4:
	.size	i32_trunc_u_f32, func_end4-i32_trunc_u_f32

	.globl	i32_trunc_s_f64
	.type	i32_trunc_s_f64,@function
i32_trunc_s_f64:
	.param  	f64
	.result 	i32
	i32.trunc_s/f64	$push0=, $0
	return  	$pop0
func_end5:
	.size	i32_trunc_s_f64, func_end5-i32_trunc_s_f64

	.globl	i32_trunc_u_f64
	.type	i32_trunc_u_f64,@function
i32_trunc_u_f64:
	.param  	f64
	.result 	i32
	i32.trunc_u/f64	$push0=, $0
	return  	$pop0
func_end6:
	.size	i32_trunc_u_f64, func_end6-i32_trunc_u_f64

	.globl	i64_trunc_s_f32
	.type	i64_trunc_s_f32,@function
i64_trunc_s_f32:
	.param  	f32
	.result 	i64
	i64.trunc_s/f32	$push0=, $0
	return  	$pop0
func_end7:
	.size	i64_trunc_s_f32, func_end7-i64_trunc_s_f32

	.globl	i64_trunc_u_f32
	.type	i64_trunc_u_f32,@function
i64_trunc_u_f32:
	.param  	f32
	.result 	i64
	i64.trunc_u/f32	$push0=, $0
	return  	$pop0
func_end8:
	.size	i64_trunc_u_f32, func_end8-i64_trunc_u_f32

	.globl	i64_trunc_s_f64
	.type	i64_trunc_s_f64,@function
i64_trunc_s_f64:
	.param  	f64
	.result 	i64
	i64.trunc_s/f64	$push0=, $0
	return  	$pop0
func_end9:
	.size	i64_trunc_s_f64, func_end9-i64_trunc_s_f64

	.globl	i64_trunc_u_f64
	.type	i64_trunc_u_f64,@function
i64_trunc_u_f64:
	.param  	f64
	.result 	i64
	i64.trunc_u/f64	$push0=, $0
	return  	$pop0
func_end10:
	.size	i64_trunc_u_f64, func_end10-i64_trunc_u_f64

	.globl	f32_convert_s_i32
	.type	f32_convert_s_i32,@function
f32_convert_s_i32:
	.param  	i32
	.result 	f32
	f32.convert_s/i32	$push0=, $0
	return  	$pop0
func_end11:
	.size	f32_convert_s_i32, func_end11-f32_convert_s_i32

	.globl	f32_convert_u_i32
	.type	f32_convert_u_i32,@function
f32_convert_u_i32:
	.param  	i32
	.result 	f32
	f32.convert_u/i32	$push0=, $0
	return  	$pop0
func_end12:
	.size	f32_convert_u_i32, func_end12-f32_convert_u_i32

	.globl	f64_convert_s_i32
	.type	f64_convert_s_i32,@function
f64_convert_s_i32:
	.param  	i32
	.result 	f64
	f64.convert_s/i32	$push0=, $0
	return  	$pop0
func_end13:
	.size	f64_convert_s_i32, func_end13-f64_convert_s_i32

	.globl	f64_convert_u_i32
	.type	f64_convert_u_i32,@function
f64_convert_u_i32:
	.param  	i32
	.result 	f64
	f64.convert_u/i32	$push0=, $0
	return  	$pop0
func_end14:
	.size	f64_convert_u_i32, func_end14-f64_convert_u_i32

	.globl	f32_convert_s_i64
	.type	f32_convert_s_i64,@function
f32_convert_s_i64:
	.param  	i64
	.result 	f32
	f32.convert_s/i64	$push0=, $0
	return  	$pop0
func_end15:
	.size	f32_convert_s_i64, func_end15-f32_convert_s_i64

	.globl	f32_convert_u_i64
	.type	f32_convert_u_i64,@function
f32_convert_u_i64:
	.param  	i64
	.result 	f32
	f32.convert_u/i64	$push0=, $0
	return  	$pop0
func_end16:
	.size	f32_convert_u_i64, func_end16-f32_convert_u_i64

	.globl	f64_convert_s_i64
	.type	f64_convert_s_i64,@function
f64_convert_s_i64:
	.param  	i64
	.result 	f64
	f64.convert_s/i64	$push0=, $0
	return  	$pop0
func_end17:
	.size	f64_convert_s_i64, func_end17-f64_convert_s_i64

	.globl	f64_convert_u_i64
	.type	f64_convert_u_i64,@function
f64_convert_u_i64:
	.param  	i64
	.result 	f64
	f64.convert_u/i64	$push0=, $0
	return  	$pop0
func_end18:
	.size	f64_convert_u_i64, func_end18-f64_convert_u_i64

	.globl	f64_promote_f32
	.type	f64_promote_f32,@function
f64_promote_f32:
	.param  	f32
	.result 	f64
	f64.promote/f32	$push0=, $0
	return  	$pop0
func_end19:
	.size	f64_promote_f32, func_end19-f64_promote_f32

	.globl	f32_demote_f64
	.type	f32_demote_f64,@function
f32_demote_f64:
	.param  	f64
	.result 	f32
	f32.demote/f64	$push0=, $0
	return  	$pop0
func_end20:
	.size	f32_demote_f64, func_end20-f32_demote_f64


