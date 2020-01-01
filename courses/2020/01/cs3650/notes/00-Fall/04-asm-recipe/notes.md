---
layout: default
---

## Rant: Efficient Workflows

 - Pull up cookie clicker.
 - Point out that the efficient strategy is to get upgrades ASAP,
   whether they're linear or mutiplicative.

Example upgrades for programming:

 - Touch typing.
   - Save some time typing.
   - Save getting distracted to find a key.
 - Getting an editor with automatic indentation and syntax highlighting.
   - Syntax highlighting automatically catches many syntax errors, saving
     a whole try-to-compile and then debug cycle each time.
 - Getting a keyboard-focused editor and learning the keybindings.
   - In vim, swapping two lines is 3 keystrokes.
 - Becoming familiar with the libraries you're using.
   - Especially the standard library for your language.
   - How do you convert a string to a long in C?
   - Autocompletion doesn't replace this.
 - Learn your environment's debugger in some detail. For us, that's GDB.
 - You'll see more upgrade opportunities. I suggest prioritizing them, even
   if it costs some time right now, even if you're not sure it's an upgrade.

## Discuss the Homework

 - Pull it up on bottlenose
   - Write task in C
   - Then rewrite it in ASM
   - No compiler output
 - Pull up solution directory
 - Show calc running.

## First: HW Questions

 - Homework questions?
 
## How to write an ASM program

Getting started with writing assembly programs can be tricky. The language
forces you to deal with individual instructions, which can make it easy to lose
track of the bigger picture.

## Design Recipe for Assembly Programs

 1. An assembly (or C) program is a bunch of functions.
 2. Figure out at least some of the functions you need.
   - Hint: You need a "main" function. You can start there.
 3. Apply the recipe for functions below to write them.
 4. As you discover new functions you need, write those too.

## Design Recipe for An Assembly Function

### 1. Signature

 - If we don't know our types we can't write anything.

### 2. Pseudocode

 - Easier to think in C.

### 3. Variable Mappings

Your pseudocode has named variables, but your assembly code won't. For each
variable or other value used in your function, decide where that data lives. It
could be in a register (which one?), on the stack (where?), or maybe it's a
global variable (what label?).

You should explicitly write down this mapping as a comment in your assembly code.

Registers:

 - Is it already in an argument? %rdi, %rsi, %rdx, %rcx, %r8, %r9
 - Do we want to return this? %rax
 - Does this not need to survive function calls? %r8-%r11
 - Does this need to survive function calls? %rbx, %r12-%r15
 - Keep in mind that instructions can clobber %rax, %rdx

Memory:

 - Is this a global?
 - Is it easier to not allocate a register? 0(%rsp), 8(%rsp), ...
 - Is this in a data structure? You may end up allocating %r12 as
   a pointer to a struct, and 18(%r12) as a field.

### 4. Skeleton

```
label:
  /* Prologue: */
  /* save callee-save registers */
  enter $??, $0
  /* end of prologue */
 
  /* TODO: function body */

  /* Epilogue: */
  leave
  /* restore (pop) callee-save registers */
  /* pops must be in reverse order from pushes */
  /* end of epilogue */
  ret
```

 * Every function starts with a label and ends with a "ret" instruction.
 * Every function has a prologue and an epilogue to manage the function's
   use of the stack.
 * The prologue saves any callee-save registers to the stack and allocates
   a stack frame for use by the function.
 * The epilogue restores callee-save registers and "frees" the stack frame.
 * Your variable mapping tells you which registers to save: any callee-save
   registers that you're using for anything.
 * Stack alignment: To call further functions, your stack pointer must be
   on a 16-byte boundary.
   - (Stack frame size / 8) + (# of callee-save pushes should be even)
   - If you think you have an exception, explain in a comment.

What do the enter and leave instructions do?

```
  /* enter allocates a stack frame */
  /* the enter $X, $0 instruction acts like: */
  push %ebp
  mov %esp, %ebp
  sub $X, %esp
  /* waste 8 clock cycles */


  /* leave deallocates a stack frame */
  /* the leave instruction acts like: */
  mov %ebp, %esp
  pop %ebp
```

### 5. Write the body of the functions

In this step, you translate your pseudocode to assembly.


## Translating C to ASM

 * C can translate to ASM nearly 1:1.
 * Every C statement can be used to fill in a corresponding
   ASM "template".
 * The resulting ASM will perform the same computation.
 * There are multiple possible templates - these are only
   examples.

## Variables, Temporaries, and Assignment

 * Each C (int, pointer) variable maps to either a register
   or a stack location.
 * Temporary values map to a temporary register.
 * Registers can be shared / reused if you run out.

Example:

Pseudocode:
```
  int a = 5;
  int b = 3 * a + 1; 
```

Mapping variables:

 * a is -8(%rbp)
 * b is -16(%rpb)
 * Our temporary for (3\*a) and (3\*a+1) is %r11

Assembly:
```
# int a = 5;
  mov $5, -8(%rbp)

# int b = 3 * a + 1;
  mov -8(%rbp), %r11
  imulq $3, %r11
  inc %r11
  mov %r11, -16(%rbp)
```

## Sample Program

Collatz Conjecture:

 - Start with an integer > 1.
 - If even, divide by two.
 - If odd, take 3*x+1.
 - Iterate repeatedly

The conjecture:

 - All integers > 1 eventually get you to one.

Our program will take an input on the command line and
print the sequence to one and the number of iterations. 


```
long
iterate(long x)
{
  if (x % 2 == 0) {
    return x/2;
  }
  else {
    return x*3 + 1;
  }
}

int
main(int argc, char* argv[])
{
  long x = atol(argv[1]);
  long i = 0; 
  
  while (x > 1) {
    printf("%ld\n", x);
    x = iterate(x);
    i++;
  }
  
  printf("i = %ld\n"):
  return 0;
}
```

Now, translate to ASM with the recipe. 

Note patterns for "if" and "while" statements.

## Another example:

 - fives

