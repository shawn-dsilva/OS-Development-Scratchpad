
;*******************************************************
;
;	Stage2.asm
;		Stage2 Bootloader
;
;	OS Development Series
;*******************************************************
section .kernel
bits	16
; Remember the memory map-- 0x500 through 0x7bff is unused above the BIOS data area.
; We are loaded at 0x500 (0x50:0)

jmp	main				; go to start

;*******************************************************
;	Preprocessor directives
;*******************************************************

;%include "stdio.inc"			; basic i/o routines
%include "Gdt.inc"			; Gdt routines
%include "A20.inc"			; A20 enabling

;*******************************************************
;	Data Section
;*******************************************************

;LoadingMsg db 0x0D, 0x0A, "Searching for Operating System...", 0x00

;*******************************************************
;	STAGE 2 ENTRY POINT
;
;		-Store BIOS information
;		-Load Kernel
;		-Install GDT; go into protected mode (pmode)
;		-Jump to Stage 3
;*******************************************************

main:

	;-------------------------------;
	;   Setup segments and stack	;
	;-------------------------------;

	cli				; clear interrupts
	xor	ax, ax			; null segments
	mov	ds, ax
	mov	es, ax
	mov	ax, 0x9000		; stack begins at 0x9000-0xffff
	mov	ss, ax
	mov	sp, 0xFFFF
	sti				; enable interrupts

	;-------------------------------;
	;   Install our GDT		;
	;-------------------------------;

	call	InstallGDT		; install our GDT

	;-------------------------------;
	;   Enable A20			;
	;-------------------------------;

	call	EnableA20_KKbrd_Out

	;-------------------------------;
	;   Print loading message	;
	;-------------------------------;


loading:
  mov si,text ; point si register to hello label memory location
  mov ah,0x0e ; 0x0e means 'Write Character in TTY mode'
.loop:
    lodsb
    or al,al ; is al == 0 ?
    jz EnterStage3 ; if (al == 0) jump to halt label
    int 0x10 ; runs BIOS interrupt 0x10 - Video Services
    jmp .loop

  text: db 0xD,0xA,"In Stage Two, GDT and A20 set, Starting Protected Mode ",0


	;-------------------------------;
	;   Go into pmode		;
	;-------------------------------;

EnterStage3:

	cli				; clear interrupts
	mov	eax, cr0		; set bit 0 in cr0--enter pmode
	or	eax, 1
	mov	cr0, eax

	jmp	CODE_DESC:Stage3	; far jump to fix CS

	; Note: Do NOT re-enable interrupts! Doing so will triple fault!
	; We will fix this in Stage 3.

;******************************************************
;	ENTRY POINT FOR STAGE 3
;******************************************************

bits 32

Stage3:

	;-------------------------------;
	;   Set registers		;
	;-------------------------------;

	mov		ax, DATA_DESC		; set data segments to data selector (0x10)
	mov		ds, ax
	mov		ss, ax
	mov		es, ax
	mov 	fs, ax
  mov 	gs, ax

	mov ebp, 0x90000
	mov esp, ebp

	; mov		esp, 90000h		; stack begins from 90000h

	extern kmain
	call kmain
	cli
	hlt
	;---------------------------------------;
	;   Clear screen and print success	;
	;---------------------------------------;

	; call		ClrScr32
	; mov		ebx, msg
	; call		Puts32

	; call 0x9000


	;---------------------------------------;
	;   Stop execution			;
	;---------------------------------------;

msg db  0x0A, "<[ OS Development Series Tutorial 10 ]>",  0x0A, 0
