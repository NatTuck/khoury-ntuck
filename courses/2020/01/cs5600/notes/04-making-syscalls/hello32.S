// hello32.S
    .global main
    .text
main:
    enter $0, $0
  
    mov $4, %eax   // syscall 1: write
    mov $1, %ebx   // fd 1: stdout
    mov $hello, %ecx
    mov $6, %edx   // strlen("Hello\n") == 6
    int $0x80

    leave
    ret

    .data
hello: .string "Hello\n"

