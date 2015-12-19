	.text
	.file	"/s/llvm/llvm/test/CodeGen/WebAssembly/offset.ll"
	.globl	load_i32_with_folded_offset
	.type	load_i32_with_folded_offset,@function
load_i32_with_folded_offset:            # @load_i32_with_folded_offset
	.param  	i32
	.result 	i32
# BB#0:
	i32.load	$push0=, 24($0)
	return  	$pop0
func_end0:
	.size	load_i32_with_folded_offset, func_end0-load_i32_with_folded_offset

	.globl	load_i32_with_unfolded_offset
	.type	load_i32_with_unfolded_offset,@function
load_i32_with_unfolded_offset:          # @load_i32_with_unfolded_offset
	.param  	i32
	.result 	i32
# BB#0:
	i32.const	$push0=, 24
	i32.add 	$push1=, $0, $pop0
	i32.load	$push2=, 0($pop1)
	return  	$pop2
func_end1:
	.size	load_i32_with_unfolded_offset, func_end1-load_i32_with_unfolded_offset

	.globl	load_i64_with_folded_offset
	.type	load_i64_with_folded_offset,@function
load_i64_with_folded_offset:            # @load_i64_with_folded_offset
	.param  	i32
	.result 	i64
# BB#0:
	i64.load	$push0=, 24($0)
	return  	$pop0
func_end2:
	.size	load_i64_with_folded_offset, func_end2-load_i64_with_folded_offset

	.globl	load_i64_with_unfolded_offset
	.type	load_i64_with_unfolded_offset,@function
load_i64_with_unfolded_offset:          # @load_i64_with_unfolded_offset
	.param  	i32
	.result 	i64
# BB#0:
	i32.const	$push0=, 24
	i32.add 	$push1=, $0, $pop0
	i64.load	$push2=, 0($pop1)
	return  	$pop2
func_end3:
	.size	load_i64_with_unfolded_offset, func_end3-load_i64_with_unfolded_offset

	.globl	store_i32_with_folded_offset
	.type	store_i32_with_folded_offset,@function
store_i32_with_folded_offset:           # @store_i32_with_folded_offset
	.param  	i32
# BB#0:
	i32.const	$push0=, 0
	i32.store	$discard=, 24($0), $pop0
	return
func_end4:
	.size	store_i32_with_folded_offset, func_end4-store_i32_with_folded_offset

	.globl	store_i32_with_unfolded_offset
	.type	store_i32_with_unfolded_offset,@function
store_i32_with_unfolded_offset:         # @store_i32_with_unfolded_offset
	.param  	i32
# BB#0:
	i32.const	$push0=, 24
	i32.add 	$push1=, $0, $pop0
	i32.const	$push2=, 0
	i32.store	$discard=, 0($pop1), $pop2
	return
func_end5:
	.size	store_i32_with_unfolded_offset, func_end5-store_i32_with_unfolded_offset

	.globl	store_i64_with_folded_offset
	.type	store_i64_with_folded_offset,@function
store_i64_with_folded_offset:           # @store_i64_with_folded_offset
	.param  	i32
# BB#0:
	i64.const	$push0=, 0
	i64.store	$discard=, 24($0), $pop0
	return
func_end6:
	.size	store_i64_with_folded_offset, func_end6-store_i64_with_folded_offset

	.globl	store_i64_with_unfolded_offset
	.type	store_i64_with_unfolded_offset,@function
store_i64_with_unfolded_offset:         # @store_i64_with_unfolded_offset
	.param  	i32
# BB#0:
	i32.const	$push0=, 24
	i32.add 	$push1=, $0, $pop0
	i64.const	$push2=, 0
	i64.store	$discard=, 0($pop1), $pop2
	return
func_end7:
	.size	store_i64_with_unfolded_offset, func_end7-store_i64_with_unfolded_offset

	.globl	load_i32_from_numeric_address
	.type	load_i32_from_numeric_address,@function
load_i32_from_numeric_address:          # @load_i32_from_numeric_address
	.result 	i32
# BB#0:
	i32.const	$push0=, 0
	i32.load	$push1=, 42($pop0)
	return  	$pop1
func_end8:
	.size	load_i32_from_numeric_address, func_end8-load_i32_from_numeric_address

	.globl	load_i32_from_global_address
	.type	load_i32_from_global_address,@function
load_i32_from_global_address:           # @load_i32_from_global_address
	.result 	i32
# BB#0:
	i32.const	$push0=, 0
	i32.load	$push1=, gv($pop0)
	return  	$pop1
func_end9:
	.size	load_i32_from_global_address, func_end9-load_i32_from_global_address

	.globl	store_i32_to_numeric_address
	.type	store_i32_to_numeric_address,@function
store_i32_to_numeric_address:           # @store_i32_to_numeric_address
	.local  	i32
# BB#0:
	i32.const	$0=, 0
	i32.store	$discard=, 42($0), $0
	return
func_end10:
	.size	store_i32_to_numeric_address, func_end10-store_i32_to_numeric_address

	.globl	store_i32_to_global_address
	.type	store_i32_to_global_address,@function
store_i32_to_global_address:            # @store_i32_to_global_address
	.local  	i32
# BB#0:
	i32.const	$0=, 0
	i32.store	$discard=, gv($0), $0
	return
func_end11:
	.size	store_i32_to_global_address, func_end11-store_i32_to_global_address

	.globl	load_i8_s_with_folded_offset
	.type	load_i8_s_with_folded_offset,@function
load_i8_s_with_folded_offset:           # @load_i8_s_with_folded_offset
	.param  	i32
	.result 	i32
# BB#0:
	i32.load8_s	$push0=, 24($0)
	return  	$pop0
func_end12:
	.size	load_i8_s_with_folded_offset, func_end12-load_i8_s_with_folded_offset

	.globl	load_i8_u_with_folded_offset
	.type	load_i8_u_with_folded_offset,@function
load_i8_u_with_folded_offset:           # @load_i8_u_with_folded_offset
	.param  	i32
	.result 	i32
# BB#0:
	i32.load8_u	$push0=, 24($0)
	return  	$pop0
func_end13:
	.size	load_i8_u_with_folded_offset, func_end13-load_i8_u_with_folded_offset

	.globl	store_i8_with_folded_offset
	.type	store_i8_with_folded_offset,@function
store_i8_with_folded_offset:            # @store_i8_with_folded_offset
	.param  	i32
# BB#0:
	i32.const	$push0=, 0
	i32.store8	$discard=, 24($0), $pop0
	return
func_end14:
	.size	store_i8_with_folded_offset, func_end14-store_i8_with_folded_offset

	.type	gv,@object              # @gv
	.bss
	.globl	gv
	.align	2
gv:
	.int32	0                       # 0x0
	.size	gv, 4


	.section	".note.GNU-stack","",@progbits
