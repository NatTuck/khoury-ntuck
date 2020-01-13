.global main
.text
main:
  /* allocate 4 bytes on stack */
  push %ebx // callee save
  enter $4, $0
  /*
  Pseudocode:

  main() {
    long x;             // x is 0(%rsp)
    scanf("%ld", &x);
    long y = fact(x);
    printf("fact(%ld) = %ld\n", x, y);
  }

  */

  // Arguments in reverse order
  mov %esp, %ecx // the address
  push %ecx
  push $scanfmt
  call scanf

  // Restore the stack pointer
  // pushing moved it down, so we add to move it back up
  add $8, %esp

  mov (%esp), %ebx // the value at the address
  push %ebx
  call fact
  add $4, %esp

  push %eax
  push %ebx
  push $printfmt
  call printf
  add $12, %esp

  leave
  pop %ebx
  ret

fact:
  enter $0, $0

  /*
  	fact(x) {
	    if (x <= 1) return 1;
	    return x * fact(x-1);
	  }
  */

  mov 8(%esp), %ecx // first arg

  mov $1, %eax
  cmp $1, %ecx
  jle fact_done

  push %ecx
  dec %ecx
  push %ecx
  call fact
  add $4, %esp

  pop %ecx

  imul %ecx

  /* after doing caller-save,
     try callee-save with %ebx */

fact_done:
  leave
  ret


.data
scanfmt: .string "%ld"
printfmt: .string "fact(%ld) = %ld\n"

