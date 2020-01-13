// This example doesn't work.

    .global main

    .text
main:
    enter $0, $0

    mov 8(%ebp), %eax
    cmp $2, %eax
    je main_good

usage:
    push $usage_msg
    call puts
    add $4, %esp
    jmp main_done

main_good:
    mov 12(%ebp), %ecx
    mov 4(%ecx), %eax

    push %eax
    call puts
    add $4, %esp

    mov 12(%ebp), %ecx
    mov 4(%ecx), %eax
    push $'5
    push %eax
    call all_match
    add $8, %esp

    push %eax
    push $int_fmt
    call printf
    add $8, %esp

    cmp $0, %eax
    je match_good

    mov $not_fives_msg, %eax
    jmp main_print

match_good:
    mov $all_fives_msg, %eax
    jmp main_print

main_print:
    push %eax
    call puts
    add $4, %esp
    mov $0, %eax

main_done:
    leave
    ret

all_match:
    ## text = %edx
    ## cc   = 12(%ebp)
    ## ii   = %ecx
    ## rv   = %eax
    enter $16, $0
    mov 8(%ebp), %edx


    mov $1, %eax
    mov $0, %ecx
am_loop_cond:
    mov (%edx, %ecx, 1), %dl
    cmpb $0, %dl
    je am_done

    cmpb %dl, 12(%ebp)
    jne am_done_fail

    inc %ecx
    jmp am_loop_cond
am_done_fail:
    mov $0, %eax
am_done:
    mov %eax, 0(%esp)

    mov 8(%ebp), %ecx
    mov 12(%ebp), %edx
    push %eax
    push %edx
    push %ecx
    push $debug_fmt
    call printf
    add $12, %esp

    mov 0(%esp), %eax
    leave
    ret

    .data
usage_msg:   .string "Usage: ./fives arg"
all_fives_msg: .string "all fives"
not_fives_msg: .string "not all fives"
debug_fmt:   .string "all_match([%s], '%c') = %d\n"
int_fmt:     .string "xx = %d\n"
