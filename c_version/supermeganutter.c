double fnf( double v ){
 return v-(unsigned int)v;
}

double nn1 = 0.0;
double nn2 = 0.0;
// SuperMegaNutter, version 'b7'.
double SuperMegaNutter_b7(){
 nn1 += 0.499743730631690299468026764666361;
 if( nn1 > 2147483647.0 ){
  nn1 = fnf( nn1 );
 }
 nn2 -= 0.619712099029093592809216927916784+0.01*fnf(nn1);
 if( nn2 < 0.0 ){
  nn2 += 2147483647.0;
 }
 double a = fnf( nn1 * fnf( nn1 * 0.70635556640556476940272083033647 ) * fnf( nn1 * 0.96241840600902081782173280676402 ) );
 double b = fnf( nn2 * fnf( nn2 * 0.41059769134948776074925592402104 ) * fnf( nn2 * 0.83598420020319692166434447425947 ) );
 nn1 -= fnf(a+b)*0.249871861;
 return fnf( a * 2.79218049951371579168124556907984 - a
              + 
             b
              +
             fnf(nn1+nn2)*1.1235804235832785923589346329  );
}
