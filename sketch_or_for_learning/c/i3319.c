#include<stdio.h>
#include<stdlib.h>

int m[1001];
int skak(int s,int z,int k1,int k2,int k) {
	m[z]=1;
	if(k==0)return 0;
	return ((k1<s)?1+skak(s-k1,z+k1,k1,k2,k-1):0)+
	       ((k2<s)?1+skak(s-k2,z+k2,k1,k2,k-1):0)+
	       ((k1<z)?1+skak(s+k1,z-k1,k1,k2,k-1):0)+
	       ((k2<z)?1+skak(s+k2,z-k2,k1,k2,k-1):0);
}

int main() {
	int n,k1,k2,s;
	scanf("%d%d%d%d",&n,&k1,&k2,&s);
	skak(n,0,k1,k2,s);
	int r=0;
	for(int i=0; i<n; i++)r+=m[i];
	printf("%d\n",r);
	return 0;
}
