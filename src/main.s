	.cstring
	.align 3
LC0:
	.ascii "len > 0 && w > 0 && k > 0 && len > k && len > w && k < 64/2\0"
LC1:
	.ascii "main.c\0"
LC2:
	.ascii "n < s\0"
LC3:
	.ascii "seq: %s min: %i\12\0"
LC4:
	.ascii "minimizer:\0"
LC5:
	.ascii " min: %lld\12\0"
LC6:
	.ascii " load: %i\12\0"
LC7:
	.ascii " strand: %i\12\0"
	.section __TEXT,__text_cold,regular,pure_instructions
LCOLDB8:
	.text
LHOTB8:
	.align 4,0x90
	.globl _sketch
_sketch:
LFB33:
	leal	-1(%rcx), %eax
	pushq	%r15
LCFI0:
	movl	%ecx, %r10d
	pushq	%r14
LCFI1:
	pushq	%r13
LCFI2:
	leal	(%rax,%rax), %r13d
	pushq	%r12
LCFI3:
	leal	2(%r13), %ecx
	pushq	%rbp
LCFI4:
	pushq	%rbx
LCFI5:
	movl	$1, %ebx
	salq	%cl, %rbx
	subq	$40, %rsp
LCFI6:
	subq	$1, %rbx
	testl	%edx, %edx
	movq	%rdi, 8(%rsp)
	movq	$0, 16(%rsp)
	movq	$0, 24(%rsp)
	jle	L2
	testl	%r8d, %r8d
	movl	%r8d, %r15d
	jle	L2
	cmpl	$30, %eax
	ja	L2
	cmpl	%r10d, %edx
	jle	L2
	cmpl	%r8d, %edx
	jle	L2
	pxor	%xmm0, %xmm0
	pxor	%xmm1, %xmm1
	cvtsi2ss	%edx, %xmm0
	movl	%edx, (%rsp)
	cvtsi2ss	%r15d, %xmm1
	movl	%r10d, 4(%rsp)
	movq	%rsi, %rbp
	divss	%xmm1, %xmm0
	cvttss2si	%xmm0, %r14d
	movslq	%r14d, %rdi
	salq	$4, %rdi
	call	_malloc
	testl	%r14d, %r14d
	movl	(%rsp), %edx
	movq	%rax, %r12
	movl	4(%rsp), %r10d
	jle	L8
	leal	-1(%r14), %ecx
	leaq	12(%rax), %rax
	salq	$4, %rcx
	leaq	28(%r12,%rcx), %rcx
	.align 4,0x90
L7:
	movq	$-1, -12(%rax)
	addq	$16, %rax
	movb	$0, -16(%rax)
	movl	$0, -20(%rax)
	cmpq	%rcx, %rax
	jne	L7
L8:
	subl	$1, %edx
	movq	%rbp, %rsi
	xorl	%edi, %edi
	leaq	1(%rbp,%rdx), %rbp
	xorl	%r9d, %r9d
	leaq	_seq_nt4_table(%rip), %r11
	jmp	L6
	.align 4,0x90
L28:
	movzbl	%dl, %ecx
	movq	16(%rsp), %rdx
	xorl	$3, %eax
	movzbl	%al, %eax
	salq	$2, %rdx
	orq	%rcx, %rdx
	movl	%r13d, %ecx
	salq	%cl, %rax
	movq	24(%rsp), %rcx
	andq	%rbx, %rdx
	movq	%rdx, 16(%rsp)
	shrq	$2, %rcx
	orq	%rcx, %rax
	cmpq	%rax, %rdx
	movq	%rax, 24(%rsp)
	je	L10
	addl	$1, %r9d
	movl	%r9d, %eax
	cltd
	idivl	%r15d
	testl	%edx, %edx
	je	L26
L11:
	cmpl	%r9d, %r10d
	jle	L12
	.align 4,0x90
L10:
	addq	$1, %rsi
	cmpq	%rbp, %rsi
	je	L27
L6:
	movzbl	(%rsi), %eax
	movzbl	(%r11,%rax), %edx
	cmpl	$3, %edx
	movl	%edx, %eax
	jle	L28
	xorl	%r9d, %r9d
	cmpl	%r9d, %r10d
	jg	L10
L12:
	cmpl	%r14d, %edi
	jge	L29
	movq	16(%rsp), %rdx
	movq	%rdx, %rax
	salq	$21, %rax
	subq	%rdx, %rax
	subq	$1, %rax
	andq	%rbx, %rax
	movq	%rax, %rdx
	shrq	$24, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	salq	$8, %rdx
	leaq	(%rdx,%rax,8), %rdx
	addq	%rdx, %rax
	andq	%rbx, %rax
	movq	%rax, %rdx
	shrq	$14, %rdx
	xorq	%rdx, %rax
	movq	%rax, %rdx
	salq	$4, %rdx
	leaq	(%rdx,%rax,4), %rdx
	addq	%rdx, %rax
	andq	%rbx, %rax
	movq	%rax, %rcx
	shrq	$28, %rcx
	xorq	%rax, %rcx
	movq	24(%rsp), %rax
	movq	%rax, %rdx
	salq	$21, %rdx
	subq	%rax, %rdx
	subq	$1, %rdx
	movq	%rdx, %rax
	andq	%rbx, %rax
	movq	%rax, %rdx
	shrq	$24, %rdx
	xorq	%rax, %rdx
	movq	%rdx, %rax
	salq	$8, %rax
	leaq	(%rax,%rdx,8), %rax
	addq	%rax, %rdx
	andq	%rbx, %rdx
	movq	%rdx, %rax
	shrq	$14, %rax
	xorq	%rdx, %rax
	movq	%rax, %rdx
	salq	$4, %rdx
	leaq	(%rdx,%rax,4), %rdx
	addq	%rdx, %rax
	andq	%rbx, %rax
	movq	%rax, %rdx
	shrq	$28, %rdx
	xorq	%rax, %rdx
	movq	%rcx, %rax
	salq	$31, %rax
	addq	%rax, %rcx
	movq	%rdx, %rax
	salq	$31, %rax
	andq	%rbx, %rcx
	addq	%rax, %rdx
	movslq	%edi, %rax
	andq	%rbx, %rdx
	cmpq	%rdx, %rcx
	setbe	%dl
	salq	$4, %rax
	movq	%rdx, %rcx
	addq	%r12, %rax
	andl	$1, %ecx
	movq	16(%rsp,%rcx,8), %rcx
	cmpq	%rcx, (%rax)
	jbe	L10
	addq	$1, %rsi
	movq	%rcx, (%rax)
	cmpq	%rbp, %rsi
	movb	%dl, 12(%rax)
	jne	L6
L27:
	movq	8(%rsp), %rsi
	movl	%edi, %edx
	xorl	%eax, %eax
	movq	%r12, %rbx
	leal	-999(%rdi), %r14d
	leal	-1(%rdi), %ebp
	leaq	LC3(%rip), %rdi
	call	_printf
	leaq	160(%r12), %r13
	.align 4,0x90
L14:
	leaq	LC4(%rip), %rdi
	addq	$16, %rbx
	call	_puts
	movq	-16(%rbx), %rsi
	leaq	LC5(%rip), %rdi
	xorl	%eax, %eax
	call	_printf
	movl	-8(%rbx), %esi
	leaq	LC6(%rip), %rdi
	xorl	%eax, %eax
	call	_printf
	movzbl	-4(%rbx), %esi
	leaq	LC7(%rip), %rdi
	xorl	%eax, %eax
	call	_printf
	movl	$10, %edi
	call	_putchar
	cmpq	%r13, %rbx
	jne	L14
	movslq	%ebp, %rax
	salq	$4, %rax
	leaq	8(%r12,%rax), %rbx
	.align 4,0x90
L15:
	leaq	LC4(%rip), %rdi
	subl	$1, %ebp
	subq	$16, %rbx
	call	_puts
	movq	8(%rbx), %rsi
	leaq	LC5(%rip), %rdi
	xorl	%eax, %eax
	call	_printf
	movl	16(%rbx), %esi
	leaq	LC6(%rip), %rdi
	xorl	%eax, %eax
	call	_printf
	movzbl	20(%rbx), %esi
	leaq	LC7(%rip), %rdi
	xorl	%eax, %eax
	call	_printf
	movl	$10, %edi
	call	_putchar
	cmpl	%r14d, %ebp
	jge	L15
	addq	$40, %rsp
LCFI7:
	popq	%rbx
LCFI8:
	popq	%rbp
LCFI9:
	popq	%r12
LCFI10:
	popq	%r13
LCFI11:
	popq	%r14
LCFI12:
	popq	%r15
LCFI13:
	ret
	.align 4,0x90
L29:
LCFI14:
	leaq	LC2(%rip), %rcx
	movl	$107, %edx
	leaq	LC1(%rip), %rsi
	leaq	___func__.4397(%rip), %rdi
	call	___assert_rtn
	.align 4,0x90
L2:
	leaq	LC0(%rip), %rcx
	movl	$77, %edx
	leaq	LC1(%rip), %rsi
	leaq	___func__.4397(%rip), %rdi
	call	___assert_rtn
L26:
	cmpl	%r9d, %r10d
	jge	L11
	addl	$1, %edi
	jmp	L12
LFE33:
	.section __TEXT,__text_cold,regular,pure_instructions
LCOLDE8:
	.text
LHOTE8:
	.cstring
LC9:
	.ascii "Usage: %s <in.seq>\12\0"
LC10:
	.ascii "r\0"
	.section __TEXT,__text_cold,regular,pure_instructions
LCOLDB12:
	.section __TEXT,__text_startup,regular,pure_instructions
LHOTB12:
	.align 4
	.globl _main
_main:
LFB42:
	pushq	%r15
LCFI15:
	pushq	%r14
LCFI16:
	pushq	%r13
LCFI17:
	pushq	%r12
LCFI18:
	pushq	%rbp
LCFI19:
	pushq	%rbx
LCFI20:
	subq	$40, %rsp
LCFI21:
	cmpl	$1, %edi
	je	L213
	movq	8(%rsi), %rdi
	leaq	LC10(%rip), %rsi
	call	_gzopen
	movl	$80, %esi
	movl	$1, %edi
	movq	%rax, %rbx
	movq	%rax, (%rsp)
	call	_calloc
	movl	$32, %esi
	movl	$1, %edi
	movq	%rax, %r13
	call	_calloc
	movl	$16384, %edi
	movq	%rax, %rbp
	movl	8(%rbp), %eax
	movq	%rbx, 16(%rbp)
	andl	$3, %eax
	orl	$65536, %eax
	movl	%eax, 8(%rbp)
	call	_malloc
	movq	%rbp, 72(%r13)
	movq	%rax, 24(%rbp)
L33:
	movl	64(%r13), %eax
	movl	0(%rbp), %r15d
	testl	%eax, %eax
	movl	4(%rbp), %eax
	je	L49
	jmp	L136
	.align 4
L215:
	cmpl	%eax, %r15d
	jge	L138
L140:
	movslq	%r15d, %rdx
L47:
	movq	24(%rbp), %rsi
	leal	1(%rdx), %r15d
	movl	%r15d, 0(%rbp)
	movzbl	(%rsi,%rdx), %edx
	leal	-62(%rdx), %esi
	andl	$253, %esi
	je	L214
L49:
	testb	$3, 8(%rbp)
	jne	L215
	cmpl	%eax, %r15d
	jl	L140
	movl	8(%rbp), %edx
	movl	$0, 0(%rbp)
	movq	24(%rbp), %rsi
	movq	16(%rbp), %rdi
	sarl	$2, %edx
	call	_gzread
	movl	8(%rbp), %edx
	movl	%eax, 4(%rbp)
	sarl	$2, %edx
	cmpl	%edx, %eax
	jge	L48
	movzbl	8(%rbp), %edx
	andl	$-4, %edx
	orl	$1, %edx
	movb	%dl, 8(%rbp)
L48:
	testl	%eax, %eax
	je	L138
	movslq	0(%rbp), %rdx
	jmp	L47
L214:
	movl	%edx, 64(%r13)
L136:
	cmpl	%eax, %r15d
	movl	$0, 48(%r13)
	movl	$0, 32(%r13)
	movl	$0, 16(%r13)
	movl	$0, 0(%r13)
	jl	L51
	testb	$3, 8(%rbp)
	jne	L138
L51:
	xorl	%ebx, %ebx
	.align 4
L65:
	cmpl	%eax, %r15d
	jl	L53
	testb	$3, 8(%rbp)
	jne	L204
	movl	8(%rbp), %edx
	movl	$0, 0(%rbp)
	movq	24(%rbp), %rsi
	movq	16(%rbp), %rdi
	sarl	$2, %edx
	call	_gzread
	movl	8(%rbp), %edx
	movl	%eax, 4(%rbp)
	sarl	$2, %edx
	cmpl	%edx, %eax
	jge	L56
	movzbl	8(%rbp), %edx
	andl	$-4, %edx
	orl	$1, %edx
	movb	%dl, 8(%rbp)
L56:
	testl	%eax, %eax
	je	L204
	movl	0(%rbp), %r15d
	cmpl	%r15d, %eax
	jle	L141
L53:
	movslq	%r15d, %r14
	jmp	L62
	.align 4
L216:
	movq	__DefaultRuneLocale@GOTPCREL(%rip), %rax
	movl	60(%rax,%rdi,4), %eax
	shrl	$14, %eax
	andl	$1, %eax
	testl	%eax, %eax
	jne	L203
L217:
	addl	$1, %r15d
	addq	$1, %r14
	cmpl	4(%rbp), %r15d
	jge	L203
L62:
	movq	24(%rbp), %rax
	movzbl	(%rax,%r14), %edi
	testb	$-128, %dil
	je	L216
	movl	$16384, %esi
	call	___maskrune
	testl	%eax, %eax
	setne	%al
	movzbl	%al, %eax
	testl	%eax, %eax
	je	L217
	.align 4
L203:
	movslq	0(%rbp), %rsi
	movl	%r15d, %edx
	movslq	%r15d, %r14
	subl	%esi, %edx
	leal	1(%rdx), %edi
	movslq	%edi, %rdi
L58:
	movl	4(%r13), %eax
	subl	%ebx, %eax
	cmpq	%rdi, %rax
	jb	L63
	movq	8(%r13), %r12
L64:
	addq	24(%rbp), %rsi
	movl	%ebx, %edi
	movslq	%edx, %rdx
	addq	%r12, %rdi
	call	_memcpy
	movl	%r15d, %eax
	subl	0(%rbp), %eax
	addl	$1, %r15d
	movl	%r15d, 0(%rbp)
	addl	%eax, %ebx
	movl	4(%rbp), %eax
	movl	%ebx, 0(%r13)
	cmpl	%eax, %r14d
	jge	L65
	movq	24(%rbp), %rax
	testq	%r12, %r12
	movzbl	(%rax,%r14), %r14d
	je	L218
L66:
	movl	%ebx, %eax
	testl	%ebx, %ebx
	movb	$0, (%r12,%rax)
	js	L138
	cmpl	$10, %r14d
	je	L67
	movl	0(%rbp), %edx
	movl	4(%rbp), %eax
	cmpl	%eax, %edx
	jl	L80
	testb	$3, 8(%rbp)
	jne	L67
L80:
	cmpl	%edx, %eax
	jg	L69
	testb	$3, 8(%rbp)
	jne	L74
	movl	8(%rbp), %edx
	movl	$0, 0(%rbp)
	movq	24(%rbp), %rsi
	movq	16(%rbp), %rdi
	sarl	$2, %edx
	call	_gzread
	movl	8(%rbp), %edx
	movl	%eax, 4(%rbp)
	sarl	$2, %edx
	cmpl	%edx, %eax
	jge	L73
	movzbl	8(%rbp), %edx
	andl	$-4, %edx
	orl	$1, %edx
	movb	%dl, 8(%rbp)
L73:
	testl	%eax, %eax
	je	L74
	movl	0(%rbp), %edx
	cmpl	%edx, %eax
	jle	L143
L69:
	movq	24(%rbp), %rdi
	movslq	%edx, %rsi
	cmpb	$10, (%rdi,%rsi)
	je	L143
	leaq	1(%rdi,%rsi), %rsi
	movl	%edx, %ebx
	jmp	L76
	.align 4
L77:
	addq	$1, %rsi
	cmpb	$10, -1(%rsi)
	je	L205
L76:
	addl	$1, %ebx
	cmpl	%eax, %ebx
	jl	L77
L205:
	movl	%ebx, %eax
	subl	%edx, %eax
	leal	1(%rax), %esi
	movslq	%esi, %rsi
L75:
	movl	16(%r13), %r14d
	movl	20(%r13), %edx
	subl	%r14d, %edx
	cmpq	%rsi, %rdx
	jb	L78
	movq	24(%r13), %rdi
L79:
	movslq	0(%rbp), %rsi
	movl	%r14d, %edx
	addq	%rdx, %rdi
	movl	%ebx, %edx
	subl	%esi, %edx
	addq	24(%rbp), %rsi
	movslq	%edx, %rdx
	call	_memcpy
	leal	1(%rbx), %edx
	movl	%ebx, %eax
	subl	0(%rbp), %eax
	movl	%edx, 0(%rbp)
	addl	%eax, %r14d
	movl	4(%rbp), %eax
	movl	%r14d, 16(%r13)
	cmpl	%ebx, %eax
	jle	L80
L74:
	movq	24(%r13), %rax
	testq	%rax, %rax
	je	L219
	movl	16(%r13), %edx
	cmpl	$1, %edx
	jbe	L81
	leal	-1(%rdx), %esi
	cmpb	$13, (%rax,%rsi)
	je	L220
L81:
	movl	16(%r13), %edx
	movb	$0, (%rax,%rdx)
L67:
	movq	40(%r13), %r14
	testq	%r14, %r14
	je	L221
L82:
	movl	32(%r13), %ebx
	movslq	0(%rbp), %rdx
	movl	4(%rbp), %esi
	movzbl	8(%rbp), %edi
	movq	%rbx, %r15
L83:
	movl	%esi, %eax
L84:
	andl	$3, %edi
	je	L99
	cmpl	%eax, %edx
	jge	L100
L101:
	movq	24(%rbp), %rdi
	leal	1(%rdx), %esi
	movl	%esi, 0(%rbp)
	movzbl	(%rdi,%rdx), %edx
	cmpl	$62, %edx
	je	L148
	cmpl	$43, %edx
	je	L149
	cmpl	$64, %edx
	je	L103
	cmpl	$10, %edx
	je	L144
	movb	%dl, (%r14,%rbx)
	movl	4(%rbp), %esi
	leal	1(%r15), %r12d
	movslq	0(%rbp), %rdx
	movl	%r12d, 32(%r13)
	movl	%esi, %eax
	cmpl	%esi, %edx
	jl	L85
	movzbl	8(%rbp), %edi
	testb	$3, %dil
	jne	L145
L85:
	movl	%edx, %esi
	.align 4
L94:
	cmpl	%eax, %esi
	jl	L87
	testb	$3, 8(%rbp)
	jne	L88
	movl	8(%rbp), %edx
	movl	$0, 0(%rbp)
	movq	24(%rbp), %rsi
	movq	16(%rbp), %rdi
	sarl	$2, %edx
	call	_gzread
	movl	8(%rbp), %edx
	movl	%eax, 4(%rbp)
	sarl	$2, %edx
	cmpl	%edx, %eax
	jge	L89
	movzbl	8(%rbp), %edx
	andl	$-4, %edx
	orl	$1, %edx
	movb	%dl, 8(%rbp)
L89:
	testl	%eax, %eax
	je	L88
	movl	0(%rbp), %esi
	cmpl	%esi, %eax
	jle	L147
L87:
	movq	24(%rbp), %rdi
	movslq	%esi, %rdx
	cmpb	$10, (%rdi,%rdx)
	je	L147
	leaq	1(%rdi,%rdx), %rdx
	movl	%esi, %ebx
	jmp	L91
	.align 4
L92:
	addq	$1, %rdx
	cmpb	$10, -1(%rdx)
	je	L206
L91:
	addl	$1, %ebx
	cmpl	%ebx, %eax
	jg	L92
L206:
	movl	%ebx, %eax
	subl	%esi, %eax
	leal	1(%rax), %esi
	movslq	%esi, %rsi
L90:
	movl	36(%r13), %edx
	subl	%r12d, %edx
	cmpq	%rsi, %rdx
	jb	L222
L93:
	movslq	0(%rbp), %rsi
	movl	%ebx, %edx
	movl	%r12d, %edi
	addq	%r14, %rdi
	subl	%esi, %edx
	addq	24(%rbp), %rsi
	movslq	%edx, %rdx
	call	_memcpy
	leal	1(%rbx), %esi
	movl	%ebx, %eax
	subl	0(%rbp), %eax
	movl	%esi, 0(%rbp)
	addl	%eax, %r12d
	movl	4(%rbp), %eax
	movl	%r12d, 32(%r13)
	cmpl	%ebx, %eax
	jle	L94
L88:
	testq	%r14, %r14
	je	L223
	cmpl	$1, %r12d
	jbe	L207
	leal	-1(%r12), %ebx
	leaq	(%r14,%rbx), %rdx
	movq	%rbx, %r15
	cmpb	$13, (%rdx)
	je	L98
L207:
	movl	%r12d, %ebx
	movl	%r12d, %r15d
	leaq	(%r14,%rbx), %rdx
L96:
	movb	$0, (%rdx)
	movslq	0(%rbp), %rdx
	movl	4(%rbp), %esi
	movzbl	8(%rbp), %edi
	jmp	L83
	.align 4
L222:
	addl	%r12d, %eax
	movq	%r14, %rdi
	movl	%eax, %edx
	shrl	%edx
	orl	%edx, %eax
	movl	%eax, %edx
	shrl	$2, %edx
	orl	%edx, %eax
	movl	%eax, %esi
	shrl	$4, %esi
	orl	%esi, %eax
	movl	%eax, %esi
	shrl	$8, %esi
	orl	%esi, %eax
	movl	%eax, %esi
	shrl	$16, %esi
	orl	%esi, %eax
	leal	1(%rax), %esi
	movl	%esi, 36(%r13)
	call	_realloc
	movq	%rax, 40(%r13)
	movq	%rax, %r14
	jmp	L93
L147:
	movl	%esi, %ebx
	xorl	%eax, %eax
	movl	$1, %esi
	jmp	L90
L99:
	cmpl	%eax, %edx
	jl	L101
	movl	8(%rbp), %edx
	movl	$0, 0(%rbp)
	movq	24(%rbp), %rsi
	movq	16(%rbp), %rdi
	sarl	$2, %edx
	call	_gzread
	movl	8(%rbp), %edx
	movl	%eax, 4(%rbp)
	sarl	$2, %edx
	cmpl	%edx, %eax
	jge	L102
	movzbl	8(%rbp), %edx
	andl	$-4, %edx
	orl	$1, %edx
	movb	%dl, 8(%rbp)
L102:
	testl	%eax, %eax
	je	L100
	movslq	0(%rbp), %rdx
	jmp	L101
L144:
	movslq	%esi, %rdx
	movzbl	8(%rbp), %edi
	jmp	L84
L63:
	addl	%ebx, %edx
	movq	8(%r13), %rdi
	movl	%edx, %eax
	shrl	%eax
	orl	%eax, %edx
	movl	%edx, %eax
	shrl	$2, %eax
	orl	%edx, %eax
	movl	%eax, %edx
	shrl	$4, %edx
	orl	%edx, %eax
	movl	%eax, %edx
	shrl	$8, %edx
	orl	%edx, %eax
	movl	%eax, %edx
	shrl	$16, %edx
	orl	%edx, %eax
	leal	1(%rax), %esi
	movl	%esi, 4(%r13)
	call	_realloc
	movslq	0(%rbp), %rsi
	movl	%r15d, %edx
	movq	%rax, 8(%r13)
	movq	%rax, %r12
	subl	%esi, %edx
	jmp	L64
L78:
	addl	%r14d, %eax
	movq	24(%r13), %rdi
	movl	%eax, %edx
	shrl	%edx
	orl	%edx, %eax
	movl	%eax, %edx
	shrl	$2, %edx
	orl	%edx, %eax
	movl	%eax, %edx
	shrl	$4, %edx
	orl	%edx, %eax
	movl	%eax, %edx
	shrl	$8, %edx
	orl	%edx, %eax
	movl	%eax, %edx
	shrl	$16, %edx
	orl	%edx, %eax
	leal	1(%rax), %esi
	movl	%esi, 20(%r13)
	call	_realloc
	movq	%rax, 24(%r13)
	movq	%rax, %rdi
	jmp	L79
L98:
	movl	%ebx, 32(%r13)
	jmp	L96
L143:
	movl	%edx, %ebx
	movl	$1, %esi
	xorl	%eax, %eax
	jmp	L75
L141:
	movslq	%r15d, %rsi
	movslq	%r15d, %r14
	movl	$1, %edi
	xorl	%edx, %edx
	jmp	L58
L148:
	movl	$62, %edx
L103:
	movl	%edx, 64(%r13)
L137:
	movl	36(%r13), %r8d
	leal	1(%r15), %eax
	cmpl	%r8d, %eax
	jae	L224
L106:
	cmpl	$43, %edx
	movb	$0, (%r14,%rbx)
	je	L225
L108:
	testl	%r15d, %r15d
	js	L138
	movq	$0, 16(%rsp)
	movl	32(%r13), %r15d
	movq	$0, 24(%rsp)
	movq	8(%r13), %r12
	cmpl	$10, %r15d
	jle	L226
	pxor	%xmm0, %xmm0
	cvtsi2ss	%r15d, %xmm0
	divss	LC11(%rip), %xmm0
	cvttss2si	%xmm0, %ebp
	movslq	%ebp, %rdi
	salq	$4, %rdi
	call	_malloc
	testl	%ebp, %ebp
	movq	%rax, %rbx
	jle	L35
	leal	-1(%rbp), %edx
	leaq	12(%rax), %rax
	salq	$4, %rdx
	leaq	28(%rbx,%rdx), %rdx
L36:
	movq	$-1, -12(%rax)
	addq	$16, %rax
	movb	$0, -16(%rax)
	movl	$0, -20(%rax)
	cmpq	%rdx, %rax
	jne	L36
L35:
	leaq	_seq_nt4_table(%rip), %r10
	subl	$1, %r15d
	xorl	%r8d, %r8d
	leaq	1(%r14,%r15), %r11
	xorl	%r15d, %r15d
	jmp	L41
L229:
	xorl	$3, %eax
	movq	16(%rsp), %rcx
	movzbl	%dl, %edi
	movzbl	%al, %esi
	movq	%rsi, %rax
	movq	24(%rsp), %rsi
	salq	$18, %rax
	leaq	0(,%rcx,4), %rdx
	orq	%rdx, %rdi
	shrq	$2, %rsi
	andl	$1048575, %edi
	orq	%rax, %rsi
	movq	%rdi, 16(%rsp)
	cmpq	%rsi, %rdi
	movq	%rsi, 24(%rsp)
	je	L37
	addl	$1, %r8d
	movl	$1717986919, %eax
	imull	%r8d
	movl	%edx, %eax
	movl	%r8d, %edx
	sarl	%eax
	sarl	$31, %edx
	subl	%edx, %eax
	leal	(%rax,%rax,4), %eax
	cmpl	%eax, %r8d
	jne	L38
	cmpl	$10, %r8d
	jle	L38
	addl	$1, %r15d
	cmpl	%r15d, %ebp
	jle	L227
L40:
	notq	%rdi
	notq	%rsi
	andl	$1048575, %edi
	andl	$1048575, %esi
	movq	%rdi, %rax
	salq	$8, %rax
	leaq	(%rax,%rdi,8), %rax
	addq	%rdi, %rax
	andl	$1048575, %eax
	movq	%rax, %rdi
	shrq	$14, %rax
	xorq	%rdi, %rax
	movq	%rax, %rdx
	salq	$4, %rdx
	leaq	(%rdx,%rax,4), %rdx
	addq	%rdx, %rax
	movq	%rsi, %rdx
	salq	$8, %rdx
	andl	$1048575, %eax
	leaq	(%rdx,%rsi,8), %rdx
	addq	%rdx, %rsi
	andl	$1048575, %esi
	movq	%rsi, %rdx
	shrq	$14, %rdx
	xorq	%rsi, %rdx
	movq	%rdx, %rsi
	salq	$4, %rsi
	leaq	(%rsi,%rdx,4), %rsi
	addq	%rsi, %rdx
	andl	$1048575, %edx
	cmpq	%rdx, %rax
	movslq	%r15d, %rax
	setbe	%dl
	salq	$4, %rax
	movq	%rdx, %rsi
	addq	%rbx, %rax
	andl	$1, %esi
	movq	16(%rsp,%rsi,8), %rsi
	cmpq	%rsi, (%rax)
	jbe	L37
	movq	%rsi, (%rax)
	movb	%dl, 12(%rax)
L37:
	addq	$1, %r14
	cmpq	%r11, %r14
	je	L228
L41:
	movzbl	(%r14), %eax
	movzbl	(%r10,%rax), %edx
	cmpl	$3, %edx
	movl	%edx, %eax
	jle	L229
	addq	$1, %r14
	xorl	%r8d, %r8d
	cmpq	%r11, %r14
	jne	L41
L228:
	movl	%r15d, %edx
	movq	%r12, %rsi
	xorl	%eax, %eax
	leaq	LC3(%rip), %rdi
	movq	%rbx, %rbp
	call	_printf
	leaq	160(%rbx), %r14
L42:
	leaq	LC4(%rip), %rdi
	addq	$16, %rbp
	call	_puts
	movq	-16(%rbp), %rsi
	leaq	LC5(%rip), %rdi
	xorl	%eax, %eax
	call	_printf
	movl	-8(%rbp), %esi
	leaq	LC6(%rip), %rdi
	xorl	%eax, %eax
	call	_printf
	movzbl	-4(%rbp), %esi
	leaq	LC7(%rip), %rdi
	xorl	%eax, %eax
	call	_printf
	movl	$10, %edi
	call	_putchar
	cmpq	%r14, %rbp
	jne	L42
	leal	-1(%r15), %ebp
	subl	$999, %r15d
	movslq	%ebp, %rax
	salq	$4, %rax
	leaq	8(%rbx,%rax), %rbx
L43:
	leaq	LC4(%rip), %rdi
	subl	$1, %ebp
	subq	$16, %rbx
	call	_puts
	movq	8(%rbx), %rsi
	leaq	LC5(%rip), %rdi
	xorl	%eax, %eax
	call	_printf
	movl	16(%rbx), %esi
	leaq	LC6(%rip), %rdi
	xorl	%eax, %eax
	call	_printf
	movzbl	20(%rbx), %esi
	leaq	LC7(%rip), %rdi
	xorl	%eax, %eax
	call	_printf
	movl	$10, %edi
	call	_putchar
	cmpl	%ebp, %r15d
	jle	L43
	movq	72(%r13), %rbp
	jmp	L33
L38:
	cmpl	$9, %r8d
	jle	L37
	cmpl	%r15d, %ebp
	jg	L40
L227:
	leaq	LC2(%rip), %rcx
	movl	$107, %edx
	leaq	LC1(%rip), %rsi
	leaq	___func__.4397(%rip), %rdi
	call	___assert_rtn
L204:
	movq	8(%r13), %r12
	xorl	%r14d, %r14d
	testq	%r12, %r12
	jne	L66
L218:
	movl	$1, %esi
	movl	$1, %edi
	movl	$1, 4(%r13)
	call	_calloc
	movq	%rax, 8(%r13)
	movq	%rax, %r12
	jmp	L66
L223:
	movl	$1, %esi
	movl	$1, %edi
	movl	$1, 36(%r13)
	movl	%r12d, %ebx
	call	_calloc
	movl	%r12d, %r15d
	movq	%rax, 40(%r13)
	leaq	(%rax,%rbx), %rdx
	movq	%rax, %r14
	jmp	L96
L225:
	cmpl	%r8d, 52(%r13)
	jb	L230
L109:
	movl	0(%rbp), %esi
	movl	4(%rbp), %eax
	jmp	L113
L231:
	cmpl	%eax, %esi
	jge	L138
L150:
	movq	24(%rbp), %rdi
	movslq	%esi, %rdx
	leal	1(%rdx), %esi
	movl	%esi, 0(%rbp)
	cmpb	$10, (%rdi,%rdx)
	je	L173
L113:
	testb	$3, 8(%rbp)
	jne	L231
	cmpl	%eax, %esi
	jl	L150
	movl	8(%rbp), %edx
	movl	$0, 0(%rbp)
	movq	24(%rbp), %rsi
	movq	16(%rbp), %rdi
	sarl	$2, %edx
	call	_gzread
	movl	8(%rbp), %edx
	movl	%eax, 4(%rbp)
	sarl	$2, %edx
	cmpl	%edx, %eax
	jge	L112
	movzbl	8(%rbp), %edx
	andl	$-4, %edx
	orl	$1, %edx
	movb	%dl, 8(%rbp)
L112:
	testl	%eax, %eax
	je	L138
	movslq	0(%rbp), %rdx
	movq	24(%rbp), %rdi
	leal	1(%rdx), %esi
	movl	%esi, 0(%rbp)
	cmpb	$10, (%rdi,%rdx)
	jne	L113
L173:
	movl	0(%rbp), %esi
	movl	4(%rbp), %eax
	cmpl	%eax, %esi
	jl	L126
	testb	$3, 8(%rbp)
	jne	L131
	.align 4
L126:
	cmpl	%esi, %eax
	jg	L116
	testb	$3, 8(%rbp)
	jne	L209
	movl	8(%rbp), %edx
	movl	$0, 0(%rbp)
	movq	24(%rbp), %rsi
	movq	16(%rbp), %rdi
	sarl	$2, %edx
	call	_gzread
	movl	8(%rbp), %edx
	movl	%eax, 4(%rbp)
	sarl	$2, %edx
	cmpl	%edx, %eax
	jge	L119
	movzbl	8(%rbp), %edx
	andl	$-4, %edx
	orl	$1, %edx
	movb	%dl, 8(%rbp)
L119:
	testl	%eax, %eax
	je	L209
	movl	0(%rbp), %esi
	cmpl	%esi, %eax
	jle	L152
L116:
	movq	24(%rbp), %rdi
	movslq	%esi, %rdx
	cmpb	$10, (%rdi,%rdx)
	je	L152
	leaq	1(%rdi,%rdx), %rdx
	movl	%esi, %ebx
	jmp	L122
	.align 4
L123:
	addq	$1, %rdx
	cmpb	$10, -1(%rdx)
	je	L208
L122:
	addl	$1, %ebx
	cmpl	%ebx, %eax
	jg	L123
L208:
	movl	%ebx, %eax
	subl	%esi, %eax
	leal	1(%rax), %esi
	movslq	%esi, %rsi
L121:
	movl	48(%r13), %r12d
	movl	52(%r13), %edx
	subl	%r12d, %edx
	cmpq	%rsi, %rdx
	jb	L124
	movq	56(%r13), %r14
L125:
	movslq	0(%rbp), %rsi
	movl	%ebx, %edx
	movl	%r12d, %edi
	addq	%r14, %rdi
	subl	%esi, %edx
	addq	24(%rbp), %rsi
	movslq	%edx, %rdx
	call	_memcpy
	leal	1(%rbx), %esi
	movl	%ebx, %eax
	subl	0(%rbp), %eax
	movl	%esi, 0(%rbp)
	addl	%eax, %r12d
	movl	4(%rbp), %eax
	movl	%r12d, 48(%r13)
	cmpl	%eax, %ebx
	jge	L126
	testq	%r14, %r14
	je	L232
L127:
	cmpl	$1, %r12d
	jbe	L210
	leal	-1(%r12), %eax
	movq	%rax, %rdx
	addq	%r14, %rax
	cmpb	$13, (%rax)
	je	L130
L210:
	movl	%r12d, %eax
	addq	%r14, %rax
L128:
	testl	%r12d, %r12d
	movb	$0, (%rax)
	js	L131
	cmpl	%r15d, %r12d
	jb	L173
L131:
	cmpl	%r15d, 48(%r13)
	movl	$0, 64(%r13)
	jne	L138
	movq	40(%r13), %r14
	jmp	L108
	.align 4
L124:
	addl	%r12d, %eax
	movq	56(%r13), %rdi
	movl	%eax, %edx
	shrl	%edx
	orl	%edx, %eax
	movl	%eax, %edx
	shrl	$2, %edx
	orl	%edx, %eax
	movl	%eax, %esi
	shrl	$4, %esi
	orl	%esi, %eax
	movl	%eax, %esi
	shrl	$8, %esi
	orl	%esi, %eax
	movl	%eax, %esi
	shrl	$16, %esi
	orl	%esi, %eax
	leal	1(%rax), %esi
	movl	%esi, 52(%r13)
	call	_realloc
	movq	%rax, 56(%r13)
	movq	%rax, %r14
	jmp	L125
L152:
	movl	%esi, %ebx
	xorl	%eax, %eax
	movl	$1, %esi
	jmp	L121
L209:
	movq	56(%r13), %r14
	movl	48(%r13), %r12d
	testq	%r14, %r14
	jne	L127
L232:
	movl	$1, %esi
	movl	$1, %edi
	movl	$1, 52(%r13)
	call	_calloc
	movl	%r12d, %edx
	movq	%rax, 56(%r13)
	addq	%rdx, %rax
	jmp	L128
L130:
	movl	%edx, 48(%r13)
	movl	%edx, %r12d
	jmp	L128
L100:
	orl	$-1, %edx
	jmp	L137
L224:
	movl	%eax, %esi
	movq	%r14, %rdi
	movl	%edx, 12(%rsp)
	shrl	%esi
	orl	%esi, %eax
	movl	%eax, %esi
	shrl	$2, %esi
	orl	%esi, %eax
	movl	%eax, %esi
	shrl	$4, %esi
	orl	%esi, %eax
	movl	%eax, %esi
	shrl	$8, %esi
	orl	%esi, %eax
	movl	%eax, %esi
	shrl	$16, %esi
	orl	%esi, %eax
	leal	1(%rax), %esi
	movl	%esi, 36(%r13)
	movl	%esi, 8(%rsp)
	call	_realloc
	movl	12(%rsp), %edx
	movq	%rax, 40(%r13)
	movq	%rax, %r14
	movl	8(%rsp), %r8d
	jmp	L106
L145:
	movl	%r12d, %ebx
	movq	%rbx, %r15
	jmp	L83
L220:
	movl	%esi, 16(%r13)
	jmp	L81
L149:
	movl	$43, %edx
	jmp	L137
L221:
	movl	$256, %edi
	movl	$256, 36(%r13)
	call	_malloc
	movq	%rax, 40(%r13)
	movq	%rax, %r14
	jmp	L82
L138:
	movq	8(%r13), %rdi
	call	_free
	movq	24(%r13), %rdi
	call	_free
	movq	40(%r13), %rdi
	call	_free
	movq	56(%r13), %rdi
	call	_free
	movq	72(%r13), %rbx
	testq	%rbx, %rbx
	je	L134
	movq	24(%rbx), %rdi
	call	_free
	movq	%rbx, %rdi
	call	_free
L134:
	movq	%r13, %rdi
	call	_free
	movq	(%rsp), %rdi
	call	_gzclose
	xorl	%eax, %eax
L198:
	addq	$40, %rsp
LCFI22:
	popq	%rbx
LCFI23:
	popq	%rbp
LCFI24:
	popq	%r12
LCFI25:
	popq	%r13
LCFI26:
	popq	%r14
LCFI27:
	popq	%r15
LCFI28:
	ret
L213:
LCFI29:
	movq	___stderrp@GOTPCREL(%rip), %rax
	movq	(%rsi), %rdx
	leaq	LC9(%rip), %rsi
	movq	(%rax), %rdi
	xorl	%eax, %eax
	call	_fprintf
	movl	$1, %eax
	jmp	L198
L230:
	movq	56(%r13), %rdi
	movl	%r8d, %esi
	movl	%r8d, 52(%r13)
	call	_realloc
	movq	%rax, 56(%r13)
	jmp	L109
L226:
	leaq	LC0(%rip), %rcx
	movl	$77, %edx
	leaq	LC1(%rip), %rsi
	leaq	___func__.4397(%rip), %rdi
	call	___assert_rtn
L219:
	movl	$1, %esi
	movl	$1, %edi
	movl	$1, 20(%r13)
	call	_calloc
	movq	%rax, 24(%r13)
	jmp	L81
LFE42:
	.section __TEXT,__text_cold,regular,pure_instructions
LCOLDE12:
	.section __TEXT,__text_startup,regular,pure_instructions
LHOTE12:
	.const
___func__.4397:
	.ascii "sketch\0"
	.globl _seq_nt4_table
	.data
	.align 6
_seq_nt4_table:
	.byte	0
	.byte	1
	.byte	2
	.byte	3
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	0
	.byte	4
	.byte	1
	.byte	4
	.byte	4
	.byte	4
	.byte	2
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	3
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	0
	.byte	4
	.byte	1
	.byte	4
	.byte	4
	.byte	4
	.byte	2
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	3
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.byte	4
	.literal4
	.align 2
LC11:
	.long	1084227584
	.section __TEXT,__eh_frame,coalesced,no_toc+strip_static_syms+live_support
EH_frame1:
	.set L$set$0,LECIE1-LSCIE1
	.long L$set$0
LSCIE1:
	.long	0
	.byte	0x1
	.ascii "zR\0"
	.byte	0x1
	.byte	0x78
	.byte	0x10
	.byte	0x1
	.byte	0x10
	.byte	0xc
	.byte	0x7
	.byte	0x8
	.byte	0x90
	.byte	0x1
	.align 3
LECIE1:
LSFDE1:
	.set L$set$1,LEFDE1-LASFDE1
	.long L$set$1
LASFDE1:
	.long	LASFDE1-EH_frame1
	.quad	LFB33-.
	.set L$set$2,LFE33-LFB33
	.quad L$set$2
	.byte	0
	.byte	0x4
	.set L$set$3,LCFI0-LFB33
	.long L$set$3
	.byte	0xe
	.byte	0x10
	.byte	0x8f
	.byte	0x2
	.byte	0x4
	.set L$set$4,LCFI1-LCFI0
	.long L$set$4
	.byte	0xe
	.byte	0x18
	.byte	0x8e
	.byte	0x3
	.byte	0x4
	.set L$set$5,LCFI2-LCFI1
	.long L$set$5
	.byte	0xe
	.byte	0x20
	.byte	0x8d
	.byte	0x4
	.byte	0x4
	.set L$set$6,LCFI3-LCFI2
	.long L$set$6
	.byte	0xe
	.byte	0x28
	.byte	0x8c
	.byte	0x5
	.byte	0x4
	.set L$set$7,LCFI4-LCFI3
	.long L$set$7
	.byte	0xe
	.byte	0x30
	.byte	0x86
	.byte	0x6
	.byte	0x4
	.set L$set$8,LCFI5-LCFI4
	.long L$set$8
	.byte	0xe
	.byte	0x38
	.byte	0x83
	.byte	0x7
	.byte	0x4
	.set L$set$9,LCFI6-LCFI5
	.long L$set$9
	.byte	0xe
	.byte	0x60
	.byte	0x4
	.set L$set$10,LCFI7-LCFI6
	.long L$set$10
	.byte	0xa
	.byte	0xe
	.byte	0x38
	.byte	0x4
	.set L$set$11,LCFI8-LCFI7
	.long L$set$11
	.byte	0xe
	.byte	0x30
	.byte	0x4
	.set L$set$12,LCFI9-LCFI8
	.long L$set$12
	.byte	0xe
	.byte	0x28
	.byte	0x4
	.set L$set$13,LCFI10-LCFI9
	.long L$set$13
	.byte	0xe
	.byte	0x20
	.byte	0x4
	.set L$set$14,LCFI11-LCFI10
	.long L$set$14
	.byte	0xe
	.byte	0x18
	.byte	0x4
	.set L$set$15,LCFI12-LCFI11
	.long L$set$15
	.byte	0xe
	.byte	0x10
	.byte	0x4
	.set L$set$16,LCFI13-LCFI12
	.long L$set$16
	.byte	0xe
	.byte	0x8
	.byte	0x4
	.set L$set$17,LCFI14-LCFI13
	.long L$set$17
	.byte	0xb
	.align 3
LEFDE1:
LSFDE3:
	.set L$set$18,LEFDE3-LASFDE3
	.long L$set$18
LASFDE3:
	.long	LASFDE3-EH_frame1
	.quad	LFB42-.
	.set L$set$19,LFE42-LFB42
	.quad L$set$19
	.byte	0
	.byte	0x4
	.set L$set$20,LCFI15-LFB42
	.long L$set$20
	.byte	0xe
	.byte	0x10
	.byte	0x8f
	.byte	0x2
	.byte	0x4
	.set L$set$21,LCFI16-LCFI15
	.long L$set$21
	.byte	0xe
	.byte	0x18
	.byte	0x8e
	.byte	0x3
	.byte	0x4
	.set L$set$22,LCFI17-LCFI16
	.long L$set$22
	.byte	0xe
	.byte	0x20
	.byte	0x8d
	.byte	0x4
	.byte	0x4
	.set L$set$23,LCFI18-LCFI17
	.long L$set$23
	.byte	0xe
	.byte	0x28
	.byte	0x8c
	.byte	0x5
	.byte	0x4
	.set L$set$24,LCFI19-LCFI18
	.long L$set$24
	.byte	0xe
	.byte	0x30
	.byte	0x86
	.byte	0x6
	.byte	0x4
	.set L$set$25,LCFI20-LCFI19
	.long L$set$25
	.byte	0xe
	.byte	0x38
	.byte	0x83
	.byte	0x7
	.byte	0x4
	.set L$set$26,LCFI21-LCFI20
	.long L$set$26
	.byte	0xe
	.byte	0x60
	.byte	0x4
	.set L$set$27,LCFI22-LCFI21
	.long L$set$27
	.byte	0xa
	.byte	0xe
	.byte	0x38
	.byte	0x4
	.set L$set$28,LCFI23-LCFI22
	.long L$set$28
	.byte	0xe
	.byte	0x30
	.byte	0x4
	.set L$set$29,LCFI24-LCFI23
	.long L$set$29
	.byte	0xe
	.byte	0x28
	.byte	0x4
	.set L$set$30,LCFI25-LCFI24
	.long L$set$30
	.byte	0xe
	.byte	0x20
	.byte	0x4
	.set L$set$31,LCFI26-LCFI25
	.long L$set$31
	.byte	0xe
	.byte	0x18
	.byte	0x4
	.set L$set$32,LCFI27-LCFI26
	.long L$set$32
	.byte	0xe
	.byte	0x10
	.byte	0x4
	.set L$set$33,LCFI28-LCFI27
	.long L$set$33
	.byte	0xe
	.byte	0x8
	.byte	0x4
	.set L$set$34,LCFI29-LCFI28
	.long L$set$34
	.byte	0xb
	.align 3
LEFDE3:
	.subsections_via_symbols
