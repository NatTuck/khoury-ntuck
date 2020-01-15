    .global main
    .text
main:
    enter $0, $0
  
    mov $1, %rax   // syscall 1: write
    mov $1, %rdi   // fd 1: stdout
    mov $hello, %rsi
    mov $6, %rdx   // strlen("Hello\n") == 6
    syscall

    leave
    ret

    .data
hello: .string "Hello\n"
