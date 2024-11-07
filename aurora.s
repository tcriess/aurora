; aurora demo.
; 96k Atari ST intro for SillyVenture 2024 WE
    text

; keep timer c (0 = timer c off)
keep_c equ 0

; timer registers
enable_a        equ     $fffffa07
enable_b        equ     $fffffa09
mask_a  equ     $fffffa13
mask_b  equ     $fffffa15
a_control       equ     $fffffa19
b_control       equ     $fffffa1b
cd_control      equ     $fffffa1d
a_data  equ     $fffffa1f
b_data  equ     $fffffa21
vector  equ     $fffffa17

; DEBUG equ 1

; count lines with timer b
b_lines equ 228

bot_lines       equ     32

; into supervisor
    clr.l -(sp)
    move.w #$20,-(sp)
    trap #1
    addq.l #6,sp
    move.l d0,-(sp) ; put the old stack pointer on top

    jsr prepare_font
    jsr prepare_scrolltext

; timer c off (conditionally if keep_c == 0)
    ifeq keep_c
    move.b  mask_b.w,-(sp) ; store the old mask register B to the top of the stack 
    bclr.b  #5,mask_b.w ; bit 5 in the interrupt mask register B = timer C on/off
    endc

; init screen
    jsr init_screen

;; keep timers
;    lea old,a0
;    move.b enable_a.w,(a0)+        ; enable A
;    move.b enable_b.w,(a0)+        ; enable B
;    move.b mask_a.w,(a0)+          ; mask A
;    move.b mask_b.w,(a0)+          ; mask B
;    move.b a_control.w,(a0)+       ; A control
;    move.b b_control.w,(a0)+       ; B control
;    move.b cd_control.w,(a0)+      ; C & D control
;    move.b a_data.w,(a0)+          ; A data
;    move.b b_data.w,(a0)+          ; B data
;    move.b vector.w,(a0)+          ; interrupt vector register
;    move.l $134.w,(a0)+            ; timer A vector
;    move.l $120.w,(a0)+            ; timer B vector

; get the (new) screen address 2 (make sure it has the lower byte = 0)
    move.l #scrn2,d0
    add.l #255,d0
    clr.b d0
    move.l d0,d1
    lsr.l #8,d1
    move.w d1,hw_screen2
    move.w d1,hw_screen
    add.l #160,d0 ; skip 1. line
    move.l d0,screen2
    move.l d0,d1
    move.l d0,a5
    add.l #230*(28+200+bot_lines-64),d1
    addq.l #4,d1 ; planes 3+4 instead of 1+2
    move.l d1,scrollscraddr2 ; we start drawing in scrollscraddr2
    move.l d1,scrollscraddr
    lea screentable2,a3
    lea screenoffsettable,a6
    move.w #28+200+bot_lines,d7
.mkscreentable2:
    move.w d0,(a6)+
    move.l d0,(a3)+
    add.l #230,d0
    dbra d7,.mkscreentable2

    ; set the new palette
    ; movem.l my_pal,d0-d7
    movem.l pal_start,d0-d7
    movem.l d0-d7,$ffff8240.w

; get the (new) screen address (make sure it has the lower byte = 0)
    move.l #scrn,d0
    add.l #255,d0
    clr.b d0 ; clear the lower byte
    move.l d0,d1
    lsr.l #8,d1
    move.w d1,hw_screen1
    add.l #160,d0
    move.l d0,screen1 ; and store the result as the new screen address (this is actually "somewhere" beween "scrn" and "s")
    move.l d0,screen
    move.l d0,a6 ; also, store it in a6 to put some data in

; set the new (larger) screen address
    move.l d0,d1

    lea screentable1,a3
    move.w #28+200+bot_lines,d7
.mkscreentable1:
    move.l d0,(a3)+
    add.l #230,d0
    dbra d7,.mkscreentable1

    move.l d1,d0
    add.l #230*(28+200+bot_lines-64),d0 ; scroller is at address screenstart + 160 (first line) + 230 * 28 (upper border) + 230 * 228 (at the very end) - 230 * 64
    addq.l #4,d0 ; planes 3+4 instead of 1+2
    move.l d0,scrollscraddr1

    ; sooo, mal etwas grafik auf den screen
    
    ; now, there are 27 lines of the lower border
    ; we fill 19 lines now, then 8 lines with bricks
    rept 20
    ; the leftmost pixel (in hatari at least) is here 
    ; move.l #$04000400,(a6)+
    ; move.l #$04000400,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
; draw a left border
    move.l #0,(a6)+ ;  #$0ff00ff0,(a6)+
    move.l #0,(a6)+ ;  #$0ff00ff0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
; draw a right border
    move.l #0,(a6)+ ;  #$000f000f,(a6)+
    move.l #0,(a6)+ ;  #$000f000f,(a6)+
    move.l #0,(a6)+ ;  #$f000f000,(a6)+
    move.l #0,(a6)+ ;  #$f000f000,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+ ; #$00010001,(a6)+ <- rightmost visible pixel on hatari
    move.l #0,(a6)+ ; #$00010001,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.w #0,(a6)+ ; 57 * 4 + 2 bytes = 230 bytes

    endr

    rept 4
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #$000f0000,(a6)+
    move.l #$00000000,(a6)+
    move.l #$ffff0000,(a6)+
    move.l #$00000000,(a6)+
    move.l #$ffff0000,(a6)+
    move.l #$00000000,(a6)+
    move.l #$ffff0000,(a6)+
    move.l #$00000000,(a6)+
    move.l #$ffff0000,(a6)+
    move.l #$00000000,(a6)+
    move.l #$ffff0000,(a6)+
    move.l #$00000000,(a6)+
    move.l #$ffff0000,(a6)+
    move.l #$00000000,(a6)+
    move.l #$ffff0000,(a6)+
    move.l #$00000000,(a6)+
    move.l #$ffff0000,(a6)+
    move.l #$00000000,(a6)+
    move.l #$ffff0000,(a6)+
    move.l #$00000000,(a6)+
    move.l #$ffff0000,(a6)+
    move.l #$00000000,(a6)+
    move.l #$ffff0000,(a6)+
    move.l #$00000000,(a6)+
    move.l #$ffff0000,(a6)+
    move.l #$00000000,(a6)+
    move.l #$ffff0000,(a6)+
    move.l #$00000000,(a6)+
    move.l #$ffff0000,(a6)+
    move.l #$00000000,(a6)+
    move.l #$ffff0000,(a6)+
    move.l #$00000000,(a6)+
    move.l #$ffff0000,(a6)+
    move.l #$00000000,(a6)+
    move.l #$ffff0000,(a6)+
    move.l #$00000000,(a6)+
    move.l #$ffff0000,(a6)+
    move.l #$00000000,(a6)+
    move.l #$ffff0000,(a6)+
    move.l #$00000000,(a6)+
    move.l #$ffff0000,(a6)+
    move.l #$00000000,(a6)+
    move.l #$fff00000,(a6)+
    move.l #$00000000,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.w #0,(a6)+ ; 57 * 4 + 2 bytes = 230 bytes

    endr

    rept 4
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #$000f0000,(a6)+
    move.l #$00000000,(a6)+
    move.l #$0000ffff,(a6)+
    move.l #$00000000,(a6)+
    move.l #$0000ffff,(a6)+
    move.l #$00000000,(a6)+
    move.l #$0000ffff,(a6)+
    move.l #$00000000,(a6)+
    move.l #$0000ffff,(a6)+
    move.l #$00000000,(a6)+
    move.l #$0000ffff,(a6)+
    move.l #$00000000,(a6)+
    move.l #$0000ffff,(a6)+
    move.l #$00000000,(a6)+
    move.l #$0000ffff,(a6)+
    move.l #$00000000,(a6)+
    move.l #$0000ffff,(a6)+
    move.l #$00000000,(a6)+
    move.l #$0000ffff,(a6)+
    move.l #$00000000,(a6)+
    move.l #$0000ffff,(a6)+
    move.l #$00000000,(a6)+
    move.l #$0000ffff,(a6)+
    move.l #$00000000,(a6)+
    move.l #$0000ffff,(a6)+
    move.l #$00000000,(a6)+
    move.l #$0000ffff,(a6)+
    move.l #$00000000,(a6)+
    move.l #$0000ffff,(a6)+
    move.l #$00000000,(a6)+
    move.l #$0000ffff,(a6)+
    move.l #$00000000,(a6)+
    move.l #$0000ffff,(a6)+
    move.l #$00000000,(a6)+
    move.l #$0000ffff,(a6)+
    move.l #$00000000,(a6)+
    move.l #$0000ffff,(a6)+
    move.l #$00000000,(a6)+
    move.l #$0000ffff,(a6)+
    move.l #$00000000,(a6)+
    move.l #$0000ffff,(a6)+
    move.l #$00000000,(a6)+
    move.l #$00f0ff00,(a6)+
    move.l #$00000000,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.w #0,(a6)+ ; 57 * 4 + 2 bytes = 230 bytes

    endr

; save the initial sprite position
    move.l a6,a1
    add.l #24,a1
    sub.l #230*4,a1
    move.l a1,spr_position_addr

    rept 200
    ; the leftmost pixel (in hatari at least) is here 
    ; move.l #$04000400,(a6)+
    ; move.l #$04000400,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #$000f0000,(a6)+
    move.l #$00000000,(a6)+
; draw a left border
    move.l #$0000f000,(a6)+
    move.l #$00000000,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
; draw a right border
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #$00f00f00,(a6)+
    move.l #$00000000,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+ ; #$00010001,(a6)+ <- rightmost visible pixel on hatari
    move.l #0,(a6)+ ; #$00010001,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.w #0,(a6)+ ; 57 * 4 + 2 bytes = 230 bytes

    endr

; lower border
    rept 4
    ; the leftmost pixel (in hatari at least) is here 
    ; move.l #$04000400,(a6)+
    ; move.l #$04000400,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #$000f0000,(a6)+
    move.l #$00000000,(a6)+
; draw a left border
    move.l #$0000ffff,(a6)+
    move.l #$00000000,(a6)+
    move.l #$0000ffff,(a6)+
    move.l #$00000000,(a6)+
    move.l #$0000ffff,(a6)+
    move.l #$00000000,(a6)+
    move.l #$0000ffff,(a6)+
    move.l #$00000000,(a6)+
    move.l #$0000ffff,(a6)+
    move.l #$00000000,(a6)+
    move.l #$0000ffff,(a6)+
    move.l #$00000000,(a6)+
    move.l #$0000ffff,(a6)+
    move.l #$00000000,(a6)+
    move.l #$0000ffff,(a6)+
    move.l #$00000000,(a6)+
    move.l #$0000ffff,(a6)+
    move.l #$00000000,(a6)+
    move.l #$0000ffff,(a6)+
    move.l #$00000000,(a6)+
    move.l #$0000ffff,(a6)+
    move.l #$00000000,(a6)+
    move.l #$0000ffff,(a6)+
    move.l #$00000000,(a6)+
    move.l #$0000ffff,(a6)+
    move.l #$00000000,(a6)+
    move.l #$0000ffff,(a6)+
    move.l #$00000000,(a6)+
    move.l #$0000ffff,(a6)+
    move.l #$00000000,(a6)+
    move.l #$0000ffff,(a6)+
    move.l #$00000000,(a6)+
    move.l #$0000ffff,(a6)+
    move.l #$00000000,(a6)+
    move.l #$0000ffff,(a6)+
    move.l #$00000000,(a6)+
    move.l #$0000ffff,(a6)+
    move.l #$00000000,(a6)+
; draw a right border
    move.l #$0000ffff,(a6)+
    move.l #$00000000,(a6)+
    move.l #$00f0ff00,(a6)+
    move.l #$00000000,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+ ; #$00010001,(a6)+ <- rightmost visible pixel on hatari
    move.l #0,(a6)+ ; #$00010001,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.w #0,(a6)+ ; 57 * 4 + 2 bytes = 230 bytes

    endr

    rept 4
    ; the leftmost pixel (in hatari at least) is here 
    ; move.l #$04000400,(a6)+
    ; move.l #$04000400,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #$000f0000,(a6)+
    move.l #$00000000,(a6)+
; draw a left border
    move.l #$ffff0000,(a6)+
    move.l #$00000000,(a6)+
    move.l #$ffff0000,(a6)+
    move.l #$00000000,(a6)+
    move.l #$ffff0000,(a6)+
    move.l #$00000000,(a6)+
    move.l #$ffff0000,(a6)+
    move.l #$00000000,(a6)+
    move.l #$ffff0000,(a6)+
    move.l #$00000000,(a6)+
    move.l #$ffff0000,(a6)+
    move.l #$00000000,(a6)+
    move.l #$ffff0000,(a6)+
    move.l #$00000000,(a6)+
    move.l #$ffff0000,(a6)+
    move.l #$00000000,(a6)+
    move.l #$ffff0000,(a6)+
    move.l #$00000000,(a6)+
    move.l #$ffff0000,(a6)+
    move.l #$00000000,(a6)+
    move.l #$ffff0000,(a6)+
    move.l #$00000000,(a6)+
    move.l #$ffff0000,(a6)+
    move.l #$00000000,(a6)+
    move.l #$ffff0000,(a6)+
    move.l #$00000000,(a6)+
    move.l #$ffff0000,(a6)+
    move.l #$00000000,(a6)+
    move.l #$ffff0000,(a6)+
    move.l #$00000000,(a6)+
    move.l #$ffff0000,(a6)+
    move.l #$00000000,(a6)+
    move.l #$ffff0000,(a6)+
    move.l #$00000000,(a6)+
    move.l #$ffff0000,(a6)+
    move.l #$00000000,(a6)+
    move.l #$ffff0000,(a6)+
    move.l #$00000000,(a6)+
; draw a right border
    move.l #$ffff0000,(a6)+
    move.l #$00000000,(a6)+
    move.l #$fff00000,(a6)+
    move.l #$00000000,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+ ; #$00010001,(a6)+ <- rightmost visible pixel on hatari
    move.l #0,(a6)+ ; #$00010001,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.l #0,(a6)+
    move.w #0,(a6)+ ; 57 * 4 + 2 bytes = 230 bytes

    endr

    moveq #-1,d0
    ; new screen still in d1
    jsr set_scrn

    move.l screen1,a6
    move.l screen2,a5

    ; copy the contents of screen1 to screen2
    ; 160 + 230*27 + 230 * 200 + 230*bot_lines bytes
    move.w #(230*28+230*200+230*bot_lines)/4-1,d7
.cpyscr:
    move.l (a6)+,(a5)+
    dbra d7,.cpyscr

    ; initially save the sprite background
    ;lea spr_bg1,a0
    ;rept 16
    ;movem.l (a1),d0-d3
    ;movem.l d0-d3,(a0)
    ;lea 16(a0),a0
    ;lea 230(a1),a1
    ;endr

    lea raw_spr_cursor,a0
    lea spr_cursor,a1
    jsr prepare_sprite
    lea raw_spr_empty,a0
    lea spr_empty,a1
    jsr prepare_sprite
    lea raw_spr_cursor_legs1,a0
    lea spr_cursor_legs1,a1
    jsr prepare_sprite
    lea raw_spr_cursor_legs2,a0
    lea spr_cursor_legs2,a1
    jsr prepare_sprite
    jsr init_sprite
    ; jsr prepare_font

; fill the screen
;    move.w #screen_len/4-1,d1 ; longword = 4 bytes each
;fill:
;    move.l #$80808080,(a6)+ ; #$aaaaaaaa,(a6)+
;    dbra d1,fill

;; set up timer b
;    clr.b b_control.w ; timer b off
;    move.l #my_120,$120.w

;; set timer b mask on
;    bset.b #0,mask_a.w
;    bset.b #0,enable_a.w

* initialise sound chip
    ;bra end_init_mus 
	move.w	#$8800,a0

	move.l	#init_mus,a2

do_init_mus:
	move.w	(a2)+,d0
	bmi.s	end_init_mus

	movep.w	d0,0(a0)
	bra.s	do_init_mus

init_mus:
	dc.w	$0000
	dc.w	$0100
	dc.w	$0200
	dc.w	$0300
	dc.w	$0400
	dc.w	$0500
	dc.w	$0600
	dc.b	$07,%01111111
	dc.w	$0d00

	dc.w	-1

end_init_mus:

snd_keyclick macro
    lea.l keyclick,a6   ; 12
    move.l	#nos,a5		; 12 and numbers for chip

	move.b	(a6)+,2(a5)	; 16 put data into correct positions
	move.b	(a6)+,6(a5) ; 16
	move.b	(a6)+,$a(a5) ; 16
	move.b	(a6)+,$e(a5) ; 16
	move.b	(a6)+,$12(a5) ; 16
	move.b	(a6)+,$16(a5) ; 16
	move.b	(a6)+,$1a(a5) ; 16
	move.b	(a6)+,$1e(a5) ; 16
	move.b	(a6)+,$22(a5) ; 16
	move.b	(a6)+,$26(a5) ; 16
	move.b	(a6)+,$2a(a5) ; 16

    ; methinks that the following only works because of the
    ; so-called "shadow registers", i.e. register ff8800 is
    ; repeated from ff8800 to ff88ff or so, which means
    ; it is ok to put the complete data into ff8800
    ; but be aware that this won't work with falcon/tt,
    ; because there are no shadow registers!
    movem.l	(a5),a0-a3/d1-d7	; 100 slap all data into sound chip
	movem.l	a0-a3/d1-d7,$ffff8800.w ; 100 total of 11 long words (44 bytes!)
    endm ; destroys a0-a3,a5-a6,d1-d7, exactly 400 cycles

snd_reset macro
    lea.l sndrs,a6   ; 12
    move.l	#nos,a5		; 12 and numbers for chip

	move.b	(a6)+,2(a5)	; 16 put data into correct positions
	move.b	(a6)+,6(a5) ; 16
	move.b	(a6)+,$a(a5) ; 16
	move.b	(a6)+,$e(a5) ; 16
	move.b	(a6)+,$12(a5) ; 16
	move.b	(a6)+,$16(a5) ; 16
	move.b	(a6)+,$1a(a5) ; 16
	move.b	(a6)+,$1e(a5) ; 16
	move.b	(a6)+,$22(a5) ; 16
	move.b	(a6)+,$26(a5) ; 16
	move.b	(a6)+,$2a(a5) ; 16

    ; methinks that the following only works because of the
    ; so-called "shadow registers", i.e. register ff8800 is
    ; repeated from ff8800 to ff88ff or so, which means
    ; it is ok to put the complete data into ff8800
    ; but be aware that this won't work with falcon/tt,
    ; because there are no shadow registers!
    movem.l	(a5),a0-a3/d1-d7	; 100 slap all data into sound chip
	movem.l	a0-a3/d1-d7,$ffff8800.w ; 100 total of 11 long words (44 bytes!)
    endm ; destroys a0-a3,a5-a6,d1-d7, exactly 400 cycles
    
snd_keyclick2 macro
    move.b #$00,$ffff8800.w ; register 0 (chan 1)
    move.b #$3B,$ffff8802.w
    move.b #$01,$ffff8800.w ; register 1 (chan 1)
    move.b #$00,$ffff8802.w
    move.b #$02,$ffff8800.w ; register 2 (chan 2)
    move.b #$00,$ffff8802.w
    move.b #$03,$ffff8800.w ; register 3 (chan 2)
    move.b #$00,$ffff8802.w
    move.b #$04,$ffff8800.w ; register 4 (chan 3)
    move.b #$00,$ffff8802.w
    move.b #$05,$ffff8800.w ; register 5 (chan 3)
    move.b #$00,$ffff8802.w
    move.b #$06,$ffff8800.w ; register 6 (noise)
    move.b #$00,$ffff8802.w
    move.b #$07,$ffff8800.w ; register 7 (chan select)
    move.b #$FE,$ffff8802.w
    move.b #$08,$ffff8800.w ; register 8 (amplitude chan 1)
    move.b #$10,$ffff8802.w
    move.b #$09,$ffff8800.w ; register 9 (amplitude chan 2)
    move.b #$00,$ffff8802.w
    move.b #$0a,$ffff8800.w ; register 10 (amplitude chan 3)
    move.b #$00,$ffff8802.w
    move.b #$0B,$ffff8800.w ; register 11 (envelope)
    move.b #$80,$ffff8802.w ; bit 4 set means: use envelope
    move.b #$0C,$ffff8800.w ; register 12
    move.b #$01,$ffff8802.w
    move.b #$0D,$ffff8800.w ; register 13
    move.b #$03,$ffff8802.w
    endm

    ; try to shift one line by 1 byte in ~400 cycles
    ; only 1 plane
    ; 1 line = 230 bytes total
    ;rept 28
    ;move.b 1(a0),(a0)+
    ;move.b 7(a0),(a0)+
    ;addq.l #6,a0
    ;endr

    ;next try: shift by 1 word
    ;rept 14
    ;move.w 8(a0),(a0)+
    ;addq #6,a0
    ;endr ; 336 cycles



;; make sure the screen address is in a1
;    movea.l 128*4(a1),a6
;    lea.l scrolltable,a1
    
;    movea.l tpos,a0
;    moveq #0,d2
    
;    moveq #20-1,d1
;.l2             ; MOVEA.L (A1)+,A2    ;A2=DESTINATION
;    add.w (a1)+,d2
;    lea.l (a6,d2.w),a2 ; screen addr
;    movea.l (a0)+,a3    ;A3=SOURCE
;    ;rept 36
;    move.b (a3)+,(a2) ; 12 (2/1) 2
;    ;lea 160(a2),a2 ; 8 (2/0) 4
;    ;endr
;    add.w (a1)+,d2
;    addq #1,d2
;    lea.l (a6,d2.w),a2 ; screen addr
;    movea.l (a0)+,a3
;    ;rept 36
;    move.b (a3)+,(a2)
;    ;lea 160(a2),a2
;    ;endr
;    addq #7,d2
;    dbf d1,.l2
;    addq.l #4,tpos          ;INCREASE POSITION IN TEXT.

    ;jsr music+0

; set up vbl (will initialize timer b every time)
    move.l $70.w,-(sp) ; store old vbl on top of stack
    move.l #my_70,$70.w ; install new vbl!

; main program
    jsr inp ; wait for input

; restore vbl
    move.l (sp)+,$70.w

    ;jsr music+4

;; restore timers
;    lea old,a0
;    move.b  (a0)+,enable_a.w        ; enable A
;    move.b  (a0)+,enable_b.w        ; enable B
;    move.b  (a0)+,mask_a.w          ; mask A
;    move.b  (a0)+,mask_b.w          ; mask B
;    move.b  (a0)+,a_control.w       ; A control
;    move.b  (a0)+,b_control.w       ; B control
;    move.b  (a0)+,cd_control.w      ; C & D control
;    move.b  (a0)+,a_data.w          ; A data
;    move.b  (a0)+,b_data.w          ; B data
;    move.b  (a0)+,vector.w          ; interrupt vector register
;    move.l  (a0)+,$134.w            ; timer A vector
;    move.l  (a0)+,$120.w            ; timer B vector

; restore screen
    jsr restore

; timer c on (order here is important, remember: old mask b currently on top of stack)
    ifeq keep_c
    move.b (sp)+,mask_b.w 
    endc

; out of supervisor, remmeber the old stack address is still on top of stack
    move.w #$20,-(sp)
    trap #1
    addq.l #6,sp

; terminate
    clr.l -(sp)
    trap #1

; new vbl routine
my_70:
; interrupts off
    move.w sr,-(sp) ; store status register on top of stack
    or.w #$0700,sr ; interrupts off

    movem.l d0-d7/a0-a6,-(sp) ; store all registers

; original pause code
; pause for a bit - 1065 loops
;    move.w #1064,d0
;pause:
;    nop
;    dbra d0,pause ; nicht gesprungen (1x) 14 cycles, gesprungen (1064x) 12 cycles

; dbra seems to take 1x 14 cycles (counter expired) and 1064x 12 cycles (a little unclear why it is like that...)
; round-to-four means: 1x 16 cycles (counter exp) + 1064x 12 cycles (counter counting) + 1065x 4 cycles (nop) + 8 cycles (move) = 17052 cycles
; number of nops then 17052 / 4 = 4263

; it seems those 2 cycles are totally ok to go up or down (actually even a few more or less are ok at this stage)

; if there is no vbi counter:
;    rept 4263
;    nop
;    endr ; total of 4263 nops

; optional code in the spare cycles start

; first, toggle the screen addresses
    ; A - toggle the screen bit
    bchg.b #2,screen_toggle+1
    ; A: 24c (6 nops)
    ; B - set the current (draw, not shown) address to a0
    move.w screen_toggle,d0 ; d0.w is an indicator, in which screen we are (screen 1 or screen 2), it contains 0 or 4
    lea screens,a0
    movea.l 0(a0,d0.w),a0 ; 20 c? - screen address to use in a0
    ; B: 48c (12 nops)
    ; C - prepare the new hw screen address to set at the end of the interrupt routine
    lea hw_screens,a1
    move.w 2(a1,d0.w),d1
    move.w d1,hw_screen ; hw screen address to set at the end of the vbi routine, see below
    ; C: 44c (11 nops)
    ; D - set the screen table for line addresses on the current screen to a1
    lea screentables,a1
    movea.l 0(a0,d0.w),a1
    ; D: 32c (8 nops) - screen table in a1, screen address in a0

    ; E - sprite sequence
    lea current_sprite_sequence_struct,a3 ; currently executed sprite sequence position
    ; - 0w: counter
    ; - 2l: address of animated sprite definition
    ; - 6l: address of next entry in sequence
    lea current_ani_sprite_struct,a2 ; see below
    move.w (a3),d2 ; counter
    subq #1,d2
    bge.s .current_sprite_seq_cnt_ok
    ; things to do when the current sprite sequence counter is <0 (i.e. jump to the next entry in the sequence)
    ;INNER CODE 1
    move.l 6(a3),a4 ; a4: point to the next position in the sprite sequence
    move.w 10(a4),d3 ; 10(a4).w: offset to the next entry to avoid branching (can be negative or 0)
    move.w (a4),d2 ; new counter
    move.l 2(a4),a5 ; new animated sprite definition (delay, sprite address, next entry offset)
    move.l a5,d4
    tst.l d4
    ; check if it is != 0. if it is zero, keep the current animation and only update the position (screen + sprite offsets)
    beq.s .nonewani
    move.l a5,2(a3) ; update current_sprite_sequence_struct - address of animated sprite definition
    ; now we update the current_ani_sprite_stuct in a2
    move.w (a5),(a2) ; counter
    move.l 2(a5),2(a2) ; sprite data address
    add.w 6(a5),a5 ; next entry in ani
    move.l a5,10(a2)
    bra.s .newanicont
.nonewani:
    dcb.w 22,$4e71 ; 88c
    nop
    nop
.newanicont:
    move.w 6(a4),8(a2) ; screen offset
    move.w 8(a4),6(a2) ; sprite offset

    add.w d3,a4 ; next entry in the sprite sequence
    move.l a4,6(a3)
    ;/INNER CODE 1
    bra.s .current_sprite_seq_cont
.current_sprite_seq_cnt_ok:
    ; nops for INNER CODE 1
    dcb.w 58,$4e71 ; 232c

    ; following two nops to even out the cycles of the bge/bra construct
    nop
    nop
.current_sprite_seq_cont:
    move.w d2,(a3) ; write back the counter to current_sprite_sequence_struct
    ; E: 296c (74 nops)

    ; F - sprite handling part 1 - animated sprites (no sequence etc, just the animation)
    ; animated sprites are defined in a simple sequence which consists of
    ; - 0w: delay (or -1 for end-of-sequence)
    ; - 2l: pointer to the sprite data (base, will have to add the shift to that address)
    lea current_ani_sprite_struct,a2 ; currently displayed sprite
    ; this struct needs to contain:
    ; - 0w: counter which counts to (including) 0 (delay value)
    ; - 2l: pointer to the sprite data (base address)
    ; - 6w: offset to the correct shift (sprite_size_per_shift(384) bytes * shift (x % 16))
    ; - 8w: offset to the screen address (230 * y coordinate + x offset (x // 16 * 8))
    ; - 10l: pointer to the *next* position in the animated sprite definition (f.e. ani_spr_cursor)
    ; the struct is updated:
    ; - here, the counter is updated (-1) and
    ;   - if required, the animation data (+counter) is updated if the counter has run out
    ; - in the playbook code (below? above? we'll see)

    move.w (a2),d2 ; counter
    subq #1,d2
    bge.s .current_ani_spr_cnt_ok
    ; things to do when the current sprite counter is <0 (i.e. jump to the next sprite content in the animated sprite)
    ;INNER CODE 1
    move.l 10(a2),a3 ; point to the next position in the animated sprite definition
    move.w 6(a3),d3 ; to avoid branching, this is the offset to the next entry (can be negative)
    move.w (a3),d2 ; counter
    move.l 2(a3),2(a2) ; sprite data address
    add.w d3,a3
    move.l a3,10(a2) ; point to the next position
    ;/INNER CODE 1
    bra.s .current_spr_cont
.current_ani_spr_cnt_ok: ; counter is still >= 0, do nothing
   ; nops for INNER CODE 1
    dcb.w 22,$4e71 ; 132c

    ; following two nops to even out the cycles of the bge/bra construct
    nop
    nop
    ; 28c placeholder for now
.current_spr_cont:
    move.w d2,(a2) ; write back the counter to current_ani_sprite_struct
    ; F: 140c (35 nops)

    ; G - draw sprite
    ; a0 - screen address, a1 - screen table, a2 is still pointing to current_ani_sprite_struct
    move.l d0,-(sp) ; save d0 as it is destroyed
    lea spr_bgs,a5 ; the sprite backgrounds (1 or 2)
    move.l (a5,d0.w),a5 ; sprite background - address of correct sprite background struct in a5
    move.l (a5),a6 ; address on screen to put the old background back on in a6
    move.l a0,a4 ; screen address
    add.w 8(a2),a4 ; correct address to put the sprite
    move.l a4,(a5)+ ; save for later in the bg struct
    move.l 2(a2),a3 ; sprite data
    add.w 6(a2),a3 ; add offset to the correct shift -> address of final sprite data in a3
    
    rept 16
    ; restore old bg
    movem.l (a5),d0-d3 ; 44c
    movem.l d0-d3,(a6) ; 40c
    ; save bg
    movem.l (a4),d0-d3 ; 44c store the new background
    move.l d0,(a5)+ ; 12c
    move.l d1,(a5)+ ; 12c
    move.l d2,(a5)+ ; 12c
    move.l d3,(a5)+ ; 12c this seems faster than the "movem + add" version

    move.l (a3)+,d4 ; 12c mask left
    ;nop
    ;nop
    ;nop
    move.l (a3)+,d5 ; 12c mask right
    ;nop
    ;nop
    ;nop

    and.l d4,d0 ; 8c
    and.l d4,d1 ; 8c
    and.l d5,d2 ; 8c
    and.l d5,d3 ; 8c

    movem.l (a3)+,d4-d7 ; 44c
    ; dcb.w 11,$4e71
    or.l d4,d0 ; 8c
    or.l d5,d1 ; 8c
    or.l d6,d2 ; 8c
    or.l d7,d3 ; 8c
    movem.l d0-d3,(a4) ; 40c
    lea 230(a4),a4 ; 8c
    lea 230(a6),a6 ; 8c
    endr

    move.l (sp)+,d0 ; restore d0
    ; G: 5956c (1489 nops)

    ; second sprite - E2, F2, G2
    ; E2 - sprite sequence
    lea current_sprite_sequence_struct2,a3 ; currently executed sprite sequence position
    ; - 0w: counter
    ; - 2l: address of animated sprite definition
    ; - 6l: address of next entry in sequence
    lea current_ani_sprite_struct2,a2 ; see below
    move.w (a3),d2 ; counter
    subq #1,d2
    bge.s .current_sprite_seq_cnt_ok2
    ; things to do when the current sprite sequence counter is <0 (i.e. jump to the next entry in the sequence)
    ;INNER CODE 1
    move.l 6(a3),a4 ; a4: point to the next position in the sprite sequence
    move.w 10(a4),d3 ; 10(a4).w: offset to the next entry to avoid branching (can be negative or 0)
    move.w (a4),d2 ; new counter
    move.l 2(a4),a5 ; new animated sprite definition (delay, sprite address, next entry offset)
    move.l a5,d4
    tst.l d4
    ; check if it is != 0. if it is zero, keep the current animation and only update the position (screen + sprite offsets)
    beq.s .nonewani2
    move.l a5,2(a3) ; update current_sprite_sequence_struct - address of animated sprite definition
    ; now we update the current_ani_sprite_stuct in a2
    move.w (a5),(a2) ; counter
    move.l 2(a5),2(a2) ; sprite data address
    add.w 6(a5),a5 ; next entry in ani
    move.l a5,10(a2)
    bra.s .newanicont2
.nonewani2:
    dcb.w 22,$4e71 ; 88c
    nop
    nop
.newanicont2:
    move.w 6(a4),8(a2) ; screen offset
    move.w 8(a4),6(a2) ; sprite offset

    add.w d3,a4 ; next entry in the sprite sequence
    move.l a4,6(a3)
    ;/INNER CODE 1
    bra.s .current_sprite_seq_cont2
.current_sprite_seq_cnt_ok2:
    ; nops for INNER CODE 1
    dcb.w 58,$4e71 ; 232c

    ; following two nops to even out the cycles of the bge/bra construct
    nop
    nop
.current_sprite_seq_cont2:
    move.w d2,(a3) ; write back the counter to current_sprite_sequence_struct
    ; E2: 296c (74 nops)

    ; F2 - sprite handling part 1 - animated sprites (no sequence etc, just the animation)
    ; animated sprites are defined in a simple sequence which consists of
    ; - 0w: delay (or -1 for end-of-sequence)
    ; - 2l: pointer to the sprite data (base, will have to add the shift to that address)
    lea current_ani_sprite_struct2,a2 ; currently displayed sprite
    ; this struct needs to contain:
    ; - 0w: counter which counts to (including) 0 (delay value)
    ; - 2l: pointer to the sprite data (base address)
    ; - 6w: offset to the correct shift (sprite_size_per_shift(384) bytes * shift (x % 16))
    ; - 8w: offset to the screen address (230 * y coordinate + x offset (x // 16 * 8))
    ; - 10l: pointer to the *next* position in the animated sprite definition (f.e. ani_spr_cursor)
    ; the struct is updated:
    ; - here, the counter is updated (-1) and
    ;   - if required, the animation data (+counter) is updated if the counter has run out
    ; - in the playbook code (below? above? we'll see)

    move.w (a2),d2 ; counter
    subq #1,d2
    bge.s .current_ani_spr_cnt_ok2
    ; things to do when the current sprite counter is <0 (i.e. jump to the next sprite content in the animated sprite)
    ;INNER CODE 1
    move.l 10(a2),a3 ; point to the next position in the animated sprite definition
    move.w 6(a3),d3 ; to avoid branching, this is the offset to the next entry (can be negative)
    move.w (a3),d2 ; counter
    move.l 2(a3),2(a2) ; sprite data address
    add.w d3,a3
    move.l a3,10(a2) ; point to the next position
    ;/INNER CODE 1
    bra.s .current_spr_cont2
.current_ani_spr_cnt_ok2: ; counter is still >= 0, do nothing
   ; nops for INNER CODE 1
    dcb.w 22,$4e71 ; 132c

    ; following two nops to even out the cycles of the bge/bra construct
    nop
    nop
    ; 28c placeholder for now
.current_spr_cont2:
    move.w d2,(a2) ; write back the counter to current_ani_sprite_struct
    ; F2: 140c (35 nops)

    ; G2 - draw sprite 2
    ; a0 - screen address, a1 - screen table, a2 is still pointing to current_ani_sprite_struct
    move.l d0,-(sp) ; save d0 as it is destroyed
    lea spr_bgs2,a5 ; the sprite backgrounds (1 or 2)
    move.l (a5,d0.w),a5 ; sprite background - address of correct sprite background struct in a5
    move.l (a5),a6 ; address on screen to put the old background back on in a6
    move.l a0,a4 ; screen address
    add.w 8(a2),a4 ; correct address to put the sprite
    move.l a4,(a5)+ ; save for later in the bg struct
    move.l 2(a2),a3 ; sprite data
    add.w 6(a2),a3 ; add offset to the correct shift -> address of final sprite data in a3
    
    rept 16
    ; restore old bg
    movem.l (a5),d0-d3 ; 44c
    movem.l d0-d3,(a6) ; 40c
    ; save bg
    movem.l (a4),d0-d3 ; 44c store the new background
    move.l d0,(a5)+ ; 12c
    move.l d1,(a5)+ ; 12c
    move.l d2,(a5)+ ; 12c
    move.l d3,(a5)+ ; 12c this seems faster than the "movem + add" version

    move.l (a3)+,d4 ; 12c mask left
    ;nop
    ;nop
    ;nop
    move.l (a3)+,d5 ; 12c mask right
    ;nop
    ;nop
    ;nop

    and.l d4,d0 ; 8c
    and.l d4,d1 ; 8c
    and.l d5,d2 ; 8c
    and.l d5,d3 ; 8c

    movem.l (a3)+,d4-d7 ; 44c
    ; dcb.w 11,$4e71
    or.l d4,d0 ; 8c
    or.l d5,d1 ; 8c
    or.l d6,d2 ; 8c
    or.l d7,d3 ; 8c
    movem.l d0-d3,(a4) ; 40c
    lea 230(a4),a4 ; 8c
    lea 230(a6),a6 ; 8c
    endr

    move.l (sp)+,d0 ; restore d0
    ; G2: 5956c (1489 nops)

    ; H - palette sequence
    lea current_pal_sequence_struct,a3 ; currently executed palette sequence position
    ; - 0w: counter
    ; - 2l: address of palette
    ; - 6l: address of next entry in sequence
    ; sequence entry:
    ; - 0w: delay
    ; - 2l: address of palette
    ; - 6w: offset to next entry
    
    move.w (a3),d2 ; counter
    move.l 2(a3),a5 ; current palette
    subq #1,d2
    bge.s .current_pal_seq_cnt_ok
    ; things to do when the current pal sequence counter is <0 (i.e. jump to the next entry in the sequence)
    ;INNER CODE 1
    move.l 6(a3),a4 ; a4: point to the next position in the palette sequence
    move.w 6(a4),d3 ; 6(a4).w: offset to the next entry to avoid branching (can be negative or 0)
    move.w (a4),d2 ; new counter
    ;movem.l (a5),d4-d7/a0-a2/a6
    ;movem.l d4-d7/a0-a2/a6,$ffff8240.w
    move.l 2(a4),2(a3) ; next current palette
    add.w d3,a4 ; next entry in the sequence
    move.l a4,6(a3)
    ;/INNER CODE 1
    bra.s .current_pal_seq_cont
.current_pal_seq_cnt_ok:
    ; nops for INNER CODE 1
    ; dcb.w 64,$4e71 ; 256c-76-76-16
    dcb.w 22,$4e71 ; 88c

    ; following two nops to even out the cycles of the bge/bra construct
    nop
    nop
.current_pal_seq_cont:
    move.w d2,(a3) ; write back the counter to current_sprite_sequence_struct
    movem.l (a5),d4-d7/a0-a2/a6
    movem.l d4-d7/a0-a2/a6,$ffff8240.w
    ; H: 308c (77 nops)

    ; I - sound sequence
    lea current_snd_sequence_struct,a3 ; currently executed palette sequence position
    ; - 0w: counter
    ; - 2l: address of snd
    ; - 6l: address of next entry in sequence
    ; sequence entry:
    ; - 0w: delay
    ; - 2l: address of snd
    ; - 6w: offset to next entry
    
    move.w (a3),d2 ; counter
    move.l 2(a3),a5 ; current snd addr
    subq #1,d2
    bge.s .current_snd_seq_cnt_ok
    ; things to do when the current snd sequence counter is <0 (i.e. jump to the next entry in the sequence)
    ;INNER CODE 1
    move.l 6(a3),a4 ; a4: point to the next position in the palette sequence
    move.w 6(a4),d3 ; 6(a4).w: offset to the next entry to avoid branching (can be negative or 0)
    move.w (a4),d2 ; new counter
    move.l a5,play_sound

    move.l 2(a4),2(a3) ; next current snd
    add.w d3,a4 ; next entry in the sequence
    move.l a4,6(a3)
    ;/INNER CODE 1
    bra.s .current_snd_seq_cont
.current_snd_seq_cnt_ok:
    ; nops for INNER CODE 1
    dcb.w 27,$4e71 ; 108c

    ; following two nops to even out the cycles of the bge/bra construct
    nop
    nop
.current_snd_seq_cont:
    move.w d2,(a3) ; write back the counter to current_sprite_sequence_struct
    ; I: 176c (44 nops)
    

;; sprite code
;    lea spr_cursor,a3 ; 2 mask + 4 planes, 16 lines, 16 shifts
;    ; todo: pick the correct shift
;    lea spr_bg,a5 ; background buffer 16*16 bytes
;    movea.l spr_position_addr,a6 ; screen address

;    rept 16
;; restore bg
;    movem.l (a5),d0-d3
;    movem.l d0-d3,(a6)
;; todo: adjust screen addr to new position
;    movem.l (a6),d0-d3
;    move.l d0,(a5)+
;    move.l d1,(a5)+
;    move.l d2,(a5)+
;    move.l d3,(a5)+ ; this seems faster than the "movem + add" version
;    ;movem.l d0-d3,(a5)
;    ;add.l #16,a5 ; next line
;    movem.l (a3)+,d0-d3/a0-a1 ; 2 mask + 4 planes
;    movem.l (a6),d4-d7 ; 4 planes
;    and.l d0,d4 ; plane 1+2 left
;    and.l d0,d5 ; plane 3+4 left
;    and.l d1,d6 ; plane 1+2 right
;    and.l d1,d7 ; plane 3+4 right
;    or.l d2,d4
;    or.l d3,d5
;    move.l a0,d0
;    or.l d0,d6
;    move.l a1,d0
;    or.l d0,d7
;    movem.l d4-d7,(a6)
;    lea.l 230(a6),a6
;    endr ; 6208 cycles

;    lea spr_cursor_mask,a4
;    lea spr_cursor_data,a3
;    lea spr_bg,a5
;    movea.l spr_position_addr,a6
;
;    rept 16
;; restore bg
;    move.l (a5),(a6)
;    move.l 4(a5),8(a6)
;; store bg
;    move.l (a6),d0
;    move.l 8(a6),d1
;    move.l d0,(a5)+
;    move.l d1,(a5)+
;    ; unfortunately, movem.l d0-d1,(a5)+ is not supported
;; mask
;    movem.l (a4)+,d2-d3
;    and.l d2,d0
;    and.l d3,d1
;; sprite data
;    movem.l (a3)+,d2-d3
;    or.l d2,d0
;    or.l d3,d1
;    move.l d0,(a6)
;    move.l d1,8(a6)

;    lea.l 230(a6),a6 ; next line
;    endr ; 3584 cycles

; optional code end - 6400+12+12+20 cycles = 6444 cycles = 1611 nops
    ; add the remaining cycles to a total of 4263 nops
    ;dcb.w 4263,$4e71
    ;dcb.w 2652,$4e71
    ;dcb.w 2594,$4e71
    ;dcb.w 4226,$4e71

    ; actually, it seems more stable with a total of 4267 nops
    ; dcb.w 4192,$4e71 ; A-E
    ;dcb.w 2704,$4e71 ; A-G ohne E
    ;dcb.w 2630,$4e71 ; A-G
    ;dcb.w 2553,$4e71 ; A-H
    ;dcb.w 2509,$4e71 ; A-I, without E2-G2
    dcb.w 911,$4e71 ; A-I, with E2-G2

; to 60Hz
    eor.b #2,$ffff820a.w

    rept 8
    nop
    endr

; back to 50Hz
    eor.b #2,$ffff820a.w

; prepare registers
    move.w  #$8209,a0 ; screen counter (video address low byte)
    lea     $ff8260,a1      ; resolution
    moveq   #0,d0
    moveq   #16,d1
    moveq   #2,d3
    moveq   #0,d4

.wait:
    move.b  (a0),d0
    beq.s   .wait ; wait for video address low byte != 0

    if DEBUG
    eor.w   #$f0f,$ffff8240.w ; do sth with palette bg color (remove this in production!)
    else
    dcb.w 5,$4e71
    endif

    sub.w   d0,d1 ; d0 <> 0, d1 = 16 => d1 = 16 - d0
    lsl.w   d1,d0 ; probably some trick to sync with the correct number of cycles without hassle (i.e. "synchronize" the cpu)

    ; SYNC is done here!
    
    if DEBUG
    eor.w   #$f0f,$ffff8240.w ; reset palette bg color (remove this in production!)
    else
    dcb.w 5,$4e71
    endif

    move.w #$820a,a0
    ; up to this point, after the wait: 58 cycles


    movea.l scrollscraddr,a6 ; 20 c / 5 nops
    move.l font_addr1,a3
    move.l font_addr2,a4
    move.w fontoffset1,d4
    move.w fontoffset2,d5
    add.w d4,a3
    add.w d5,a4

    movea.l scrollscraddr,a6 ; put the start address of the first line of the scroller in a6
    move.l a6,a5
    lea 216(a5),a5 ; end of the line, this is where we put the new char data

;    ; we are in the first line, we'll do some initialization stuff for the scroller here
;    movea.l scrollscraddr,a6 ; put the start address of the first line of the scroller in a6
;    move.l a6,a5
;    lea 216(a5),a5 ; end of the line, this is where we put the new char data
;    lea font,a4 ; start of font
;    move.l scrollpos,a3
;    move.w (a3),d0
;
;    bge.s .contscroll
;
;    lea scrolltextbuffer,a3
;    move.w #0,d0
;    bra.s .contscroll2
;.contscroll:
;    addq.l #2,a3
;    dcb.w   5,$4e71 ; 5*4 = 20 cycles
;.contscroll2:
;    move.l a3,scrollpos
;    add.w d0,a4
;    ;lea 0(a4,d0.w),a4 ; not 12! it is 16 cycles!
;    move.l font_addr1,a3
;    add.w d0,a3
;    move.l font_addr2,a4
;    add.w d0,a4
    ; move.l a4,a3

    ; a6: scroller start, used to do the byte shifting
    ; a5: start of the rightmost word to feed in new data
    ; a4: new data (for now: first character in font)

    dcb.w   50,$4e71 ; total 368 cycles in the first line after sync
    ;dcb.w   85,$4e71 ; 340 cycles = total 368 cycles in the first line after sync

    nop
; every line of the scroller needs *2* lines of byte shifting, unfortunately
; so we start the shifting here and go on for the next 128 lines to have a 64 lines-scroller
; the following rept contains 2 lines
    rept 64
    
* LEFT HAND BORDER!
    move.b  d3,(a1)         ; to monochrome
    move.b  d4,(a1)         ; to lo-res

    nop
    
    move.l 8(a6),(a6)+ ; 1.
    addq #4,a6

    move.l 8(a6),(a6)+ ; 2.
    addq #4,a6

    move.l 8(a6),(a6)+ ; 3.
    addq #4,a6

    move.l 8(a6),(a6)+ ; 4.
    addq #4,a6

    move.l 8(a6),(a6)+ ; 5.
    addq #4,a6

    move.l 8(a6),(a6)+ ; 6.
    addq #4,a6

    move.l 8(a6),(a6)+ ; 7.
    addq #4,a6

    move.l 8(a6),(a6)+ ; 8.
    addq #4,a6

    move.l 8(a6),(a6)+ ; 9.
    addq #4,a6

    move.l 8(a6),(a6)+ ; 10.
    addq #4,a6

    move.l 8(a6),(a6)+ ; 11.
    addq #4,a6
    ; 356 cycles (88 of 224 bytes are handled (for 1 line))

* RIGHT AGAIN...
    move.b  d4,(a0)
    move.b  d3,(a0)

    ;dcb.w   13,$4e71 ; 52 cycles
    move.l 8(a6),(a6)+ ; 12.
    addq #4,a6
    move.w 8(a6),(a6)+ ; 12.5
    nop

* EXTRA!
    move.b  d3,(a1)
    nop
    move.b  d4,(a1)

    ; dcb.w   12,$4e71 ; 48 cycles
    move.w 8(a6),(a6)+ ; 13.
    addq #4,a6
    move.l 8(a6),(a6)+ ; 14./28, 14 to go
    ; need to adjust a6 addq #4,a6

; second line
    nop
* LEFT HAND BORDER!
    move.b  d3,(a1)         ; to monochrome
    move.b  d4,(a1)         ; to lo-res

    addq #4,a6 ; adjustment which was missing from above

    move.l 8(a6),(a6)+ ; 15.
    addq #4,a6

    move.l 8(a6),(a6)+ ; 16.
    addq #4,a6

    move.l 8(a6),(a6)+ ; 17.
    addq #4,a6

    move.l 8(a6),(a6)+ ; 18.
    addq #4,a6

    move.l 8(a6),(a6)+ ; 19.
    addq #4,a6

    move.l 8(a6),(a6)+ ; 20.
    addq #4,a6

    move.l 8(a6),(a6)+ ; 21.
    addq #4,a6

    move.l 8(a6),(a6)+ ; 22.
    addq #4,a6

    move.l 8(a6),(a6)+ ; 23.
    addq #4,a6

    move.l 8(a6),(a6)+ ; 24.
    addq #4,a6

    move.l 8(a6),(a6)+ ; 25.
    nop

* RIGHT AGAIN...
    move.b  d4,(a0)
    move.b  d3,(a0)

    ; dcb.w   13,$4e71 ; 52 cycles
    addq #4,a6
    move.l 8(a6),(a6)+ ; 26.
    addq #4,a6
    nop
    nop
    nop

* EXTRA!
    move.b  d3,(a1)
    nop
    move.b  d4,(a1)

    ;dcb.w   12,$4e71 ; 48 cycles
    move.l 8(a6),(a6)+ ; 27.
    ;addq #4,a6
    ; 28. column is not there yet..., so we add 4, then 8 (to skip the last column completely)
    ;  and then 6 for the extra 6 bytes per line
    ; (the last column will then be filled by the code in the following lines, feeding character data from the right)
    lea 18(a6),a6
    ;move.l (a4)+,(a6)+ ; new data in a4...
    nop
    nop
    nop
    nop
    nop

    endr

    ; until the bottom border we have 227 lines to process, 128 are done, so there are 99 lines left

; feed in new font data from the right at the scroller position

; for the 8-bit-shift, try to replace this:
;    move.l (a4)+,(a5) ; 24 cycles
; with something like this:
;    move.l (a3)+,d0 ; 12 cycles a3 points to the (left-)shifted previous character
;    or.l (a4)+,d0   ; 16(14) cycles a4 points to the (right-)shifted new character
;    move.l d0,(a5) ; 12/16 cycles, total of 40/44 cycles (instead of 20/24)
; if a3=a4 as before, the result should be the same!

; 129.-136. line: feed in 8 lines at a time
    rept 8
    ; nop

* LEFT HAND BORDER!
    move.b  d3,(a1)         ; to monochrome 8 cycles
    move.b  d4,(a1)         ; to lo-res     8 cycles
    ; now we have 356 cycles to copy data
    ; 1. line
    move.l (a3)+,d0 ; 12 cycles a3 points to the (left-)shifted previous character
    or.l (a4)+,d0   ; 16(14) cycles a4 points to the (right-)shifted new character
    move.l d0,(a5) ; 12 cycles, total of 40 cycles (instead of 20)
    ; 40
    ; 2. line
    move.l (a3)+,d0 ; 12 cycles a3 points to the (left-)shifted previous character
    or.l (a4)+,d0   ; 16(14) cycles a4 points to the (right-)shifted new character
    move.l d0,230(a5) ; 16 cycles, total of 44 cycles (instead of 24)
    ; 84
    ; 3. line
    move.l (a3)+,d0 ; 12 cycles a3 points to the (left-)shifted previous character
    or.l (a4)+,d0   ; 16(14) cycles a4 points to the (right-)shifted new character
    move.l d0,2*230(a5) ; 16 cycles, total of 44 cycles (instead of 24)
    ; 128
    ; 4. line
    move.l (a3)+,d0 ; 12 cycles a3 points to the (left-)shifted previous character
    or.l (a4)+,d0   ; 16(14) cycles a4 points to the (right-)shifted new character
    move.l d0,3*230(a5) ; 16 cycles, total of 44 cycles (instead of 24)
    ; 172
    ; 5. line
    move.l (a3)+,d0 ; 12 cycles a3 points to the (left-)shifted previous character
    or.l (a4)+,d0   ; 16(14) cycles a4 points to the (right-)shifted new character
    move.l d0,4*230(a5) ; 16 cycles, total of 44 cycles (instead of 24)
    ; 216
    ; 6. line
    move.l (a3)+,d0 ; 12 cycles a3 points to the (left-)shifted previous character
    or.l (a4)+,d0   ; 16(14) cycles a4 points to the (right-)shifted new character
    move.l d0,5*230(a5) ; 16 cycles, total of 44 cycles (instead of 24)
    ; 260
    ; 7. line
    move.l (a3)+,d0 ; 12 cycles a3 points to the (left-)shifted previous character
    or.l (a4)+,d0   ; 16(14) cycles a4 points to the (right-)shifted new character
    move.l d0,6*230(a5) ; 16 cycles, total of 44 cycles (instead of 24)
    ; 304
    ; 8. line
    move.l (a3)+,d0 ; 12 cycles a3 points to the (left-)shifted previous character
    or.l (a4)+,d0   ; 16(14) cycles a4 points to the (right-)shifted new character
    move.l d0,7*230(a5) ; 16 cycles, total of 44 cycles (instead of 24)
    ; 348
    ; two nops to 356, or: advance the a5 address by 8 lines
    lea 8*230(a5),a5

* RIGHT AGAIN...
    move.b  d4,(a0) ; 8 cycles
    move.b  d3,(a0) ; 8 cycles

    dcb.w   13,$4e71 ; 13*4 = 52 cycles

* EXTRA!
    move.b  d3,(a1) ; 8 cycles
    nop ; 4 cycles
    move.b  d4,(a1) ; 8 cycles

    dcb.w   13,$4e71 ; 13*4 = 52 cycles
    endr

; 91 lines until the bottom border, we split this into the final 31 lines and the top 60 lines (the final 31 lines contain the scrolltext)!
    rept    60

* LEFT HAND BORDER!
    move.b  d3,(a1)         ; to monochrome 8 cycles
    move.b  d4,(a1)         ; to lo-res     8 cycles    

    dcb.w   89,$4e71 ; 89*4 = 356 cycles

* RIGHT AGAIN...
    move.b  d4,(a0) ; 8 cycles
    move.b  d3,(a0) ; 8 cycles

    dcb.w   13,$4e71 ; 13*4 = 52 cycles

* EXTRA!
    move.b  d3,(a1) ; 8 cycles
    nop ; 4 cycles
    move.b  d4,(a1) ; 8 cycles

    dcb.w   13,$4e71 ; 13*4 = 52 cycles
    endr ; 512 cycles per line

; here starts the scroller, so we can adjust the palette in the following 64 lines
; first line is special as we load the address registers
* LEFT HAND BORDER!
    move.b  d3,(a1)         ; to monochrome 8 cycles
    move.b  d4,(a1)         ; to lo-res     8 cycles    

    ;dcb.w   89,$4e71 ; 89*4 = 356 cycles
    dcb.w   62,$4e71
    lea scrollerpals,a5 ; 12c
    move.l (a5)+,a2
    move.w #$8240,a6 ; 8c
    movem.l (a2),d0-d2/d5-d7/a3-a4 ; 76c

* RIGHT AGAIN...
    move.b  d4,(a0) ; 8 cycles
    move.b  d3,(a0) ; 8 cycles

    ;dcb.w   13,$4e71 ; 13*4 = 52 cycles
    nop
    move.l d7,24(a6) ; 16c
    move.l a3,28(a6) ; 16c
    move.l a4,32(a6) ; 16c
* EXTRA!
    move.b  d3,(a1) ; 8 cycles
    nop ; 4 cycles
    move.b  d4,(a1) ; 8 cycles

    ;dcb.w   13,$4e71 ; 13*4 = 52 cycles
    nop
    movem.l d0-d2/d5-d6,(a6) ; 48c

    rept    30
* LEFT HAND BORDER!
    move.b  d3,(a1)         ; to monochrome 8 cycles
    move.b  d4,(a1)         ; to lo-res     8 cycles    

    ;dcb.w   89,$4e71 ; 89*4 = 356 cycles
    dcb.w   65,$4e71
    move.l (a5)+,a2 ; 12c
    move.w #$8240,a6 ; 8c
    movem.l (a2),d0-d2/d5-d7/a3-a4 ; 76c

* RIGHT AGAIN...
    move.b  d4,(a0) ; 8 cycles
    move.b  d3,(a0) ; 8 cycles

    ;dcb.w   13,$4e71 ; 13*4 = 52 cycles
    nop
    move.l d7,24(a6) ; 16c
    move.l a3,28(a6) ; 16c
    move.l a4,32(a6) ; 16c
* EXTRA!
    move.b  d3,(a1) ; 8 cycles
    nop ; 4 cycles
    move.b  d4,(a1) ; 8 cycles

    ;dcb.w   13,$4e71 ; 13*4 = 52 cycles
    nop
    movem.l d0-d2/d5-d6,(a6) ; 48c
    endr ; 512 cycles per line


* FINAL LINE...
* LEFT HAND BORDER!
    move.b  d3,(a1)         ; to monochrome 8 cycles
    move.b  d4,(a1)         ; to lo-res 8 cycles

    ;dcb.w   43,$4e71
    ;move.l  #$ffff8240,a3
    ;lea     scrollerpalred1,a4
    ;move.l (a4)+,(a3)+
    ;move.l (a4)+,(a3)+
    ;move.l (a4)+,(a3)+
    ;move.l (a4)+,(a3)+
    ;move.l (a4)+,(a3)+
    ;move.l (a4)+,(a3)+
    ;move.l (a4)+,(a3)+
    ;move.l (a4)+,(a3)+

    dcb.w   89,$4e71 ; 89*4 = 356 cycles

* RIGHT AGAIN...
    move.b  d4,(a0) ; 8 cycles
    move.b  d3,(a0) ; 8 cycles

    dcb.w   13,$4e71 ; 13*4 = 52 cycles

* EXTRA!
    move.b  d3,(a1) ; 8 cycles
    nop ; 4 cycles
    move.b  d4,(a1) ; 8 cycles

* BUST BOTTOM BORDER...
; mh, the following seems to only work in wakestate 1 & 3
;    dcb.w   8,$4e71 ; 8*4 = 32 cycles
;    move.b  d4,(a0) ; 8 cycles
;    move.b  d3,(a0) ; 8 cycles
    dcb.w   8,$4e71 ; 8*4 = 32 cycles
    move.b  d4,(a0) ; 8 cycles
    nop
    move.b  d3,(a0) ; 8 cycles

; total of 512 cycles here also

    rept    bot_lines

* LEFT HAND BORDER!
    move.b  d3,(a1)         ; to monochrome
    move.b  d4,(a1)         ; to lo-res

    ;dcb.w   43,$4e71
    ;move.l  #$ffff8240,a3
    ;lea     my_pal,a4
    ;move.l (a4)+,(a3)+
    ;move.l (a4)+,(a3)+
    ;move.l (a4)+,(a3)+
    ;move.l (a4)+,(a3)+
    ;move.l (a4)+,(a3)+
    ;move.l (a4)+,(a3)+
    ;move.l (a4)+,(a3)+
    ;move.l (a4)+,(a3)+

    dcb.w   89,$4e71 ; 356 cycles

* RIGHT AGAIN...
    move.b  d4,(a0)
    move.b  d3,(a0)

    dcb.w   13,$4e71 ; 52 cycles
* EXTRA!
    move.b  d3,(a1)
    nop
    move.b  d4,(a1)

    dcb.w   13,$4e71 ; 48 cycles
    
    endr ; same as before, 512 cycles per line

    ; now, the time critical stuff is done, and we still have a few cycles for sound...

; start counter handling
    move.l play_sound,d5
    tst.l d5
    beq .nosound
    move.l d5,a5
    move.w #$8800,a6

    move.w (a5)+,d5
    movep.w d5,0(a6) ; reg 0
    move.w (a5)+,d5
    movep.w d5,0(a6) ; reg 1
    move.w (a5)+,d5
    movep.w d5,0(a6) ; reg 2
    move.w (a5)+,d5
    movep.w d5,0(a6) ; reg 3
    move.w (a5)+,d5
    movep.w d5,0(a6) ; reg 4
    move.w (a5)+,d5
    movep.w d5,0(a6) ; reg 5
    move.w (a5)+,d5
    movep.w d5,0(a6) ; reg 6
    move.w (a5)+,d5
    movep.w d5,0(a6) ; reg 7
    move.w (a5)+,d5
    movep.w d5,0(a6) ; reg 8
    move.w (a5)+,d5
    movep.w d5,0(a6) ; reg 9
    move.w (a5)+,d5
    movep.w d5,0(a6) ; reg 10
    move.w (a5)+,d5
    movep.w d5,0(a6) ; reg 11
    move.w (a5)+,d5
    movep.w d5,0(a6) ; reg 12
    move.w (a5)+,d5
    movep.w d5,0(a6) ; reg 13

    move.l #0,play_sound
.nosound:
    ; todo: get rid of most of the following code, it is not required any more
    move.w curr_blink,d0
    subq #1,d0
    tst.b d0
    bne cont_blink3

do_blink2:
    ; eor.w   #$0f0,$ffff8240.w ; do sth with palette bg color
 
    move.w blink_rate,d0
    ;lsl.w #1,d0

cont_blink3:
    move.w d0,curr_blink
; end counter handling

    move.l scrollpos,a2
    move.w -2(a2),d5
    move.w (a2),d4
    bge.s .contscroll3

    lea scrolltextbuffer,a2 ; 12 c / 3 nops
    move.w (a2),d4 ; 8 c / 2 nops

;    bra.s .contscroll4 ; 12 c / 3 nops
.contscroll3:

;.contscroll4:
    ;move.l a2,scrollpos ; 20 c / 5 nops

; last thing before exiting: set new screen address in hw regs
    move.w hw_screen,d7
    move.w #$8201,a0
    movep.w d7,0(a0)

    and.b #1,d0
    beq.s switch_scr1

    move.w hw_screen2,d0
    move.l scrollscraddr1,scrollscraddr
    move.l #font,font_addr1
    move.l #font,font_addr2
    move.w d4,d5

    addq.l #2,a2
    move.l a2,scrollpos

    bra.s switch_scr
switch_scr1:
    move.w hw_screen1,d0
    move.l scrollscraddr2,scrollscraddr
    move.l #font_shift_r,font_addr1
    move.l #font_shift_l,font_addr2

switch_scr:
    move.w d4,fontoffset1
    move.w d5,fontoffset2

exit_vbi:
; restore registers
    movem.l (sp)+,d0-d7/a0-a6
    move.w  (a7)+,sr

    rte

; initialize screen
init_screen:
; mouse off
    move.w  #34,-(sp)
    trap    #14             ; get table
    addq.l  #2,sp    
    move.l  d0,a0
    move.l  16(a0),mouse_vec        ; store mouse vector
    pea     0.w
    pea     0.w
    pea     0.w
    trap    #14             ; mouse off
    lea     12(sp),sp

; get the logical screen address (mostly to make it easier to debug, as devpac's mon messes with the phys base)
    move.w  #3,-(sp)
    trap    #14
    addq.l  #2,sp
    move.l  d0,logbase      ; keep old screen address

; get the current resolution
    move.w  #4,-(sp)
    trap    #14             ; get res
    addq.l  #2,sp
    move.w  d0,res          ; store it

; now get the palette
    move.l  #$ffff8240,a0
    lea     pal,a1
    movem.l (a0),d0-d7
    movem.l d0-d7,(a1)       ; just 2 instructions store the palette!

; now put me into low res...
    moveq   #0,d0
    moveq   #-1,d1
    bsr     set_scrn

    move.w #0,-(sp) ; operand, unused
    move.w #5,-(sp) ; function, 5=curs_getrate
    move.w #$15,-(sp) ; cursconf xbios 21
    trap #14
    addq.l #6,sp
    move.w d0,blink_rate
    move.w d0,curr_blink

    rts

restore:
* restore screen to how it was!
* first the res & screen address
    
    move.w  res,d0
    move.l  logbase,d1
    bsr     set_scrn
    
* now the old palette back again!
    lea     pal,a0
    move.l  #$ffff8240,a1

    movem.l (a0),d0-7
    movem.l d0-7,(a1)
    
* turn the mouse back on...
    move.l  mouse_vec,-(a7)
    pea     mouse_params(pc)
    move.w  #1,-(a7)
    clr.w   -(a7)
    trap    #14             ; turn mouse on
    lea     12(a7),a7

    rts


; setscreen - xbios 5
set_scrn:
    move.w  d0,-(sp)
    move.l  d1,-(sp)
    move.l  d1,-(sp)
    move.w  #5,-(sp)
    trap    #14
    lea     12(sp),sp
    rts

; gemdos 7 crawcin - raw input from standard input
inp:
    move.w  #7,-(sp)
    trap    #1
    addq.l  #2,sp
    rts

; prepare 16x16 sprite data, i.e. create 16 shifted versions and reorder words to match the screen planes
; input: a0 - mask + sprite data (16x dc.w mask,plane1,plane2,plane3,plane4)
;        a1 - where to put the prepared mask+data
prepare_sprite:
    moveq #15,d7 ; 16 lines
shift_line:
    moveq.l #$ffffffff,d0 ; mask needs to be filled with $ffff
    moveq.l #0,d1
    moveq.l #0,d2
    moveq.l #0,d3
    moveq.l #0,d4
    move.w (a0)+,d0
    move.w (a0)+,d1
    move.w (a0)+,d2
    move.w (a0)+,d3
    move.w (a0)+,d4
    ;movem.w (a0)+,d0-d4
    ; d0.w: mask; d1..d4.w: 4 planes
    swap d0
    swap d1
    swap d2
    swap d3
    swap d4

    moveq #16-1,d6 ; 16 shifts
    moveq #0,d5 ; shift offset
shift_one:
; reorder the data to match the planes
; 1. mask (is somewhat redundant, repeats the mask pattern 2 times)
    swap d0
    move.w d0,0(a1,d5)
    move.w d0,2(a1,d5)
    swap d0
    move.w d0,4(a1,d5)
    move.w d0,6(a1,d5)
    swap d1
    move.w d1,8(a1,d5)
    swap d1
    move.w d1,16(a1,d5)
    swap d2
    move.w d2,10(a1,d5)
    swap d2
    move.w d2,18(a1,d5)
    swap d3
    move.w d3,12(a1,d5)
    swap d3
    move.w d3,20(a1,d5)
    swap d4
    move.w d4,14(a1,d5)
    swap d4
    move.w d4,22(a1,d5)

    ror.l #1,d0
    ror.l #1,d1
    ror.l #1,d2
    ror.l #1,d3
    ror.l #1,d4

sprite_size_per_shift equ 384 ; size in bytes, (8 mask+16 data)*16 lines

    add.w #sprite_size_per_shift,d5 ; 1 sprite shift uses 16 lines * (8 bytes + 16 bytes) 
    dbra d6,shift_one

    lea 24(a1),a1 ; next line, 24 bytes per line
    dbra d7,shift_line

    rts

init_sprite:
    ; fill the current_sprite_sequence_struct
    ; - 0w: counter
    ; - 2l: address of animated sprite definition
    ; - 6l: address of next entry in sequence
    lea current_sprite_sequence_struct,a0
    ; sprite sequence

    lea spr_sequence,a1
    ; - 0w: delay
    ; - 2l: address of animated sprite definition
    ; - 6w: screen address offset
    ; - 8w: sprite shift address offset
    ; - 10w: offset to next entry in sequence (0 = repeat forever)
    move.w 0(a1),0(a0)
    move.l 2(a1),2(a0) ; current ani spr
    move.w 6(a1),d0 ; screen offset
    move.w 8(a1),d1 ; sprite shift offset
    add.w 10(a1),a1 ; offset to next entry
    move.l a1,6(a0) ; set address of next entry in current struct

    ; fill current_ani_sprite_struct
    ; this struct needs to contain:
    ; - 0w: counter which counts to (including) 0 (delay value)
    ; - 2l: pointer to the sprite data (base address)
    ; - 6w: offset to the correct shift (sprite_size_per_shift(384) bytes * shift (x % 16))
    ; - 8w: offset to the screen address (230 * y coordinate + x offset (x // 16 * 8))
    ; - 10l: pointer to the *next* position in the animated sprite definition (f.e. ani_spr_cursor)
    move.l 2(a0),a2 ;
    lea current_ani_sprite_struct,a1
    move.w 0(a2),0(a1) ; delay
    move.l 2(a2),2(a1) ; sprite data address
    ;move.w #sprite_size_per_shift*0,6(a1) ; shift 0
    ;move.w #230*(28-4)+24,8(a1) ; offset to screen
    move.w d0,8(a1) ; screen offset
    move.w d1,6(a1) ; sprite shift offset
    add.w 6(a2),a2 ; 6(a2) is the offset in the animated sprite definition to the next sprite (can be negative to point to the beginning or so)
    move.l a2,10(a1)
    
    lea current_sprite_sequence_struct2,a0
    ; sprite sequence

    lea spr_sequence2,a1
    ; - 0w: delay
    ; - 2l: address of animated sprite definition
    ; - 6w: screen address offset
    ; - 8w: sprite shift address offset
    ; - 10w: offset to next entry in sequence (0 = repeat forever)
    move.w 0(a1),0(a0)
    move.l 2(a1),2(a0)
    move.w 6(a1),d0 ; screen offset
    move.w 8(a1),d1 ; sprite shift offset
    add.w 10(a1),a1 ; offset to next entry
    move.l a1,6(a0) ; set address of next entry in current struct

    move.l 2(a0),a2 ;
    lea current_ani_sprite_struct2,a1
    move.w 0(a2),0(a1) ; delay
    move.l 2(a2),2(a1) ; sprite data address
    ;move.w #sprite_size_per_shift*0,6(a1) ; shift 0
    ;move.w #230*(28-4)+24,8(a1) ; offset to screen
    move.w d0,8(a1) ; screen offset
    move.w d1,6(a1) ; sprite shift offset
    add.w 6(a2),a2 ; 6(a2) is the offset in the animated sprite definition to the next sprite (can be negative to point to the beginning or so)
    move.l a2,10(a1)

    ; initially save the sprite background
    move.l screen,a0
    lea spr_bg1,a1
    lea spr_bg2,a2
    move.l screen1,(a1)+
    move.l screen2,(a2)+
    rept 16
    movem.l (a0),d0-d3
    movem.l d0-d3,(a1)
    movem.l d0-d3,(a2)
    lea 16(a1),a1
    lea 16(a2),a2
    lea 230(a0),a0
    endr

    move.l screen,a0
    lea spr_bg3,a1
    lea spr_bg4,a2
    move.l screen1,(a1)+
    move.l screen2,(a2)+
    rept 16
    movem.l (a0),d0-d3
    movem.l d0-d3,(a1)
    movem.l d0-d3,(a2)
    lea 16(a1),a1
    lea 16(a2),a2
    lea 230(a0),a0
    endr

    ; init also the current pal and the current snd
    lea current_pal_sequence_struct,a0
    lea pal_sequence,a1
    move.w (a1),(a0) ; delay
    move.l 2(a1),2(a0) ; palette address
    add.w 6(a1),a1
    move.l a1,6(a0)

    lea current_snd_sequence_struct,a0
    lea snd_sequence,a1
    move.w (a1),(a0) ; delay
    move.l 2(a1),2(a0)
    add.w 6(a1),a1
    move.l a1,6(a0)

    rts

; bit zip algorithm from fxtbook for 2 16 bit values
; input d0.w [ a b c d e f g h i j k l m n o p ] d1.w [ A B C D E F G H I J K L M N O P ]
; output d0.l [ a A b B c C d D e E f F g G h H ...]
bit_zip16:
    movem.l d2-d7,-(sp)

    moveq #1,d3 ; m = 1
    moveq #0,d4 ; s = 0
    moveq #0,d2 ; x
    moveq #15,d7 ; d7 = k, BITS_PER_LONG/2 = 16
.bzloop:
    move.l d0,d5
    and.l d3,d5
    lsl.l d4,d5
    or.l d5,d2
    addq #1,d4
    move.l d1,d5
    and.l d3,d5
    lsl.l d4,d5
    or.l d5,d2
    lsl.l #1,d3

    dbra d7,.bzloop
    move.l d2,d0 ; return value
    movem.l (sp)+,d2-d7
    rts

; bit zip algorithm from fxtbook for 2 8 bit values
; input d0.b [ a b c d e f g h ] d1.b [ A B C D E F G H ]
; output d0.w [ a A b B c C d D e E f F g G h H ]
bit_zip8:
    movem.l d2-d7,-(sp)

    moveq #1,d3 ; m = 1
    moveq #0,d4 ; s = 0
    moveq #0,d2 ; x = 0
    moveq #7,d7 ; d7 = k, BITS_PER_LONG/2 = 8
.bzloop:
    move.w d0,d5
    and.w d3,d5
    lsl.w d4,d5
    or.w d5,d2
    addq #1,d4
    move.w d1,d5
    and.w d3,d5
    lsl.w d4,d5
    or.w d5,d2
    lsl.w #1,d3

    dbra d7,.bzloop
    move.w d2,d0 ; return value
    movem.l (sp)+,d2-d7
    rts

prepare_font:
    ; load the 8x8 font from the tos rom
    dc.w $a000
    ; in a0 (and d0) ptr to line-a structure
    ; in a1: pointer to address table to font headers of system fonts
    move.l 8(a1),a0 ; default font 8x16
    
    move.l 76(a0),a0 ; actual font data, which is 256 characters, 
    ; ordering is: 1 byte first line of first char, next byte is first line of second char, 
    ; ..., 256th byte is first line of 256th char, 257th byte is second line of 1st char, ... 
    ; so, it is a 256x16 image, where we f.e. pick the character at x-position 65*8 (for "A")
    lea font,a1
    ; we blow up the 8x16 font to 32x64 (basically: every bit becomes a nibble/byte), width is 32 bit/4 bytes/2 words/1 lw, height is 64 lines
    ; storage is 1. line left half, 1. plane, 2. plane, 2. line left half, 1. plane, 2. plane, ..., 64. line left half, 1. plane, 2. plane, 1. line right half, ...

    move.l a0,a2 ; save the font data
    lea pick_sysfont_chars,a3

    moveq #31,d6 ; 32 chars
.onechar:
    move.l a2,a0
    clr.w d0
    move.b (a3)+,d0
    add.w d0,a0
    moveq #15,d7 ; 16 lines, font is 8x16
.oneline:
    moveq #0,d0
    moveq #0,d1
    move.b (a0),d0
    add.l #256,a0 ; next line
    move.b d0,d1
    bsr bit_zip8
    ; d0.w is now the doubled first line of the char
    move.w d0,d1
    bsr bit_zip16
    ; d0.l is now the blown up line of the char

    ; save it in d4
    move.l d0,d4
    ; left part
    swap d0
    moveq #0,d1
    move.w d0,d1
    bsr bit_zip16
    ; d0.l left part blown up to 32 pixels
    ; save it to d5
    move.l d0,d5
    moveq #0,d0
    move.w d4,d0
    moveq #0,d1
    move.w d0,d1
    bsr bit_zip16

    ; now: d0.l is the right part blown up to 32 pixels, d5.l is the left part blown up to 32 pixels

    ; now the first line needs to be reordered to 1st plane/2nd plane of left part and then offset to the right part 1st/2nd plane (2w * 64 lines = 256 bytes)

    ; plane 1
    ; 1 line left
    swap d5
    move.w d5,0(a1) ; plane 1
    move.w d5,4(a1) ; plane 1
    move.w d5,8(a1) ; plane 1
    move.w d5,12(a1) ; plane 1
    ; 1 line left 2
    swap d5
    move.w d5,256(a1)
    move.w d5,260(a1)
    move.w d5,264(a1)
    move.w d5,268(a1)
    ; plane 2
    ; 1 line left
    swap d5
    asr.w #3,d5
    move.w d5,2(a1) ; plane 2
    move.w d5,6(a1) ; plane 2
    move.w d5,10(a1) ; plane 2
    move.w d5,14(a1) ; plane 2
    ; 1 line left 2
    swap d5
    asr.w #3,d5
    move.w d5,258(a1)
    move.w d5,262(a1)
    move.w d5,266(a1)
    move.w d5,270(a1)

    ; plane 1
    ; 1 line right
    swap d0
    move.w d0,512(a1) ; plane 1
    move.w d0,516(a1) ; plane 1
    move.w d0,520(a1) ; plane 1
    move.w d0,524(a1) ; plane 1
    ; 1 line right 2
    swap d0
    move.w d0,768(a1)
    move.w d0,772(a1)
    move.w d0,776(a1)
    move.w d0,780(a1)
    ; plane 2
    ; 1 line right
    swap d0
    asr.w #3,d0
    move.w d0,514(a1) ; plane 2
    move.w d0,518(a1) ; plane 2
    move.w d0,522(a1) ; plane 2
    move.w d0,526(a1) ; plane 2
    ; 1 line right 2
    swap d0
    asr.w #3,d0
    move.w d0,770(a1)
    move.w d0,774(a1)
    move.w d0,778(a1)
    move.w d0,782(a1)

    add.l #16,a1
    dbra d7,.oneline
    ;addq #1,a2
    ;add.l #256,a1
    add.l #768,a1
    ;move.l a2,a0
    dbra d6,.onechar

    ; next: create the 8-bit shifted variants after the regular font
    lea font,a0
    lea font_shift_r,a1
    lea font_shift_l,a2

    move.w #4*32*64*2-1,d7 ; 4x32 characters,64 lines,2 words per line
.charshift:
    move.w (a0)+,d0
    move.w d0,d1
    lsr.w #8,d0
    move.w d0,(a1)+
    lsl.w #8,d1
    move.w d1,(a2)+
    dbra d7,.charshift

    rts

prepare_scrolltext:
    lea scrolltext,a0
    lea scrolltextbuffer,a1

    move.w #scrolltextsize-1,d7
.onechar:
    moveq #0,d0
    move.b (a0)+,d0
    ; sub.b #65,d0 ; subtract 'A'
    ; mulu #fontcharactersize,d0 ; i.e. *256, and then we need to multiply *4 (for all 4 parts) we can do this better:
    lsl.w #8,d0
    lsl.w #2,d0
    move.w d0,(a1)+
    add.w #256,d0
    move.w d0,(a1)+
    add.w #256,d0
    move.w d0,(a1)+
    add.w #256,d0
    move.w d0,(a1)+

    dbra d7,.onechar
    move.w #-1,(a1)
    ; move.w -2(a1),prev_scrolltextentry
    move.w #0,prev_scrolltextentry ; start with a space as the previous character
    rts

    data

pick_sysfont_chars:
    dc.b $20,$41,$42,$43,$44,$45,$46,$47,$48,$49,$4a,$4b,$4c,$4d,$4e,$4f ; [ ],A,B,C,D,E,...,O
    dc.b $50,$51,$52,$53,$54,$55,$56,$57,$58,$59,$5a,$2e,$2d,$21,$0e,$0f ; P,Q,...,Z,.,-,!,[atarileft],[atariright]

pal_sequence:
    dc.w 750 ; delay
    dc.l pal_start ; address of the new palette
    dc.w 8 ; offset to the next entry
    dc.w 25
    dc.l pal_border1 ; address of the new palette
    dc.w 8 ; offset to the next entry
    dc.w 5
    dc.l pal_border2 ; address of the new palette
    dc.w 8 ; offset to the next entry
    dc.w 5
    dc.l pal_border3 ; address of the new palette
    dc.w 8 ; offset to the next entry
    dc.w 5
    dc.l pal_border4 ; address of the new palette
    dc.w -32 ; offset to the next entry

snd_sequence: ; as opposed to the other sequences, the sound is played when the delay counter has run out. at the moment, the keyclick data is actually ignored and always the same click is played
    dc.w 50
    dc.l snd_keyclick_data
    dc.w 8
    dc.w 25
    dc.l snd_keyclick_data
    dc.w 8
    dc.w 10
    dc.l snd_keyclick_data
    dc.w 8
    dc.w 50
    dc.l snd_keyclick_data
    dc.w 8
    dc.w 25
    dc.l snd_keyclick_data
    dc.w 8
    dc.w 10
    dc.l snd_keyclick_data
    dc.w 8
    dc.w 50
    dc.l snd_keyclick_data
    dc.w 8
    dc.w 25
    dc.l snd_keyclick_data
    dc.w 8
    dc.w 10
    dc.l snd_keyclick_data
    dc.w 8
    dc.w 50
    dc.l snd_keyclick_data
    dc.w 8
    dc.w 25
    dc.l snd_keyclick_data
    dc.w 8
    dc.w 10
    dc.l snd_keyclick_data
    dc.w 8
    dc.w 50
    dc.l snd_keyclick_data
    dc.w 8
    dc.w 25
    dc.l snd_keyclick_data
    dc.w 8
    dc.w 10
    dc.l snd_keyclick_data
    dc.w 8
    dc.w 50
    dc.l snd_keyclick_data
    dc.w 8
    dc.w 25
    dc.l snd_keyclick_data
    dc.w 8
    dc.w 10
    dc.l snd_keyclick_data
    dc.w 8
    dc.w 25
    dc.l snd_bell_data
    dc.w 8
    dc.w 25
    dc.l snd_keyclick_data
    dc.w 8
    dc.w 25
    dc.l snd_keyclick_data
    dc.w 8
    dc.w 10
    dc.l snd_keyclick_data
    dc.w 8
    dc.w 25
    dc.l snd_bell_data
    dc.w -24

spr_sequence:
    dc.w 100 ; 0w: delay (1000 = 20s, 500 = 10s, ...)
    dc.l ani_spr_cursor ; 2l: animated sprite definition
    dc.w 230*(28-4)+24 ; 6w: screen address offset
    dc.w 0 ; 8w: sprite shift address offset
    dc.w 12 ; 10w: offset to next entry in sequence (0 = repeat forever, 12 = next entry)
    dc.w 100 ; 0w: delay (1000 = 20s, 500 = 10s, ...)
    dc.l ani_spr_cursor ; 2l: animated sprite definition
    dc.w 230*(28-4)+24 ; 6w: screen address offset
    dc.w sprite_size_per_shift*8 ; 8w: sprite shift address offset
    dc.w 12 ; 10w: offset to next entry in sequence (0 = repeat forever, 12 = next entry)
    dc.w 100 ; 0w: delay (1000 = 20s, 500 = 10s, ...)
    dc.l ani_spr_cursor_legs ; 2l: animated sprite definition
    dc.w 230*(28-4)+24 ; 6w: screen address offset
    dc.w sprite_size_per_shift*8 ; 8w: sprite shift address offset
    dc.w 12 ; 10w: offset to next entry in sequence (0 = repeat forever, 12 = next entry)
    dc.w 10 ; 0w: delay (1000 = 20s, 500 = 10s, ...)
    dc.l ani_spr_cursor_legs ; 2l: animated sprite definition
    dc.w 230*(28-4)+24 ; 6w: screen address offset
    dc.w sprite_size_per_shift*12 ; 8w: sprite shift address offset
    dc.w 12 ; 10w: offset to next entry in sequence (0 = repeat forever, 12 = next entry)
    dc.w 10 ; 0w: delay (1000 = 20s, 500 = 10s, ...)
    dc.l 0 ; 2l: animated sprite definition
    dc.w 230*(28-4)+32 ; 6w: screen address offset
    dc.w sprite_size_per_shift*0 ; 8w: sprite shift address offset
    dc.w 12 ; 10w: offset to next entry in sequence (0 = repeat forever, 12 = next entry)
    dc.w 10 ; 0w: delay (1000 = 20s, 500 = 10s, ...)
    dc.l ani_spr_cursor_legs ; 2l: animated sprite definition
    dc.w 230*(28-4)+32 ; 6w: screen address offset
    dc.w sprite_size_per_shift*4 ; 8w: sprite shift address offset
    dc.w 12 ; 10w: offset to next entry in sequence (0 = repeat forever, 12 = next entry)
    dc.w 10 ; 0w: delay (1000 = 20s, 500 = 10s, ...)
    dc.l 0 ; 2l: animated sprite definition
    dc.w 230*(28-4)+32 ; 6w: screen address offset
    dc.w sprite_size_per_shift*8 ; 8w: sprite shift address offset
    dc.w 12 ; 10w: offset to next entry in sequence (0 = repeat forever, 12 = next entry)
    dc.w 10 ; 0w: delay (1000 = 20s, 500 = 10s, ...)
    dc.l 0 ; 2l: animated sprite definition
    dc.w 230*(28-4)+32 ; 6w: screen address offset
    dc.w sprite_size_per_shift*12 ; 8w: sprite shift address offset
    dc.w 12 ; 10w: offset to next entry in sequence (0 = repeat forever, 12 = next entry)
    dc.w 10 ; 0w: delay (1000 = 20s, 500 = 10s, ...)
    dc.l 0 ; 2l: animated sprite definition
    dc.w 230*(28-4)+40 ; 6w: screen address offset
    dc.w sprite_size_per_shift*0 ; 8w: sprite shift address offset
    dc.w 12 ; 10w: offset to next entry in sequence (0 = repeat forever, 12 = next entry)
    dc.w 10 ; 0w: delay (1000 = 20s, 500 = 10s, ...)
    dc.l 0 ; 2l: animated sprite definition
    dc.w 230*(28-4)+40 ; 6w: screen address offset
    dc.w sprite_size_per_shift*8 ; 8w: sprite shift address offset
    dc.w 12 ; 10w: offset to next entry in sequence (0 = repeat forever, 12 = next entry)
    dc.w 10 ; 0w: delay (1000 = 20s, 500 = 10s, ...)
    dc.l 0 ; 2l: animated sprite definition
    dc.w 230*(28-4)+48 ; 6w: screen address offset
    dc.w sprite_size_per_shift*0 ; 8w: sprite shift address offset
    dc.w 12 ; 10w: offset to next entry in sequence (0 = repeat forever, 12 = next entry)
    dc.w 10 ; 0w: delay (1000 = 20s, 500 = 10s, ...)
    dc.l 0 ; 2l: animated sprite definition
    dc.w 230*(28-4)+48 ; 6w: screen address offset
    dc.w sprite_size_per_shift*8 ; 8w: sprite shift address offset
    dc.w 12 ; 10w: offset to next entry in sequence (0 = repeat forever, 12 = next entry)
    dc.w 10 ; 0w: delay (1000 = 20s, 500 = 10s, ...)
    dc.l 0 ; 2l: animated sprite definition
    dc.w 230*(28-4)+56 ; 6w: screen address offset
    dc.w sprite_size_per_shift*0 ; 8w: sprite shift address offset
    dc.w 12 ; 10w: offset to next entry in sequence (0 = repeat forever, 12 = next entry)
    dc.w 10 ; 0w: delay (1000 = 20s, 500 = 10s, ...)
    dc.l 0 ; 2l: animated sprite definition
    dc.w 230*(28-4)+56 ; 6w: screen address offset
    dc.w sprite_size_per_shift*8 ; 8w: sprite shift address offset
    dc.w 12 ; 10w: offset to next entry in sequence (0 = repeat forever, 12 = next entry)
    dc.w 10 ; 0w: delay (1000 = 20s, 500 = 10s, ...)
    dc.l 0 ; 2l: animated sprite definition
    dc.w 230*(28-4)+64 ; 6w: screen address offset
    dc.w sprite_size_per_shift*0 ; 8w: sprite shift address offset
    dc.w 12 ; 10w: offset to next entry in sequence (0 = repeat forever, 12 = next entry)
    dc.w 10 ; 0w: delay (1000 = 20s, 500 = 10s, ...)
    dc.l 0 ; 2l: animated sprite definition
    dc.w 230*(28-4)+64 ; 6w: screen address offset
    dc.w sprite_size_per_shift*8 ; 8w: sprite shift address offset
    dc.w 12 ; 10w: offset to next entry in sequence (0 = repeat forever, 12 = next entry)
    dc.w 10 ; 0w: delay (1000 = 20s, 500 = 10s, ...)
    dc.l 0 ; 2l: animated sprite definition
    dc.w 230*(28-4)+72 ; 6w: screen address offset
    dc.w sprite_size_per_shift*0 ; 8w: sprite shift address offset
    dc.w 12 ; 10w: offset to next entry in sequence (0 = repeat forever, 12 = next entry)
    dc.w 10 ; 0w: delay (1000 = 20s, 500 = 10s, ...)
    dc.l 0 ; 2l: animated sprite definition
    dc.w 230*(28-4)+72 ; 6w: screen address offset
    dc.w sprite_size_per_shift*8 ; 8w: sprite shift address offset
    dc.w 12 ; 10w: offset to next entry in sequence (0 = repeat forever, 12 = next entry)
    dc.w 10 ; 0w: delay (1000 = 20s, 500 = 10s, ...)
    dc.l 0 ; 2l: animated sprite definition
    dc.w 230*(28-4)+80 ; 6w: screen address offset
    dc.w sprite_size_per_shift*8 ; 8w: sprite shift address offset
    dc.w 12 ; 10w: offset to next entry in sequence (0 = repeat forever, 12 = next entry)
    dc.w 10 ; 0w: delay (1000 = 20s, 500 = 10s, ...)
    dc.l 0 ; 2l: animated sprite definition
    dc.w 230*(28-4)+88 ; 6w: screen address offset
    dc.w sprite_size_per_shift*8 ; 8w: sprite shift address offset
    dc.w 12 ; 10w: offset to next entry in sequence (0 = repeat forever, 12 = next entry)
    dc.w 10 ; 0w: delay (1000 = 20s, 500 = 10s, ...)
    dc.l 0 ; 2l: animated sprite definition
    dc.w 230*(28-4)+96 ; 6w: screen address offset
    dc.w sprite_size_per_shift*8 ; 8w: sprite shift address offset
    dc.w 12 ; 10w: offset to next entry in sequence (0 = repeat forever, 12 = next entry)
    dc.w 10 ; 0w: delay (1000 = 20s, 500 = 10s, ...)
    dc.l 0 ; 2l: animated sprite definition
    dc.w 230*(28-4)+104 ; 6w: screen address offset
    dc.w sprite_size_per_shift*8 ; 8w: sprite shift address offset
    dc.w 12 ; 10w: offset to next entry in sequence (0 = repeat forever, 12 = next entry)
    dc.w 10 ; 0w: delay (1000 = 20s, 500 = 10s, ...)
    dc.l 0 ; 2l: animated sprite definition
    dc.w 230*(28-4)+112 ; 6w: screen address offset
    dc.w sprite_size_per_shift*8 ; 8w: sprite shift address offset
    dc.w 12 ; 10w: offset to next entry in sequence (0 = repeat forever, 12 = next entry)
    dc.w 10 ; 0w: delay (1000 = 20s, 500 = 10s, ...)
    dc.l 0 ; 2l: animated sprite definition
    dc.w 230*(28-4)+120 ; 6w: screen address offset
    dc.w sprite_size_per_shift*8 ; 8w: sprite shift address offset
    dc.w 12 ; 10w: offset to next entry in sequence (0 = repeat forever, 12 = next entry)
    dc.w 10 ; 0w: delay (1000 = 20s, 500 = 10s, ...)
    dc.l 0 ; 2l: animated sprite definition
    dc.w 230*(28-4)+128 ; 6w: screen address offset
    dc.w sprite_size_per_shift*8 ; 8w: sprite shift address offset
    dc.w 12 ; 10w: offset to next entry in sequence (0 = repeat forever, 12 = next entry)
    dc.w 10 ; 0w: delay (1000 = 20s, 500 = 10s, ...)
    dc.l 0 ; 2l: animated sprite definition
    dc.w 230*(28-4)+136 ; 6w: screen address offset
    dc.w sprite_size_per_shift*8 ; 8w: sprite shift address offset
    dc.w 12 ; 10w: offset to next entry in sequence (0 = repeat forever, 12 = next entry)
    dc.w 10 ; 0w: delay (1000 = 20s, 500 = 10s, ...)
    dc.l 0 ; 2l: animated sprite definition
    dc.w 230*(28-4)+144 ; 6w: screen address offset
    dc.w sprite_size_per_shift*8 ; 8w: sprite shift address offset
    dc.w 12 ; 10w: offset to next entry in sequence (0 = repeat forever, 12 = next entry)
    dc.w 10 ; 0w: delay (1000 = 20s, 500 = 10s, ...)
    dc.l 0 ; 2l: animated sprite definition
    dc.w 230*(28-4)+152 ; 6w: screen address offset
    dc.w sprite_size_per_shift*8 ; 8w: sprite shift address offset
    dc.w 12 ; 10w: offset to next entry in sequence (0 = repeat forever, 12 = next entry)
    dc.w 10 ; 0w: delay (1000 = 20s, 500 = 10s, ...)
    dc.l 0 ; 2l: animated sprite definition
    dc.w 230*(28-4)+160 ; 6w: screen address offset
    dc.w sprite_size_per_shift*8 ; 8w: sprite shift address offset
    dc.w 12 ; 10w: offset to next entry in sequence (0 = repeat forever, 12 = next entry)
    dc.w 10 ; 0w: delay (1000 = 20s, 500 = 10s, ...)
    dc.l 0 ; 2l: animated sprite definition
    dc.w 230*(28-4)+168 ; 6w: screen address offset
    dc.w sprite_size_per_shift*8 ; 8w: sprite shift address offset
    dc.w 12 ; 10w: offset to next entry in sequence (0 = repeat forever, 12 = next entry)
    dc.w 100 ; 0w: delay (1000 = 20s, 500 = 10s, ...)
    dc.l 0 ; 2l: animated sprite definition
    dc.w 230*(28-4)+176 ; 6w: screen address offset
    dc.w sprite_size_per_shift*8 ; 8w: sprite shift address offset
    dc.w 0 ; 10w: offset to next entry in sequence (0 = repeat forever, 12 = next entry)

spr_sequence2:
    dc.w 100 ; 0w: delay (1000 = 20s, 500 = 10s, ...)
    dc.l ani_spr_cursor ; 2l: animated sprite definition
    dc.w 230*(28-4+100)+196 ; 6w: screen address offset
    dc.w 0 ; 8w: sprite shift address offset
    dc.w 0 ; 10w: offset to next entry in sequence (0 = repeat forever, 12 = next entry)

ani_spr_cursor:
    dc.w 25 ; delay
    dc.l spr_cursor ; sprite data
    dc.w 8 ; offset to the next entry
    dc.w 25
    dc.l spr_empty ; sprite data
    dc.w -8 ; affset to the next entry (go backwards)

ani_spr_cursor_legs:
    dc.w 25 ; delay
    dc.l spr_cursor_legs1 ; sprite data
    dc.w 8 ; offset to the next entry
    dc.w 25
    dc.l spr_empty ; sprite data
    dc.w 8 ; affset to the next entry (go backwards)
    dc.w 25 ; delay
    dc.l spr_cursor_legs2 ; sprite data
    dc.w 8 ; offset to the next entry
    dc.w 25
    dc.l spr_empty ; sprite data
    dc.w -24 ; affset to the next entry (go backwards)

raw_sprites:
; 0
raw_spr_empty:
    dc.w $FFFF,$0000,$0000,$0000,$0000
    dc.w $FFFF,$0000,$0000,$0000,$0000
    dc.w $FFFF,$0000,$0000,$0000,$0000
    dc.w $FFFF,$0000,$0000,$0000,$0000
    dc.w $FFFF,$0000,$0000,$0000,$0000
    dc.w $FFFF,$0000,$0000,$0000,$0000
    dc.w $FFFF,$0000,$0000,$0000,$0000
    dc.w $FFFF,$0000,$0000,$0000,$0000
    dc.w $FFFF,$0000,$0000,$0000,$0000
    dc.w $FFFF,$0000,$0000,$0000,$0000
    dc.w $FFFF,$0000,$0000,$0000,$0000
    dc.w $FFFF,$0000,$0000,$0000,$0000
    dc.w $FFFF,$0000,$0000,$0000,$0000
    dc.w $FFFF,$0000,$0000,$0000,$0000
    dc.w $FFFF,$0000,$0000,$0000,$0000
    dc.w $FFFF,$0000,$0000,$0000,$0000

; 1
raw_spr_cursor:
    if DEBUG
    dc.w $0FFF,$f000,$f000,$0000,$0000
    else
    dc.w $FFFF,$0000,$0000,$0000,$0000
    endif
    dc.w $FFFF,$0000,$0000,$0000,$0000
    dc.w $FFFF,$0000,$0000,$0000,$0000
    dc.w $FFFF,$0000,$0000,$0000,$0000
    dc.w $F00F,$0FF0,$0FF0,$0000,$0000
    dc.w $F00F,$0FF0,$0FF0,$0000,$0000
    dc.w $F00F,$0FF0,$0FF0,$0000,$0000
    dc.w $F00F,$0FF0,$0FF0,$0000,$0000
    dc.w $F00F,$0FF0,$0FF0,$0000,$0000
    dc.w $F00F,$0FF0,$0FF0,$0000,$0000
    dc.w $F00F,$0FF0,$0FF0,$0000,$0000
    dc.w $F00F,$0FF0,$0FF0,$0000,$0000
    dc.w $FFFF,$0000,$0000,$0000,$0000
    dc.w $FFFF,$0000,$0000,$0000,$0000
    dc.w $FFFF,$0000,$0000,$0000,$0000
    if DEBUG
    dc.w $0FFF,$f000,$0000,$f000,$0000
    else
    dc.w $FFFF,$0000,$0000,$0000,$0000
    endif

raw_spr_cursor_legs1:
    dc.w $FFFF,$0000,$0000,$0000,$0000
    dc.w $FFFF,$0000,$0000,$0000,$0000
    dc.w $FFFF,$0000,$0000,$0000,$0000
    dc.w $FFFF,$0000,$0000,$0000,$0000
    dc.w $F00F,$0FF0,$0FF0,$0000,$0000
    dc.w $F00F,$0FF0,$0FF0,$0000,$0000
    dc.w $F00F,$0FF0,$0FF0,$0000,$0000
    dc.w $F00F,$0FF0,$0FF0,$0000,$0000
    dc.w $F00F,$0FF0,$0FF0,$0000,$0000
    dc.w $F00F,$0FF0,$0FF0,$0000,$0000
    dc.w $F00F,$0FF0,$0FF0,$0000,$0000
    dc.w $F00F,$0FF0,$0FF0,$0000,$0000
    dc.w $FEFF,$0100,$0100,$0000,$0000
    dc.w $FEFF,$0100,$0100,$0000,$0000
    dc.w $FE7F,$0180,$0180,$0000,$0000
    dc.w $FFFF,$0000,$0000,$0000,$0000

raw_spr_cursor_legs2:
    dc.w $FFFF,$0000,$0000,$0000,$0000
    dc.w $FFFF,$0000,$0000,$0000,$0000
    dc.w $FFFF,$0000,$0000,$0000,$0000
    dc.w $FFFF,$0000,$0000,$0000,$0000
    dc.w $F00F,$0FF0,$0FF0,$0000,$0000
    dc.w $F00F,$0FF0,$0FF0,$0000,$0000
    dc.w $F00F,$0FF0,$0FF0,$0000,$0000
    dc.w $F00F,$0FF0,$0FF0,$0000,$0000
    dc.w $F00F,$0FF0,$0FF0,$0000,$0000
    dc.w $F00F,$0FF0,$0FF0,$0000,$0000
    dc.w $F00F,$0FF0,$0FF0,$0000,$0000
    dc.w $F00F,$0FF0,$0FF0,$0000,$0000
    dc.w $FEBF,$0140,$0140,$0000,$0000
    dc.w $FEBF,$0140,$0140,$0000,$0000
    dc.w $FE1F,$01E0,$01E0,$0000,$0000
    dc.w $FFFF,$0000,$0000,$0000,$0000

mouse_params:
    dc.b    0,1,1,1
my_pal: ; default palette. we start with a white bg, plane 1+2 are for the background, plane 3+4 are for the scroller
    ; plane 1+2 %0000,%1000,%0100,%1100 ->  4,8,12
    ; plane 3+4 %0000,%0010,%0001,%0011 ->  1,2,3
    dc.w $0777 ; 0 %0000 bg
    dc.w $0666 ; 1 initial border color (invisible, change to 777 later) (further out)
    dc.w $0555 ; 2 initial border color (invisible, change to 777 later) (closer to the middle)
    dc.w $0700 ; 3 inital cursor color (black)
    dc.w $0333 ; 4 scroller border left
    dc.w $0333 ; 5 scroller border left
    dc.w $0333 ; 6 scroller border left
    dc.w $0333 ; 7 scroller border left
    dc.w $0222 ; 8 scroller border right
    dc.w $0222 ; 9 scroller border right
    dc.w $0222 ; 10 scroller border right
    dc.w $0222 ; 11 scroller border right
    dc.w $0000 ; 12 scroller main color
    dc.w $0000 ; 13 scroller main color
    dc.w $0000 ; 14 scroller main color
    dc.w $0000 ; 15 scroller main color

pal_start: ; default palette. we start with a white bg, plane 1+2 are for the background, plane 3+4 are for the scroller
    ; plane 1+2 %0000,%1000,%0100,%1100 ->  4,8,12
    ; plane 3+4 %0000,%0010,%0001,%0011 ->  1,2,3
    dc.w $0777 ; 0 %0000 bg
    dc.w $0777 ; 1 initial border color (invisible, change to 777 later) (further out)
    dc.w $0777 ; 2 initial border color (invisible, change to 777 later) (closer to the middle)
    if DEBUG
    dc.w $0700 ; 3 inital cursor color (black)
    else
    dc.w $0000 ; 3 inital cursor color (black)
    endif
    dc.w $0333 ; 4 scroller border left
    dc.w $0333 ; 5 scroller border left
    dc.w $0333 ; 6 scroller border left
    dc.w $0333 ; 7 scroller border left
    dc.w $0222 ; 8 scroller border right
    dc.w $0222 ; 9 scroller border right
    dc.w $0222 ; 10 scroller border right
    dc.w $0222 ; 11 scroller border right
    dc.w $0000 ; 12 scroller main color
    dc.w $0000 ; 13 scroller main color
    dc.w $0000 ; 14 scroller main color
    dc.w $0000 ; 15 scroller main color

pal_border1: ; default palette. we start with a white bg, plane 1+2 are for the background, plane 3+4 are for the scroller
    ; plane 1+2 %0000,%1000,%0100,%1100 ->  4,8,12
    ; plane 3+4 %0000,%0010,%0001,%0011 ->  1,2,3
    dc.w $0777 ; 0 %0000 bg
    dc.w $0501 ; 1 initial border color (invisible, change to 777 later) (further out)
    dc.w $0301 ; 2 initial border color (invisible, change to 777 later) (closer to the middle)
    dc.w $0700 ; 3 inital cursor color (black)
    dc.w $0333 ; 4 scroller border left
    dc.w $0333 ; 5 scroller border left
    dc.w $0333 ; 6 scroller border left
    dc.w $0333 ; 7 scroller border left
    dc.w $0222 ; 8 scroller border right
    dc.w $0222 ; 9 scroller border right
    dc.w $0222 ; 10 scroller border right
    dc.w $0222 ; 11 scroller border right
    dc.w $0000 ; 12 scroller main color
    dc.w $0000 ; 13 scroller main color
    dc.w $0000 ; 14 scroller main color
    dc.w $0000 ; 15 scroller main color

pal_border2: ; default palette. we start with a white bg, plane 1+2 are for the background, plane 3+4 are for the scroller
    ; plane 1+2 %0000,%1000,%0100,%1100 ->  4,8,12
    ; plane 3+4 %0000,%0010,%0001,%0011 ->  1,2,3
    dc.w $0777 ; 0 %0000 bg
    dc.w $0601 ; 1 initial border color (invisible, change to 777 later) (further out)
    dc.w $0401 ; 2 initial border color (invisible, change to 777 later) (closer to the middle)
    dc.w $0700 ; 3 inital cursor color (black)
    dc.w $0333 ; 4 scroller border left
    dc.w $0333 ; 5 scroller border left
    dc.w $0333 ; 6 scroller border left
    dc.w $0333 ; 7 scroller border left
    dc.w $0222 ; 8 scroller border right
    dc.w $0222 ; 9 scroller border right
    dc.w $0222 ; 10 scroller border right
    dc.w $0222 ; 11 scroller border right
    dc.w $0000 ; 12 scroller main color
    dc.w $0000 ; 13 scroller main color
    dc.w $0000 ; 14 scroller main color
    dc.w $0000 ; 15 scroller main color

pal_border3: ; default palette. we start with a white bg, plane 1+2 are for the background, plane 3+4 are for the scroller
    ; plane 1+2 %0000,%1000,%0100,%1100 ->  4,8,12
    ; plane 3+4 %0000,%0010,%0001,%0011 ->  1,2,3
    dc.w $0777 ; 0 %0000 bg
    dc.w $0701 ; 1 initial border color (invisible, change to 777 later) (further out)
    dc.w $0601 ; 2 initial border color (invisible, change to 777 later) (closer to the middle)
    dc.w $0700 ; 3 inital cursor color (black)
    dc.w $0333 ; 4 scroller border left
    dc.w $0333 ; 5 scroller border left
    dc.w $0333 ; 6 scroller border left
    dc.w $0333 ; 7 scroller border left
    dc.w $0222 ; 8 scroller border right
    dc.w $0222 ; 9 scroller border right
    dc.w $0222 ; 10 scroller border right
    dc.w $0222 ; 11 scroller border right
    dc.w $0000 ; 12 scroller main color
    dc.w $0000 ; 13 scroller main color
    dc.w $0000 ; 14 scroller main color
    dc.w $0000 ; 15 scroller main color

pal_border4: ; default palette. we start with a white bg, plane 1+2 are for the background, plane 3+4 are for the scroller
    ; plane 1+2 %0000,%1000,%0100,%1100 ->  4,8,12
    ; plane 3+4 %0000,%0010,%0001,%0011 ->  1,2,3
    dc.w $0777 ; 0 %0000 bg
    dc.w $0700 ; 1 initial border color (invisible, change to 777 later) (further out)
    dc.w $0700 ; 2 initial border color (invisible, change to 777 later) (closer to the middle)
    dc.w $0700 ; 3 inital cursor color (black)
    dc.w $0333 ; 4 scroller border left
    dc.w $0333 ; 5 scroller border left
    dc.w $0333 ; 6 scroller border left
    dc.w $0333 ; 7 scroller border left
    dc.w $0222 ; 8 scroller border right
    dc.w $0222 ; 9 scroller border right
    dc.w $0222 ; 10 scroller border right
    dc.w $0222 ; 11 scroller border right
    dc.w $0000 ; 12 scroller main color
    dc.w $0000 ; 13 scroller main color
    dc.w $0000 ; 14 scroller main color
    dc.w $0000 ; 15 scroller main color

    ;dc.w $0000,$0666,$0700,$0070,$0007,$0770,$0077,$0707
    ;dc.w $0777,$0500,$0050,$0005,$0550,$0055,$0505,$0555
    ; incbin 'spr_pal.dat'

scrollerpals: ; 64 palettes
    dc.l scrollerpalred1
    dc.l scrollerpalred1
    dc.l scrollerpalred1
    dc.l scrollerpalred1
    dc.l scrollerpalred1
    dc.l scrollerpalred1
    dc.l scrollerpalred1
    dc.l scrollerpalred1
    dc.l scrollerpalred1
    dc.l scrollerpalred1
    dc.l scrollerpalred1
    dc.l scrollerpalred1
    dc.l scrollerpalred1
    dc.l scrollerpalred1
    dc.l scrollerpalred1
    dc.l scrollerpalred1
    dc.l scrollerpalred2
    dc.l scrollerpalred2
    dc.l scrollerpalred2
    dc.l scrollerpalred2
    dc.l scrollerpalred2
    dc.l scrollerpalred2
    dc.l scrollerpalred2
    dc.l scrollerpalred2
    dc.l scrollerpalred2
    dc.l scrollerpalred2
    dc.l scrollerpalred2
    dc.l scrollerpalred2
    dc.l scrollerpalred2
    dc.l scrollerpalred2
    dc.l scrollerpalred2
    dc.l scrollerpalred2
    dc.l scrollerpalred1
    dc.l scrollerpalred3
    dc.l scrollerpalred3
    dc.l scrollerpalred3
    dc.l scrollerpalred3
    dc.l scrollerpalred3
    dc.l scrollerpalred3
    dc.l scrollerpalred3
    dc.l scrollerpalred3
    dc.l scrollerpalred3
    dc.l scrollerpalred3
    dc.l scrollerpalred3
    dc.l scrollerpalred3
    dc.l scrollerpalred3
    dc.l scrollerpalred3
    dc.l scrollerpalred3
    dc.l scrollerpalred4
    dc.l scrollerpalred4
    dc.l scrollerpalred4
    dc.l scrollerpalred4
    dc.l scrollerpalred4
    dc.l scrollerpalred4
    dc.l scrollerpalred4
    dc.l scrollerpalred4
    dc.l scrollerpalred4
    dc.l scrollerpalred4
    dc.l scrollerpalred4
    dc.l scrollerpalred4
    dc.l scrollerpalred4
    dc.l scrollerpalred4
    dc.l scrollerpalred4
    dc.l scrollerpalred4

scrollerpalred1:
    dc.w $0611 ; 0 %0000 bg
    dc.w $0666 ; 1 initial border color (invisible, change to 777 later) (further out)
    dc.w $0555 ; 2 initial border color (invisible, change to 777 later) (closer to the middle)
    dc.w $0000 ; 3 inital cursor color (black)
    dc.w $0300 ; 4 scroller border left
    dc.w $0300 ; 5 scroller border left
    dc.w $0300 ; 6 scroller border left
    dc.w $0300 ; 7 scroller border left
    dc.w $0200 ; 8 scroller border right
    dc.w $0200 ; 9 scroller border right
    dc.w $0200 ; 10 scroller border right
    dc.w $0200 ; 11 scroller border right
    dc.w $0500 ; 12 scroller main color
    dc.w $0500 ; 13 scroller main color
    dc.w $0500 ; 14 scroller main color
    dc.w $0500 ; 15 scroller main color

scrollerpalred2:
    dc.w $0711 ; 0 %0000 bg
    dc.w $0666 ; 1 initial border color (invisible, change to 777 later) (further out)
    dc.w $0555 ; 2 initial border color (invisible, change to 777 later) (closer to the middle)
    dc.w $0000 ; 3 inital cursor color (black)
    dc.w $0400 ; 4 scroller border left
    dc.w $0400 ; 5 scroller border left
    dc.w $0400 ; 6 scroller border left
    dc.w $0400 ; 7 scroller border left
    dc.w $0300 ; 8 scroller border right
    dc.w $0300 ; 9 scroller border right
    dc.w $0300 ; 10 scroller border right
    dc.w $0300 ; 11 scroller border right
    dc.w $0600 ; 12 scroller main color
    dc.w $0600 ; 13 scroller main color
    dc.w $0600 ; 14 scroller main color
    dc.w $0600 ; 15 scroller main color

scrollerpalred3:
    dc.w $0711 ; 0 %0000 bg
    dc.w $0666 ; 1 initial border color (invisible, change to 777 later) (further out)
    dc.w $0555 ; 2 initial border color (invisible, change to 777 later) (closer to the middle)
    dc.w $0000 ; 3 inital cursor color (black)
    dc.w $0400 ; 4 scroller border left
    dc.w $0400 ; 5 scroller border left
    dc.w $0400 ; 6 scroller border left
    dc.w $0400 ; 7 scroller border left
    dc.w $0300 ; 8 scroller border right
    dc.w $0300 ; 9 scroller border right
    dc.w $0300 ; 10 scroller border right
    dc.w $0300 ; 11 scroller border right
    dc.w $0600 ; 12 scroller main color
    dc.w $0600 ; 13 scroller main color
    dc.w $0600 ; 14 scroller main color
    dc.w $0600 ; 15 scroller main color

scrollerpalred4:
    dc.w $0711 ; 0 %0000 bg
    dc.w $0666 ; 1 initial border color (invisible, change to 777 later) (further out)
    dc.w $0555 ; 2 initial border color (invisible, change to 777 later) (closer to the middle)
    dc.w $0000 ; 3 inital cursor color (black)
    dc.w $0400 ; 4 scroller border left
    dc.w $0400 ; 5 scroller border left
    dc.w $0400 ; 6 scroller border left
    dc.w $0400 ; 7 scroller border left
    dc.w $0300 ; 8 scroller border right
    dc.w $0300 ; 9 scroller border right
    dc.w $0300 ; 10 scroller border right
    dc.w $0300 ; 11 scroller border right
    dc.w $0600 ; 12 scroller main color
    dc.w $0600 ; 13 scroller main color
    dc.w $0600 ; 14 scroller main color
    dc.w $0600 ; 15 scroller main color

vbicounter:
    dc.w 0

keyclick: ; taken from emutos!
    dc.b $3B,0 ; channel A pitch (0,1)
    dc.b 0,0 ; no channel B (2,3)
    dc.b 0,0 ; no channel C (4,5)
    dc.b 0 ; no noise (6)
    dc.b $FE ; only channel A (7)
    dc.b 16 ; channel A amplitude (8)
    dc.b 0 ; channel B amp (9)
    dc.b 0 ; channel B amp (10)
    dc.b $80 ; envelope (11)
    dc.b 1 ; envelope (12)
    dc.b 3 ; envelope (13)

    even

sndrs:
    dc.b 0,0
    dc.b 0,0
    dc.b 0,0
    dc.b 0
    dc.b $FF
    dc.b 0
    dc.b 0
    dc.b 0
    dc.b 0
    dc.b 0
    dc.b 0

    even

nos:	DC.B	0,0,$3E,0
	dc.b	1,0,1,0
	DC.B	2,0,$EE,0
	dc.b	3,0,0,0
	DC.B	4,0,$59,0
	dc.b	5,0,2,0
	DC.B	6,0,7,0
	dc.b	7,0,$F8,0
vols:
	DC.B	8,0
vol1	dc.b	$E,0
	DC.B	9,0
vol2	dc.b	$E,0
	DC.B	$A,0
vol3	dc.b	$F,0

    even

scrolltext:
    dc.b 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,5,12,12,15,0,19,9,12,12,9,22,5,14,20,21,18,5,27,27,27,0,0,20,8,9,19,0,12,9,20,20,12,5,0,9,14,20,18,15,0,9,19,0,1,0,6,21,12,12,25,0,19,25,14,3,8,18,15,14,9,26,5,4,0,19,16,18,9,20,5,0,1,14,4,0,19,3,18,15,12,12,5,18,0,2,18,5,1,11,9,14,7,0,1,12,12,0,2,15,18,4,5,18,19,29,0,3,15,4,5,0,2,25,0,20,5,3,5,18,0,30,31,0,18,21,12,5,26
    ;dc.b 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
    ;dc.b 'HELLO_HELLO_HELLO__SILLYVENTURE__THIS_IS_A_FULLY_SYNCED_SCROLLER____NO_BLITTER____NO_STE___JUST_PLAIN_ST____THANKS_TO__'
    ;dc.b 'LEONARD_FOR_THE_FANTASTIC_STRINKLER____THANKS_TO_GREY_AGAIN___THANKS_TO_ALL_THE_NICE_ATARI_PEOPLE_____________________'
scrolltextsize equ *-scrolltext
    even
screen_toggle:
    dc.b 0
screen_toggle_b:
    dc.b 0
    even

scrollpos: ; pointer to the current position inside scrolltextbuffer
    dc.l scrolltextbuffer

font_addr1:
    dc.l font_shift_r
font_addr2:
    dc.l font_shift_l

screentables:
    dc.l screentable1,screentable2

spr_bgs:
    dc.l spr_bg1,spr_bg2

spr_bgs2:
    dc.l spr_bg3,spr_bg4

play_sound:
    dc.l 0

snd_keyclick_data:
    dc.b $00,$3B ; register 0 (chan 1)
    dc.b $01,$00 ; register 1 (chan 1)
    dc.b $02,$00 ; register 2 (chan 2)
    dc.b $03,$00 ; register 3 (chan 2)
    dc.b $04,$00 ; register 4 (chan 3)
    dc.b $05,$00 ; register 5 (chan 3)
    dc.b $06,$00 ; register 6 (noise)
    dc.b $07,$FE ; register 7 (chan select)
    dc.b $08,$10 ; register 8 (amplitude chan 1)
    dc.b $09,$00 ; register 9 (amplitude chan 2)
    dc.b $0a,$00 ; register 10 (amplitude chan 3)
    dc.b $0b,$80 ; register 11 (envelope)
    dc.b $0c,$01 ; register 12
    dc.b $0d,$03 ; register 13

snd_bell_data:
    dc.b 0,$34   ; /* channel A pitch */
    dc.b 1,0
    dc.b 2,0     ;  /* no channel B */
    dc.b 3,0
    dc.b 4,0     ;  /* no channel C */
    dc.b 5,0
    dc.b 6,0     ;  /* no noise */
    dc.b 7,$FE   ; /* no sound or noise except channel A */
    dc.b 8,$10  ;  /* channel A amplitude */
    dc.b 9,0
    dc.b 10,0
    dc.b 11,0    ;  /* envelope */
    dc.b 12,16
    dc.b 13,9

    bss
current_pal_sequence_struct:
    ds.w 1 ; counter
    ds.l 1 ; address of the palette
    ds.l 1 ; address of the next entry in the sequence

current_snd_sequence_struct:
    ds.w 1 ; counter
    ds.l 1 ; address of the sounddata
    ds.l 1 ; address of the next entry in the sequence

current_sprite_sequence_struct:
    ds.w 1 ; counter
    ds.l 1 ; address of animated sprite definition
    ds.l 1 ; address of next entry in sequence

current_sprite_sequence_struct2:
    ds.w 1 ; counter
    ds.l 1 ; address of animated sprite definition
    ds.l 1 ; address of next entry in sequence

current_ani_sprite_struct: ; holds data of the currently displayed animated sprite
    ; this struct needs to contain:
    ; - 0w: counter which counts to (including) 0 (delay value)
    ; - 2l: pointer to the sprite data (base address)
    ; - 6w: offset to the correct shift (sprite_size_per_shift(384) bytes * shift (x % 16))
    ; - 8w: offset to the screen address (230 * y coordinate + x offset (x // 16 * 8))
    ; - 10l: pointer to the *next* position in the animated sprite definition (f.e. ani_spr_cursor)
    ds.w 1 ; counter
    ds.l 1 ; base sprite data address
    ds.w 1 ; shift offset
    ds.w 1 ; screen address offset
    ds.l 1 ; next position in the definition

current_ani_sprite_struct2: ; holds data of the currently displayed animated sprite
    ; this struct needs to contain:
    ; - 0w: counter which counts to (including) 0 (delay value)
    ; - 2l: pointer to the sprite data (base address)
    ; - 6w: offset to the correct shift (sprite_size_per_shift(384) bytes * shift (x % 16))
    ; - 8w: offset to the screen address (230 * y coordinate + x offset (x // 16 * 8))
    ; - 10l: pointer to the *next* position in the animated sprite definition (f.e. ani_spr_cursor)
    ds.w 1 ; counter
    ds.l 1 ; base sprite data address
    ds.w 1 ; shift offset
    ds.w 1 ; screen address offset
    ds.l 1 ; next position in the definition

fontoffset1:
    ds.w 1
fontoffset2:
    ds.w 1
prev_scrolltextentry:
    ds.w 1 ; when looking back the previous entry...
scrolltextbuffer:
    ds.w 4*scrolltextsize+1 ; 4 entries per character, last one is -1 to indicate the end

; mouse vector
mouse_vec:
    ds.l 1

; log screen address
logbase:
    ds.l 1

; old resolution
res:
    ds.w 1

; old palette
pal:
    ds.w 16

; cursor blink rate (in vbl-calls, i.e. 1/50 secs)
blink_rate:
    ds.w 1
curr_blink:
    ds.w 1

spr_cursor:
    ds.l 6*16*16 ; 6 lw (2 mask+4 planes) * 16 lines * 16 shifts

spr_empty:
    ds.l 6*16*16 ; 6 lw (2 mask+4 planes) * 16 lines * 16 shifts

spr_cursor_legs1:
    ds.l 6*16*16 ; 6 lw (2 mask+4 planes) * 16 lines * 16 shifts

spr_cursor_legs2:
    ds.l 6*16*16 ; 6 lw (2 mask+4 planes) * 16 lines * 16 shifts

spr_bg1:
    ds.l 1+4*16 ; start address + 4 planes * 16 lines
spr_bg2:
    ds.l 1+4*16 ; start address + 4 planes * 16 lines
spr_bg3:
    ds.l 1+4*16 ; start address + 4 planes * 16 lines
spr_bg4:
    ds.l 1+4*16 ; start address + 4 planes * 16 lines

fontcharactersize equ 256 ; the char in the font (which is only part of the full character...) takes up that many bytes: 2 words(planes) * 64 lines = 128 words = 256 bytes
font:
    ; 64x64, i.e. 2 planes * 2 lw * 64 per character, 32 characters
    ; ordering is 1st word = 1st line 1st plane left, 2nd word is 1st line 2nd plane left
    ;  3rd word is 2nd line 1st plane left, 4th word is 2nd line 2nd plane left
    ; ...
    ; all of that x3 because we need three copies of the font:
    ; 1. normal: word1: (L1)(R1) word2: (L2)(R2) where Lx and Rx are bytes of the left half and the right half of the char in plane x
    ; 2. shifted to the right (zeroed out): word1: 00(L1) word2: 00(L2)
    ; 3. shifted to the left  (zeroed out): word1: (R1)00 word2: (R2)00
    ;  
    ds.l 2*2*64*32 ;
font_shift_r:
    ds.l 2*2*64*32
font_shift_l:
    ds.l 2*2*64*32

; the new screen address
scrn:
    ds.b 256 ; byte boundary (word boundary (i.e. bit 0 = 0) in the msb!)
s:
    ds.b 28*230 ; top border area. actually, the first scanline is 160 though...
    ds.b 200*230 ; main screen
    ds.b 48*230 ; bottom border, theoretically up to 48 lines, 28 are quite safe to use
    ; functioning for fullscreen:
    ;ds.b 28*230 ; top border area. actually, the first scanline is 160 though...
    ;ds.b 200*230
    ;ds.b 32*230
    ;ds.b 32*160 ; top border area
    ;ds.b 32000 ; main screen
    ;ds.b 32*160 ; bottom border area
; total screen length in bytes
screen_len equ *-s

; the new screen address
scrn2:
    ds.b 256 ; byte boundary (word boundary (i.e. bit 0 = 0) in the msb!)
s2:
    ds.b 28*230 ; top border area. actually, the first scanline is 160 though...
    ds.b 200*230 ; main screen
    ds.b 48*230 ; bottom border, theoretically up to 48 lines, 28 are quite safe to use

; screen address (not really, we add 160 bytes for the first line already, because afterwards every line has 230 bytes)
screen:
    ds.l 1
screens:
screen1:
    ds.l 1
screen2:
    ds.l 1

screenoffsettable:
    ds.w 28+200+bot_lines

screentable1:
    ds.l 28+200+bot_lines ; address of every line in the screen, avoids repeated *230
screentable2:
    ds.l 28+200+bot_lines

hw_screen: ; screen address in format to slap into hw register with movep on the next sync
    ds.w 1
hw_screens:
    ds.w 1 ; filler
hw_screen1: ; screen 1 address in format to slap into hw register with movep
    ds.w 1
    ds.w 1 ; filler
hw_screen2: ; screen 2 address in format to slap into hw register with movep
    ds.w 1

spr_position_addr:
    ds.l 1
scrollscraddr:
    ds.l 1
scrollscraddrs:
scrollscraddr1:
    ds.l 1
scrollscraddr2:
    ds.l 1