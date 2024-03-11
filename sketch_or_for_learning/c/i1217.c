#include<stdio.h>

int p[1000][1000];
int main() {
	int n,k,t; scanf("%d%d%d",&n,&k,&t);
	int r=0;
	for(int i=0; i<1000; i++)for(int j=0; j<1000; j++)p[i][j]=1;
	for(int i=0; i<t; i++) {
		int s; scanf("%d",&s);
		int kup=s/k;
		int globina=k-s%k;
		for(int i=k-1; i>=globina; i++) {
			r+=p[kup][i];
		}
		p[kup][globina]=0;
	}
	printf("%d\n",r);
	return 0;
}
