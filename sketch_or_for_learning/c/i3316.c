#include<stdio.h>

int n,a,b,r=0;
int p[20];

int rek(int k) {
	if(p[k]==1) return 0;
	p[k]=1;
	int je=1;
	for(int i=0; i<n; i++) je=je && p[i];
	if(je){
		r++;
		p[k]=0;
		return 0;
	}
	for(int i=a; i<=b; i++) {
		if(k+i<n)rek(k+i);
		if(k-i>=0)rek(k-i);
	}
	p[k]=0;
	return 0;
}

int main() {
	scanf("%d%d%d",&n,&a,&b);
	rek(0);
	printf("%d\n",r);
	return 0;
}
