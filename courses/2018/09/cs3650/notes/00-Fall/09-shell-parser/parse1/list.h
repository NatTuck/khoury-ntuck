#ifndef CALC_LIST_H
#define CALC_LIST_H

#define KIND_NUMB 0
#define KIND_OPER 1

typedef struct numb {
  int kind;
  int numb;
} numb;

typedef struct oper {
  int kind;
  int oper;
} oper;

typedef struct tokn {
  int kind;
} tokn;

tokn* make_numb(int nn);
tokn* make_oper(int cc);
void  free_tokn(tokn* tt);

void  print_tokn(tokn* tt);

// A list is one of:
//  - a pointer to a cell
//  - the null pointer (0) if empty

typedef struct cell {
  tokn* head;
  struct cell* tail;
} cell;

cell* cons(tokn* hh, cell* tt);
tokn* car(cell* xs);
cell* cdr(cell* xs);

void free_list(cell* xs);

int length(cell* xs);
cell* reverse(cell* xs);

void print_list(cell* xs);

#endif
