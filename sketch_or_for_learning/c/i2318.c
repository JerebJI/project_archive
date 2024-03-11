#include<stdio.h>
#include<stdlib.h>

int stkov(int kaj,int n, int k) {
	if(n==0) return 1;
	if(k<0) return 0;
	return stkov(2,n-1,k-1)+stkov(1,n-1,k+1);
}

int main() {
	int n,k; scanf("%d%d",&n,&k);
	printf("%d\n",stkov(2,n-1,k-1)+stkov(1,n-1,k+1));
	return 0;
}
