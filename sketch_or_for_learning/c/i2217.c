#include<stdio.h>

int main() {
	unsigned char m[]={0,0,0,0,0,0,0,0};
	int x=7,y=7;
	int n; scanf("%d",&n);
	m[y]|=1<<(7-x);
	for(int i=0; i<n; i++) {
		int u; scanf("%d",&u);
		if(u==0 && x>0) x--;
		if(u==1 && y>0) y--;
		if(u==2 && x<7) x++;
		if(u==3 && y<7) y++;
		m[y]|=1<<(7-x);
	}
	long r=0;
	for(long i=7,j=1; i>=0; i--, j<<=8) {
		r+=j*m[i];
	}
	printf("%ld\n",r);
	return 0;
}
