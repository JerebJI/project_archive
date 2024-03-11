#ifndef _SUTILS_
#define _SUTILS_
typedef int I;
typedef void V;
#define INC(p) for(I i=0;p;i++)
#define INC1(p) for(I i=1;p;i++)
#define PM(p,m) pinMode(p,m)
#define DR(p) digitalRead(p)
#define AR(p) analogRead(p)
#define DW(p,s) digitalWrite(p,s)
#define AW(p,s) analogWrite(p,s)
#endif
