;/*****************************************************************************/
; OSasm.s: low-level OS commands, written in assembly                       */
; Runs on LM4F120/TM4C123/MSP432
; Lab 3 starter file
; March 2, 2016




        AREA |.text|, CODE, READONLY, ALIGN=2
        THUMB
        REQUIRE8
        PRESERVE8

        EXTERN  RunPt            ; currently running thread
        EXPORT  StartOS
        EXPORT  SysTick_Handler
        IMPORT  Scheduler


SysTick_Handler                ; 1) Saves R0-R3,R12,LR,PC,PSR
    CPSID   I                  ; 2) Prevent interrupt during switch
   ;YOU IMPLEMENT THIS (same as Lab 2)
	PUSH {R4-R11}
	LDR R0, =RunPt ; store RunPt variable into R0
	LDR R1, [R0] ; dereference RunPt, to obtain TCB/sp variable address of the running thread, store it into R1
	STR SP, [R1] ; saving the CPU stack pointer address as current TCB's sp pointers value
	PUSH {R0, LR} ; be sure to save the link register as it is the address to return back from SysTick, don't override this
				  ; also this push is 8-bit aligned
	BL Scheduler
	POP {R0, LR} ; restore the link register
	LDR R1, [R0] ; get new TCB/sp variable by dereferencing RunPt now after the scheduling
	LDR SP, [R1] ; dereference the new TCB's sp pointer to get the value stored there: stack address, and set it as the CPU's stack pointer
	POP {R4-R11} ; restore these registers, the popped results go to these registers
    CPSIE   I                  ; 9) tasks run with interrupts enabled
    BX      LR                 ; 10) restore R0-R3,R12,LR,PC,PSR

StartOS
   ;YOU IMPLEMENT THIS (same as Lab 2)
	LDR R0, =RunPt ; load in RunPt address
	LDR R2, [R0] ; load in TCB/SP address
	LDR SP, [R2] ; load in TCB/SP value (which is an int32_t) to CPU stack
	POP {R4-R11} ; pop the top contents of the stack, R4-R11
	POP {R0-R3} ; pop the next section, R0-R3
	POP {R12} ; pop R12
	ADD SP,SP,#4 ; skip the link register, we don't have a starting point just yet to set
	POP {LR} ; Since we skipped the LR, we'll now pop the PC that we are on now and store that into the LR so we now have a starting point
	ADD SP,SP,#4 ; skip the PSR for some reason, guess it doesn't matter right now
    CPSIE   I                  ; Enable interrupts at processor level
    BX      LR                 ; start first thread

    ALIGN
    END
