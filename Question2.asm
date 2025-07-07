section .data
    ; ATM Messages
    welcome_msg db 'Welcome to ATM Simulator', 0xA, 0
    welcome_len equ $ - welcome_msg - 1
    
    menu_msg db 0xA, '--- ATM Menu ---', 0xA
             db '1. Check Balance', 0xA
             db '2. Deposit', 0xA
             db '3. Withdraw', 0xA
             db '4. Exit', 0xA
             db 'Enter your choice: ', 0
    menu_len equ $ - menu_msg - 1
    
    balance_msg db 'Current Balance: $', 0
    balance_msg_len equ $ - balance_msg - 1
    
    deposit_msg db 'Enter amount to deposit: $', 0
    deposit_msg_len equ $ - deposit_msg - 1
    
    withdraw_msg db 'Enter amount to withdraw: $', 0
    withdraw_msg_len equ $ - withdraw_msg - 1
    
    success_deposit db 'Deposit successful!', 0xA, 0
    success_deposit_len equ $ - success_deposit - 1
    
    success_withdraw db 'Withdrawal successful!', 0xA, 0
    success_withdraw_len equ $ - success_withdraw - 1
    
    insufficient_funds db 'Insufficient funds!', 0xA, 0
    insufficient_funds_len equ $ - insufficient_funds - 1
    
    invalid_choice db 'Invalid choice! Please try again.', 0xA, 0
    invalid_choice_len equ $ - invalid_choice - 1
    
    goodbye_msg db 'Thank you for using ATM Simulator!', 0xA, 0
    goodbye_msg_len equ $ - goodbye_msg - 1
    
    newline db 0xA, 0
    
    ; Initial balance (1000 units)
    balance dd 1000

section .bss
    choice resb 1
    amount resd 1
    input_buffer resb 32
    number_buffer resb 32

section .text
    global _start

_start:
    ; Display welcome message
    mov eax, 4
    mov ebx, 1
    mov ecx, welcome_msg
    mov edx, welcome_len
    int 0x80

main_loop:
    ; Display menu
    call display_menu
    
    ; Get user choice
    call get_input
    mov al, [input_buffer]
    mov [choice], al
    
    ; Process choice
    cmp byte [choice], '1'
    je check_balance
    cmp byte [choice], '2'
    je deposit
    cmp byte [choice], '3'
    je withdraw
    cmp byte [choice], '4'
    je exit_program
    
    ; Invalid choice
    mov eax, 4
    mov ebx, 1
    mov ecx, invalid_choice
    mov edx, invalid_choice_len
    int 0x80
    jmp main_loop

check_balance:
    call check_balance_proc
    jmp main_loop

deposit:
    call deposit_proc
    jmp main_loop

withdraw:
    call withdraw_proc
    jmp main_loop

exit_program:
    call exit_proc

; ============ PROCEDURES ============

display_menu:
    mov eax, 4
    mov ebx, 1
    mov ecx, menu_msg
    mov edx, menu_len
    int 0x80
    ret

get_input:
    ; Clear input buffer first
    mov edi, input_buffer
    mov ecx, 32
    xor al, al
    rep stosb
    
    ; Get input
    mov eax, 3
    mov ebx, 0
    mov ecx, input_buffer
    mov edx, 32
    int 0x80
    ret

; Convert string to integer
string_to_int:
    push ebp
    mov ebp, esp
    push ebx
    push ecx
    push edx
    
    mov esi, input_buffer
    xor eax, eax
    xor ebx, ebx
    
convert_loop:
    mov bl, [esi]
    cmp bl, 0xA
    je convert_done
    cmp bl, 0
    je convert_done
    cmp bl, '0'
    jl convert_done
    cmp bl, '9'
    jg convert_done
    
    sub bl, '0'
    imul eax, 10
    add eax, ebx
    inc esi
    jmp convert_loop
    
convert_done:
    pop edx
    pop ecx
    pop ebx
    pop ebp
    ret

; Convert integer to string
int_to_string:
    push ebp
    mov ebp, esp
    push ebx
    push ecx
    push edx
    
    mov eax, [balance]
    mov edi, number_buffer
    mov ecx, 32
    xor al, al
    rep stosb
    
    mov eax, [balance]
    mov edi, number_buffer + 31
    mov byte [edi], 0
    dec edi
    mov ebx, 10
    
    cmp eax, 0
    jne convert_int_loop
    mov byte [edi], '0'
    jmp convert_int_done
    
convert_int_loop:
    xor edx, edx
    div ebx
    add dl, '0'
    mov [edi], dl
    dec edi
    test eax, eax
    jnz convert_int_loop
    
convert_int_done:
    inc edi
    mov esi, edi
    
    pop edx
    pop ecx
    pop ebx
    pop ebp
    ret

; Check Balance Procedure
check_balance_proc:
    push ebp
    mov ebp, esp
    
    ; Display balance message
    mov eax, 4
    mov ebx, 1
    mov ecx, balance_msg
    mov edx, balance_msg_len
    int 0x80
    
    ; Convert balance to string and display
    call int_to_string
    
    ; Calculate string length
    mov ecx, esi
    mov edx, 0
strlen_loop:
    cmp byte [ecx], 0
    je strlen_done
    inc ecx
    inc edx
    jmp strlen_loop
strlen_done:
    
    ; Display balance
    mov eax, 4
    mov ebx, 1
    mov ecx, esi
    int 0x80
    
    ; Display newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80
    
    pop ebp
    ret

; Deposit Procedure
deposit_proc:
    push ebp
    mov ebp, esp
    
    ; Display deposit message
    mov eax, 4
    mov ebx, 1
    mov ecx, deposit_msg
    mov edx, deposit_msg_len
    int 0x80
    
    ; Get amount
    call get_input
    call string_to_int
    mov [amount], eax
    
    ; Add to balance
    add [balance], eax
    
    ; Display success message
    mov eax, 4
    mov ebx, 1
    mov ecx, success_deposit
    mov edx, success_deposit_len
    int 0x80
    
    pop ebp
    ret

; Withdraw Procedure
withdraw_proc:
    push ebp
    mov ebp, esp
    
    ; Display withdraw message
    mov eax, 4
    mov ebx, 1
    mov ecx, withdraw_msg
    mov edx, withdraw_msg_len
    int 0x80
    
    ; Get amount
    call get_input
    call string_to_int
    mov [amount], eax
    
    ; Check if sufficient funds
    mov ebx, [balance]
    cmp eax, ebx
    jg insufficient_funds_error
    
    ; Subtract from balance
    sub [balance], eax
    
    ; Display success message
    mov eax, 4
    mov ebx, 1
    mov ecx, success_withdraw
    mov edx, success_withdraw_len
    int 0x80
    jmp withdraw_done
    
insufficient_funds_error:
    ; Display insufficient funds message
    mov eax, 4
    mov ebx, 1
    mov ecx, insufficient_funds
    mov edx, insufficient_funds_len
    int 0x80
    
withdraw_done:
    pop ebp
    ret

; Exit Procedure
exit_proc:
    ; Display goodbye message
    mov eax, 4
    mov ebx, 1
    mov ecx, goodbye_msg
    mov edx, goodbye_msg_len
    int 0x80
    
    ; Exit program
    mov eax, 1
    xor ebx, ebx
    int 0x80