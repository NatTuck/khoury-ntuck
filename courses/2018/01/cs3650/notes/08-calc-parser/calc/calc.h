#ifndef CALC_H
#define CALC_H

#include "sexp.h"

sexp* tokens(char* text);
sexp* parse(sexp* toks);
sexp* eval(sexp* expr);

#endif
