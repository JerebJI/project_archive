#include<stdio.h>
#include<stdlib.h>

long m[70][70][70];
long stev(int n,int g, int d) {
	if(m[n][g][d]!=-1)return m[n][g][d];
	if(g<d)return 0;
	if(n==0)return (g==d)?1:0;
	m[n][g][d]=stev(n-1,g+1,d)+stev(n-1,g,d+1);
	return m[n][g][d];
}

int main() {
	int n; scanf("%d",&n);
	for(int i=0; i<70; i++)for(int j=0; j<70; j++)for(int k=0; k<70; k++)m[i][j][k]=-1;
	printf("%ld\n",stev(n,0,0));
	return 0;
}
