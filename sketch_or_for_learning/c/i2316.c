#include<stdio.h>

int d[(1<<16)-1],k;

int res(int i,int n) {
	if(n>=k)return 0;
	printf("%d",d[i]);
	res(2*i+1,n+1);
	res(2*i+2,n+1);
	return 0;
}

int main() {
	scanf("%d",&k);
	for(int i=0; i<(1<<k)-1; i++)
		scanf("%d",&d[i]);
	res(0,0);
	return 0;
}
