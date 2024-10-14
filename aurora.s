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

; into supervisor
    clr.l -(sp)
    move.w #$20,-(sp)
    trap #1
    addq.l #6,sp
    move.l d0,-(sp) ; put the old stack pointer on top

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

; get the (new) screen address (make sure it has the lower byte = 0)
    move.l #scrn,d0
    add.l #255,d0
    clr.b d0 ; clear the lower byte
    move.l d0,screen ; and store the result as the new screen address (this is actually "somewhere" beween "scrn" and "s")
    move.l d0,a6 ; also, store it in a6 to put some data in

; set the new (larger) screen address
    move.l d0,d1
    moveq #-1,d0
    jsr set_scrn

; set the new palette
    movem.l my_pal,d0-d7
    movem.l d0-d7,$ffff8240.w

    ; sooo, mal etwas grafik auf den screen
    lea 160(a6),a6 ; first line, 160 bytes, skip it, it is somehow shifted anyway
    
    ; now, there are 27 lines of the lower border
    rept 27
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

; upper border
    rept 10
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
    move.l #$0fff0fff,(a6)+
    move.l #$0fff0fff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
; draw a right border
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$f000f000,(a6)+
    move.l #$f000f000,(a6)+
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

    rept 180
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
    move.l #$0ff00ff0,(a6)+
    move.l #$0ff00ff0,(a6)+
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
    move.l #$000f000f,(a6)+
    move.l #$000f000f,(a6)+
    move.l #$f000f000,(a6)+
    move.l #$f000f000,(a6)+
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
    rept 10
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
    move.l #$0fff0fff,(a6)+
    move.l #$0fff0fff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
; draw a right border
    move.l #$ffffffff,(a6)+
    move.l #$ffffffff,(a6)+
    move.l #$f000f000,(a6)+
    move.l #$f000f000,(a6)+
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

; set up vbl (will initialize timer b every time)
    move.l $70.w,-(sp) ; store old vbl on top of stack
    move.l #my_70,$70.w ; install new vbl!

; main program
    jsr inp ; wait for input

; restore vbl
    move.l (sp)+,$70.w

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
; total cycles = 8+4*1065+1064*12+14 = 17050
; number of nops then 17050 / 4 = 4262.5

; it seems those 2 cycles are totally ok to go up or down (actually even a few more or less are ok at this stage)

    move.w sr,d0 ; "nop" of 6 cycles
    rept 4261
    nop
    endr ; total of 4262.5 nops

    ;move.w sr,d0 ; "nop" of 6 cycles
    ;rept 3730
    ;nop
    ;endr

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

    eor.w   #$f0f,$ffff8240.w ; do sth with palette bg color

    sub.w   d0,d1 ; d0 <> 0, d1 = 16 => d1 = 16 - d0
    lsl.w   d1,d0 ; probably some trick to sync with the correct number of cycles without hassle (i.e. "synchronize" the cpu)
    
    eor.w   #$f0f,$ffff8240.w ; reset palette bg color

    ;move.l screen,a0
    ;eor.w #$ffff,160(a0)
    ;; 40 cycles

;; cycle count...
;    lea curr_blink,a0
;    subq.w #1,(a0)
;    bne.s noblink ; 8 or 10 cycles
;    move.w blink_rate,(a0)
;    move.l screen,a0
;    eor.w #$ffff,(a0)
;    bra.s blinkcont ; this branch has a total of 20+20+16+10=66 cycles - but this branch takes 2 cycles less (?) when bne'ing (8 cycles)
;noblink:
;    nop
;    nop
;    nop
;    nop
;    nop
;    nop
;    nop
;    nop
;    nop
;    nop
;    nop
;    nop
;    nop
;    nop
;    nop
;    nop

;blinkcont:
;; total 100 cycles

    move.w #$820a,a0
    ; up to this point, after the wait: 58 cycles

    rept 85
    nop
    endr ; 340 more cycles = total 398 cycles in the first line

;; taking the blink into account (100 cycles less):
;    rept 60
;    nop
;    endr ; 240 more cycles = total 398 cycles in the first line

lines   equ     227

    rept    lines

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
* LEFT HAND BORDER!
    move.b  d3,(a1)         ; to monochrome 8 cycles
    move.b  d4,(a1)         ; to lo-res 8 cycles

    dcb.w   90,$4e71 ; 90*4 = 360 cycles

* RIGHT AGAIN...
    move.b  d4,(a0) ; 8 cycles
    move.b  d3,(a0) ; 8 cycles

    dcb.w   13,$4e71 ; 13*4 = 52 cycles

* EXTRA!
    move.b  d3,(a1) ; 8 cycles
    nop ; 4 cycles
    move.b  d4,(a1) ; 8 cycles

* BUST BOTTOM BORDER...
    dcb.w   8,$4e71 ; 8*4 = 32 cycles
    move.b  d4,(a0) ; 8 cycles
    move.b  d3,(a0) ; 8 cycles

; total of 512 cycles here also

* BOTTOM BORDER LEFT & RIGHTS!
; what hatari displays is about 48 lines, but this code only works with 44... (respectively the possibility to exit is lost)
bot_lines       equ     28
    rept    bot_lines

    nop
* LEFT HAND BORDER!
    move.b  d3,(a1)         ; to monochrome
    move.b  d4,(a1)         ; to lo-res

    dcb.w   89,$4e71

* RIGHT AGAIN...
    move.b  d4,(a0)
    move.b  d3,(a0)

    dcb.w   13,$4e71

* EXTRA!
    move.b  d3,(a1)
    nop
    move.b  d4,(a1)

    dcb.w   12,$4e71

    endr ; same as before, 512 cycles per line

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

; get the logical screen address (mostly to make it easier to debug, as depac's mon messes with the phys base)
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
    lea     pal(pc),a1
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
    lea     pal(pc),a0
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

    data
mouse_params:
    dc.b    0,1,1,1
my_pal:
    incbin 'spr_pal.dat'

    bss
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

    even
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

; screen address
screen:
    ds.l 1