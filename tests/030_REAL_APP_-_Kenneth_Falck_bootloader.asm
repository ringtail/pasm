; name: REAL APP - Kenneth Falck bootloader
; code: "EA057C000031C08ED88EC088163D7CBE2C7CE80400F4E9FCFF8A044608C0740BB40EB700B307CD10E9EEFFC34c6f6164696e672e2e2e004572726f7200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000055AA"

; NASM MBR boot loader by Kenneth Falck 2009
[bits 16]                               ; 16-bit code
[org 0x7c00]                            ; BIOS loads us at 0x07c0:0000
jmp 0x0000:initialize_bios              ; reset code segment to 0x0000 with long jump

initialize_bios:
        xor ax, ax
        mov ds, ax                      ; reset data segments to 0x0000
        mov es, ax
        mov [bootdrive], dl             ; store boot drive
        mov si, welcome                 ; print welcome string
        call print
        ;jmp load_kernel_header         ; proceed to load kernel

halt:
        hlt                             ; halt CPU to save power
        jmp halt                        ; loop if halt interrupted

print:                                  ; Print string in SI with bios
        mov al, [si]
        inc si
        or al, al
        jz exit_function                ; end at NUL
        mov ah, 0x0e                    ; op 0x0e
        mov bh, 0x00                    ; page number
        mov bl, 0x07                    ; color
        int 0x10                        ; INT 10 - BIOS print char
        jmp print
        exit_function:
        ret

data:
        welcome db 'Loading...', 0      ; welcome message
        error db 'Error', 0             ; error message
        bootdrive db 0x00               ; original BIOS boot drive

times 510 - ($ - $$) db 0               ; filler to 510 bytes
dw 0xaa55                               ; boot signature (fills to 512 bytes)
