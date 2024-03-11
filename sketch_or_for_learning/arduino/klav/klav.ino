#include "sutils.h"
#include "butt.h"
const I okt=12;const double fa=1.0594630943;const I a=9;
enum ke{t=11,od,og,rec,pla,ks};G g[ks];I p[ks],ok=-1; I buz;
const I M=200;I im=0,to[M];unsigned int d[M],ti;I nu;
double toni(I n){return 440*pow(fa,n);}
I kpre(G g[],I t){I v=-1;INC(i<=t)if(!g[i].p){v=i;break;}return v;}
V setup(){INC(i<ks)PM(p[i]=(i<=t)?i:A0+i-od,INPUT_PULLUP);buz=A4;}
V loop(){INC(i<ks)g[i]=proc(g[i],DR(p[i]),20);I v=kpre(g,t);
  ok=min(max(ok+pres(g[og])-pres(g[od]),-3),3);
  if(-1<v)tone(buz,toni(a+v+ok*okt));else noTone(buz);
  if(swit(g[rec])&&pres(g[rec]))im=0;
  if(swit(g[rec])&&-1<v&&rele(g[v])){to[im]=a+v+ok*okt;d[im]=millis();im=min(M,im+1);nu=1;}
  if(swit(g[rec])&&-1==v&&nu){to[im]=-10000;d[im]=millis();nu=0;im=min(M,im+1);}
  if(pres(g[pla])){INC(i<im-1)if(to[i]>-10000){tone(buz,toni(to[i]));delay(d[i+1]-d[i]);}else{noTone(buz);delay(d[i+1]-d[i]);}}
  delay(5);
}
