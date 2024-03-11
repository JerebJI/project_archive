#include<stdio.h>

#define abs(x) ((x<0)?(-(x)):(x))

int xk[1000*1000],yk[1000*1000];
int main() {
	int p,q,d; scanf("%d%d%d",&p,&q,&d);
	for(int y=0; y<p; y++)
		for(int x=0; x<q; x++) {
			int t;
			scanf("%d",&t);
			xk[t]=x;
			yk[t]=y;
		}
	int i,r=0;
	for(i=1; i<1000*1000 && r<=d; i++) {
		r+=abs(xk[i]-xk[i-1])+abs(yk[i]-yk[i-1]);
	}
	printf("%d\n",i-2);
	return 0;
}
