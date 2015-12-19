	.text
	.file	"/s/llvm/llvm/test/CodeGen/WebAssembly/dead-vreg.ll"
	.globl	foo
	.type	foo,@function
foo:                                    # @foo
	.param  	i32, i32, i32
	.local  	i32, i32, i32, i32, i32, i32, i32
# BB#0:                                 # %entry
	i32.const	$4=, 1
	i32.lt_s	$push0=, $2, $4
	block   	BB0_5
	br_if   	$pop0, BB0_5
# BB#1:                                 # %for.cond.1.preheader.lr.ph
	i32.const	$push1=, 2
	i32.shl 	$3=, $1, $pop1
	i32.const	$5=, 0
	copy_local	$6=, $5
BB0_2:                                  # %for.cond.1.preheader
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_3 Depth 2
	loop    	BB0_5
	i32.lt_s	$push2=, $1, $4
	copy_local	$7=, $5
	copy_local	$8=, $0
	copy_local	$9=, $1
	block   	BB0_4
	br_if   	$pop2, BB0_4
BB0_3:                                  # %for.body.3
                                        #   Parent Loop BB0_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	loop    	BB0_4
	i32.const	$push3=, -1
	i32.add 	$9=, $9, $pop3
	i32.store	$discard=, 0($8), $7
	i32.const	$push4=, 4
	i32.add 	$8=, $8, $pop4
	i32.add 	$7=, $7, $6
	br_if   	$9, BB0_3
BB0_4:                                  # %for.inc.5
                                        #   in Loop: Header=BB0_2 Depth=1
	i32.add 	$6=, $6, $4
	i32.ne  	$push5=, $6, $2
	i32.add 	$0=, $0, $3
	br_if   	$pop5, BB0_2
BB0_5:                                  # %for.end.7
	return
func_end0:
	.size	foo, func_end0-foo


	.section	".note.GNU-stack","",@progbits
