	.text
	.file	"/s/llvm/llvm/test/CodeGen/WebAssembly/inline-asm.ll"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32
	.result 	i32
# BB#0:                                 # %entry
	#APP
	# $0 = aaa($0)
	#NO_APP
	return  	$0
func_end0:
	.size	foo, func_end0-foo

	.globl	bar
	.type	bar,@function
bar:                                    # @bar
	.param  	i32, i32
# BB#0:                                 # %entry
	#APP
	# 0($1) = bbb(0($0))
	#NO_APP
	return
func_end1:
	.size	bar, func_end1-bar

	.globl	imm
	.type	imm,@function
imm:                                    # @imm
	.result 	i32
	.local  	i32
# BB#0:                                 # %entry
	#APP
	# $0 = ccc(42)
	#NO_APP
	return  	$0
func_end2:
	.size	imm, func_end2-imm

	.globl	foo_i64
	.type	foo_i64,@function
foo_i64:                                # @foo_i64
	.param  	i64
	.result 	i64
# BB#0:                                 # %entry
	#APP
	# $0 = aaa($0)
	#NO_APP
	return  	$0
func_end3:
	.size	foo_i64, func_end3-foo_i64

	.globl	X_i16
	.type	X_i16,@function
X_i16:                                  # @X_i16
	.param  	i32
	.local  	i32
# BB#0:
	#APP
	foo $1
	#NO_APP
	i32.store16	$discard=, 0($0), $1
	return
func_end4:
	.size	X_i16, func_end4-X_i16

	.globl	X_ptr
	.type	X_ptr,@function
X_ptr:                                  # @X_ptr
	.param  	i32
	.local  	i32
# BB#0:
	#APP
	foo $1
	#NO_APP
	i32.store	$discard=, 0($0), $1
	return
func_end5:
	.size	X_ptr, func_end5-X_ptr

	.globl	funcname
	.type	funcname,@function
funcname:                               # @funcname
# BB#0:
	#APP
	foo funcname
	#NO_APP
	return
func_end6:
	.size	funcname, func_end6-funcname

	.globl	varname
	.type	varname,@function
varname:                                # @varname
# BB#0:
	#APP
	foo gv+37
	#NO_APP
	return
func_end7:
	.size	varname, func_end7-varname

	.type	gv,@object              # @gv
	.bss
	.globl	gv
gv:
	.size	gv, 0


	.section	".note.GNU-stack","",@progbits
