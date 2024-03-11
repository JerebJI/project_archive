#include<stdio.h>

int a,b;
#define S 1000000
int m[S];
int f(int n) {
	if(n==0)return 1;
	if(m[n]!=-1) return m[n];
	m[n]=f(n/a)+f(n/b);
	return m[n];
}

int main() {
	int n;
	scanf("%d%d%d",&a,&b,&n);
	for(int i=0; i<S; i++)m[i]=-1;
	f(n);
	int r=1;
	for(int i=0; i<S; i++)if(m[i]!=-1)r++;
	printf("%d\n",r);
	return 0;
}
