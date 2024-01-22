#include <stdio.h>

#include "supermeganutter.c"

#include <stdio.h>

// Write 32bit integers to stdout, optionally with bits in reversed order

int main(){
 unsigned int o;
 while(1){
  o = (unsigned int)(SuperMegaNutter_b7()*(double)0x100000000);
  #ifdef FLIP
  unsigned int flip = 0;
  for (int i = 0; i < 32; i++) {
   flip = (flip << 1) | ((o >> i) & 1);
  }
  fwrite(&flip, 4, 1, stdout);
  #else
  fwrite( &o, 4, 1, stdout );
  #endif
 }
}