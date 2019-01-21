.global main
.text
main:
  enter $0, $0

  mov $'5, %dl
  mov 8(%rsi), %rsi

  leave
  ret

.data
yes_msg: .string "Yes, all fives."
no_msg: .string "Nope, there's an non-five."

