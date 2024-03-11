#ifndef _BUTT_
#define _BUTT_
#include "sutils.h"
struct G{int p=0,ak=0;bool s=false;unsigned long t=0,st=0;};

G simp(G g,I v){g.ak+=g.s=(v!=g.p);g.p=v;return g;}
G timp(G g){g.t=millis();if(g.s)g.st=g.t;return g;}
G ntpr(G g,I v){return timp(simp(g,v));}
G ntco(G g,G ng){g.p=ng.p;g.ak=ng.ak;g.s=ng.s;return g;}
G proc(G g,I v,I m){G ng=ntpr(g,v);g=ntco(g,ng);return(m<ng.st-g.st)?ng:g;}

I ge(G g,I f,I s){return g.ak%f/(f/s);}
I pres(G g){return g.s&&g.p;}
I rele(G g){return g.s&&!g.p;}
I swit(G g){return ge(g,4,2);}
I mswi(G g,I n){return ge(g,2*n,n);}

I supd(G*g,I p){*g=ntpr(*g,DR(p));return 0;}
I upd(G*g,I p,I m){*g=proc(*g,DR(p),m);return 0;}
#endif
