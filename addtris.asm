;******************************************************************************
;       addtris.asm
;       
;       Addtris is free software; you can redistribute it and/or modify
;       it under the terms of the GNU General Public License as published by
;       the Free Software Foundation; either version 3 of the License, or
;       (at your option) any later version. <http://www.gnu.org/licenses/>
;       
;       Written by Jaroslav Beran <jaroslav.beran@gmail.com>, on 23.1.2018
;
;       How to compile:
; 
;       tasm addtris
;       tlink addtris /t
;
;******************************************************************************

.model tiny        

.data

txt01   db      'ADDTRIS',13,10,'$'

.code
        org 100h
start:
        call    clrscr
        
        mov     dh,00h
        mov     dl,00h
        mov     cx,offset txt01
        call    print_at
        
        mov     ah,08h  ;read char with no echo
        int     21h
        
        ;return control back to dos
        mov     ah,4ch  ;dos terminate program
        mov     al,00h  ;return code will be 0           
        int     21h
        
;*********************************
; Clear Screen
;*********************************
clrscr:
        mov     ah,05h  ;select active display page
        mov     al,01h
        int     10h

        mov     ah,02h  ;set cursor position
        mov     bh,01h  ;page number
        mov     dh,00h  ;row
        mov     dl,00h  ;column
        int     10h
        
        mov     cx,80*25
clrscr1:
        mov     ah,02h
        mov     dl,' '
        int     21h
        loop    clrscr1
        
        ret
        
;*********************************
; Print at
;*********************************
;dh=row
;dl=column
;cx=text
print_at:
        mov     ah,02h  ;set cursor position
        mov     bh,01h  ;page number
        int     10h
        
        mov     ah,09h  ;print text
        mov     dx,cx
        int     21h     

        ret        
        
;*********************************
; Get Random Number
;*********************************
 ; get random number and
; store it off in al
get_random:
        xor     ax, ax
        mov     dx, 40h
        in      al, dx
        
        ret
         
;*********************************
; Print decimal number
;*********************************
;ax=num
print_num_d:
        mov     cx,10000
        xor     si,si
print_loop:
        xor     dx,dx
        div     cx      ;result in ax, remain in dx
        
        cmp     cx,1    ;print cx == 1
        je      print_print
        cmp     al,0    ;print if al != 0
        jne     print_print
        cmp     si,0    ;print if already printed before
        je      print_div
print_print:
        mov     si,1    ;already printed
        push    dx
        mov     dl,al   ;print al
        add     dl,'0'
        mov     ah,02h
        int     21h
        pop     dx
print_div:        
        cmp     cx,1
        je      print_end
        mov     bx,10
        push    dx
        xor     dx,dx
        mov     ax,cx
        div     bx
        mov     cx,ax
        pop     ax
        jmp     print_loop
print_end:        
        ret
        
        end start
