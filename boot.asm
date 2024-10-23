org 0h
bits 16     ; 16 bit architecture

_start:
    jmp short start     ;;
    nop                 ;;  hardware compatibility setup
    times 33 db 0       ;;

start:
    jmp 0x7c0:step2

step2:
    cli                     ; clear interrupts
    mov ax,0x7c0            ; segment value entry via ax reg
    mov ds,ax               ; copying to the data segment   
    mov es,ax               ; copying to the extra segment
    mov ax,0x0              ; clr ax
    mov ss,ax               ; move 0x0 to stack segment
    mov sp,0x7c00           ; move stack ptr to address of code
    sti                     ; setup interrupts

    mov ah,2                ; read sector command
    mov al,1                ; 1 sector to read
    mov ch,0                ; cylinder lower bits
    mov cl,2                ; read sector 2
    mov dh,0                ; head number
    mov bx,buffer           ; buffer has the contents of the next sector concatonated in the bin file via make
    int 0x13                ; disk read interrupt
    jc error                ; if unable to read CF=1(set) then print error msg
    mov si,buffer           ; mov si to point to sector 2
    call print
    jmp $

error:
    mov si,error_msg
    call print
    jmp $


print:
    mov bx,0                ; bg color

    .loop:
        lodsb               ; load byte by byte from si to al
        cmp al,0            ; check if al==0 [EO_string]
        je .done            ; jmp if [EO_string]
        call print_char     ; to print each char 
        jmp .loop           ; runs till al!=0

    .done:
        ret

print_char:
    mov ah,0eh              ; command to print to scr
    int 0x10                ; interrupt to print
    ret

error_msg : db "Failed to load sector",0

times 510-($ - $$) db 0
dw 0xaa55

buffer: