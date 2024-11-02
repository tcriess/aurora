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

; count lines with timer b
b_lines equ 228

bot_lines       equ     28

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
    move.l d0,screen2
    move.l d0,d1
    move.l d0,a5
    lsr.l #8,d0
    move.w d0,hw_screen2
    add.l #160+230*(27+200+bot_lines-64),d1
    addq.l #4,d1 ; planes 3+4 instead of 1+2
    move.l d1,scrollscraddr2 ; we start drawing in scrollscraddr2
    move.l d1,scrollscraddr

; get the (new) screen address (make sure it has the lower byte = 0)
    move.l #scrn,d0
    add.l #255,d0
    clr.b d0 ; clear the lower byte
    move.l d0,screen1 ; and store the result as the new screen address (this is actually "somewhere" beween "scrn" and "s")
    move.l d0,screen
    move.l d0,a6 ; also, store it in a6 to put some data in
    move.l d0,d2
    lsr.l #8,d2
    move.w d2,hw_screen1

; set the new (larger) screen address
    move.l d0,d1

    add.l #160+230*(27+200+bot_lines-64),d0 ; scroller is at address screenstart + 160 (first line) + 230 * 27 (upper border) + 230 * 228 (at the very end) - 230 * 64
    addq.l #4,d0 ; planes 3+4 instead of 1+2
    move.l d0,scrollscraddr1

    moveq #-1,d0
    ; new screen still in d1
    jsr set_scrn

; set the new palette
    movem.l my_pal,d0-d7
    movem.l d0-d7,$ffff8240.w

    ; sooo, mal etwas grafik auf den screen
    lea 160(a6),a6 ; first line, 160 bytes, skip it, it is somehow shifted anyway
    lea 160(a5),a5
    
    ; now, there are 27 lines of the lower border
    ; we fill 19 lines now, then 8 lines with bricks
    rept 19
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

    move.l screen1,a6
    move.l screen2,a5

    ; copy the contents of screen1 to screen2
    ; 160 + 230*27 + 230 * 200 + 230*bot_lines bytes
    move.w #(160+230*27+230*200+230*bot_lines)/4-1,d7
.cpyscr:
    move.l (a6)+,(a5)+
    dbra d7,.cpyscr

    ; initially save the sprite background
    lea spr_bg,a0
    rept 16
    movem.l (a1),d0-d3
    movem.l d0-d3,(a0)
    lea 16(a0),a0
    lea 230(a1),a1
    endr

    lea raw_spr_cursor,a0
    lea spr_cursor,a1
    jsr prepare_sprite
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

	movep.w	d0,(a0)
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
; sprite code
    lea spr_cursor,a3 ; 2 mask + 4 planes, 16 lines, 16 shifts
    ; todo: pick the correct shift
    lea spr_bg,a5 ; background buffer 16*16 bytes
    movea.l spr_position_addr,a6 ; screen address

    rept 16
; restore bg
    movem.l (a5),d0-d3
    movem.l d0-d3,(a6)
; todo: adjust screen addr to new position
    movem.l (a6),d0-d3
    move.l d0,(a5)+
    move.l d1,(a5)+
    move.l d2,(a5)+
    move.l d3,(a5)+ ; this seems faster than the "movem + add" version
    ;movem.l d0-d3,(a5)
    ;add.l #16,a5 ; next line
    movem.l (a3)+,d0-d3/a0-a1 ; 2 mask + 4 planes
    movem.l (a6),d4-d7 ; 4 planes
    and.l d0,d4 ; plane 1+2 left
    and.l d0,d5 ; plane 3+4 left
    and.l d1,d6 ; plane 1+2 right
    and.l d1,d7 ; plane 3+4 right
    or.l d2,d4
    or.l d3,d5
    move.l a0,d0
    or.l d0,d6
    move.l a1,d0
    or.l d0,d7
    movem.l d4-d7,(a6)
    lea.l 230(a6),a6
    endr ; 6208 cycles

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
    dcb.w 2652,$4e71

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

    eor.w   #$f0f,$ffff8240.w ; do sth with palette bg color (remove this in production!)

    sub.w   d0,d1 ; d0 <> 0, d1 = 16 => d1 = 16 - d0
    lsl.w   d1,d0 ; probably some trick to sync with the correct number of cycles without hassle (i.e. "synchronize" the cpu)

    ; SYNC is done here!
    
    eor.w   #$f0f,$ffff8240.w ; reset palette bg color (remove this in production!)

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

; every line of the scroller needs *2* lines of byte shifting, unfortunately
; so we start the shifting here and go on for the next 128 lines to have a 64 lines-scroller
; the following rept contains 2 lines
    rept 64
    nop ; start of with a 4 cycles nop
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
    nop

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

    dcb.w   12,$4e71 ; 12*4 = 48 cycles
    endr


;; 129.-132. line, feed 16 lines of the scroller per line
;    rept 4
;    nop
;
;* LEFT HAND BORDER!
;    move.b  d3,(a1)         ; to monochrome 8 cycles
;    move.b  d4,(a1)         ; to lo-res     8 cycles    
;
;    move.l (a4)+,(a5) ; 1. line
;    move.l (a4)+,230(a5) ; 2. line
;    move.l (a4)+,2*230(a5) ; 3. line
;    move.l (a4)+,3*230(a5) ; 4. line
;    move.l (a4)+,4*230(a5) ; 5. line
;    move.l (a4)+,5*230(a5) ; 6. line
;    move.l (a4)+,6*230(a5) ; 7. line
;    move.l (a4)+,7*230(a5) ; 8. line
;    move.l (a4)+,8*230(a5) ; 9. line
;    move.l (a4)+,9*230(a5) ; 10. line
;    move.l (a4)+,10*230(a5) ; 11. line
;    move.l (a4)+,11*230(a5) ; 12. line
;    move.l (a4)+,12*230(a5) ; 13. line
;    move.l (a4)+,13*230(a5) ; 14. line
;    move.l (a4)+,14*230(a5) ; 15. line

;    ; dcb.w   89,$4e71 ; 89*4 = 356 cycles (either 90 here, or 89 here and one single nop before the monochrome/color switch, this seems to make it work on all wakestates!)

;* RIGHT AGAIN...
;    move.b  d4,(a0) ; 8 cycles
;    move.b  d3,(a0) ; 8 cycles

;    move.l (a4)+,15*230(a5) ; 16. line
;    lea 16*230(a5),a5
;    dcb.w   5,$4e71 ; 20 cycles

;    ; dcb.w   13,$4e71 ; 13*4 = 52 cycles

;* EXTRA!
;    move.b  d3,(a1) ; 8 cycles
;    nop ; 4 cycles
;    move.b  d4,(a1) ; 8 cycles

;    dcb.w   12,$4e71 ; 12*4 = 48 cycles
;    endr

; 91 lines until the bottom border!
    rept    91
    nop

* LEFT HAND BORDER!
    move.b  d3,(a1)         ; to monochrome 8 cycles
    move.b  d4,(a1)         ; to lo-res     8 cycles    

    dcb.w   89,$4e71 ; 90*4 = 360 cycles (either 90 here, or 89 here and one single nop before the monochrome/color switch, this seems to make it work on all wakestates!)

* RIGHT AGAIN...
    move.b  d4,(a0) ; 8 cycles
    move.b  d3,(a0) ; 8 cycles

    dcb.w   13,$4e71 ; 13*4 = 52 cycles

* EXTRA!
    move.b  d3,(a1) ; 8 cycles
    nop ; 4 cycles
    move.b  d4,(a1) ; 8 cycles

    dcb.w   12,$4e71 ; 12*4 = 48 cycles
    endr ; 512 cycles per line

* FINAL LINE...
    nop
* LEFT HAND BORDER!
    move.b  d3,(a1)         ; to monochrome 8 cycles
    move.b  d4,(a1)         ; to lo-res 8 cycles

    dcb.w   43,$4e71

    move.l  #$ffff8240,a3
    lea     scrollerpalred1,a4
    move.l (a4)+,(a3)+
    move.l (a4)+,(a3)+
    move.l (a4)+,(a3)+
    move.l (a4)+,(a3)+
    move.l (a4)+,(a3)+
    move.l (a4)+,(a3)+
    move.l (a4)+,(a3)+
    move.l (a4)+,(a3)+

    ; dcb.w   89,$4e71 ; 89*4 = 356 cycles

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

    dcb.w   43,$4e71
    move.l  #$ffff8240,a3
    lea     my_pal,a4
    move.l (a4)+,(a3)+
    move.l (a4)+,(a3)+
    move.l (a4)+,(a3)+
    move.l (a4)+,(a3)+
    move.l (a4)+,(a3)+
    move.l (a4)+,(a3)+
    move.l (a4)+,(a3)+
    move.l (a4)+,(a3)+

    ; dcb.w   89,$4e71 ; 356 cycles

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
    move.w curr_blink,d0
    subq #1,d0
    tst.b d0
    bne cont_blink3

do_blink2:
    ; eor.w   #$0f0,$ffff8240.w ; do sth with palette bg color

    snd_keyclick2
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

    move.l #$ff8201,a0
    movep.w d0,0(a0)

exit_vbi:
; restore registers
    movem.l (sp)+,d0-d7/a0-a6
    move.w  (a7)+,sr

;; now set up timer B to do the bottom border
;    clr.b b_control.w             ; timer B off!
;    move.b #b_lines,b_data.w       ; counter in
;    move.b #8,b_control.w          ; timer B on!
    rte

; new timer b / hbl (called "somewhere" on the last line)
;my_120:
;    movem.l d0/a0,-(sp)

;; wait for counter
;    move.w #b_data,a0
;    move.b (a0),d0 ; get count value
;.pause:
;    cmp.b (a0),d0 ; wait for counter change
;    beq.s .pause
;; exactly on the next line now

;; into 60Hz
;    eor.b   #2,$ffff820a.w

;    rept    15
;    nop
;    endr

;; back into 50 Hz
;    eor.b   #2,$ffff820a.w

;    movem.l (a7)+,d0/a0
;    bclr    #0,$fffffa0f.w ; interrupt in service register A, bit 0 = timer b
;    rte

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

    add.w #384,d5 ; 1 sprite shift uses 16 lines * (8 bytes + 16 bytes) 
    dbra d6,shift_one

    lea 24(a1),a1 ; next line, 24 bytes per line
    dbra d7,shift_line
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


spr_playbook:
    dc.w 52,

ani_spr_cursor:
    dc.w 0,25,1,25,-1 ; sprite_no, delay (1/50s), ..., -1

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
    dc.w $0FFF,$0000,$f000,$0000,$0000
    dc.w $FFFF,$0000,$0000,$0000,$0000
    dc.w $FFFF,$0000,$0000,$0000,$0000
    dc.w $FFFF,$0000,$0000,$0000,$0000
    dc.w $F00F,$0FF0,$0000,$0000,$0000
    dc.w $F00F,$0FF0,$0000,$0000,$0000
    dc.w $F00F,$0FF0,$0000,$0000,$0000
    dc.w $F00F,$0FF0,$0000,$0000,$0000
    dc.w $F00F,$0FF0,$0000,$0000,$0000
    dc.w $F00F,$0FF0,$0000,$0000,$0000
    dc.w $F00F,$0FF0,$0000,$0000,$0000
    dc.w $F00F,$0FF0,$0000,$0F00,$0000
    dc.w $FFFF,$0000,$0000,$0000,$0000
    dc.w $FFFF,$0000,$0000,$0000,$0000
    dc.w $FFFF,$0000,$0000,$0000,$0000
    dc.w $0FFF,$f000,$0000,$f000,$0000

mouse_params:
    dc.b    0,1,1,1
my_pal: ; default palette. we start with a white bg, plane 1+2 are for the background, plane 3+4 are for the scroller
    ; plane 1+2 %0000,%1000,%0100,%1100 ->  4,8,12
    ; plane 3+4 %0000,%0010,%0001,%0011 ->  1,2,3
    dc.w $0777 ; 0 %0000 bg
    dc.w $0666 ; 1 initial border color (invisible, change to 777 later) (further out)
    dc.w $0555 ; 2 initial border color (invisible, change to 777 later) (closer to the middle)
    dc.w $0000 ; 3 inital cursor color (black)
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
    dc.b 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
    ;dc.b 'HELLO_HELLO_HELLO__SILLYVENTURE__THIS_IS_A_FULLY_SYNCED_SCROLLER____NO_BLITTER____NO_STE___JUST_PLAIN_ST____THANKS_TO__'
    ;dc.b 'LEONARD_FOR_THE_FANTASTIC_STRINKLER____THANKS_TO_GREY_AGAIN___THANKS_TO_ALL_THE_NICE_ATARI_PEOPLE_____________________'
scrolltextsize equ *-scrolltext
    even

scrollpos: ; pointer to the current position inside scrolltextbuffer
    dc.l scrolltextbuffer

font_addr1:
    dc.l font_shift_r
font_addr2:
    dc.l font_shift_l

    bss
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

; old timer registers
;old:
;    ds.b 10
;    ds.l 2

; cursor blink rate (in vbl-calls, i.e. 1/50 secs)
blink_rate:
    ds.w 1
curr_blink:
    ds.w 1

spr_cursor:
    ds.l 6*16*16 ; 6 lw (2 mask+4 planes) * 16 lines * 16 shifts

spr_bg:
    ds.l 4*16 ; 4 planes * 16 lines

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

lineainp:
    ds.l 1

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

; screen address
screen:
    ds.l 1
screen1:
    ds.l 1
screen2:
    ds.l 1
hw_screen1: ; screen 1 address in format to slap into hw register with movep
    ds.w 1
hw_screen2:
    ds.w 1
spr_position_addr:
    ds.l 1
scrollscraddr:
    ds.l 1
scrollscraddr1:
    ds.l 1
scrollscraddr2:
    ds.l 1