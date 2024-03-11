#include<stdlib.h>
#include<stdio.h>

int main() {
	int n; scanf("%d",&n);
	int a[501];
	a[0]=0;
	getc(stdin);
	for(int i=1; i<=n; i++){
		a[i]=a[i-1]+((getc(stdin)=='G')?1:-1);
	}
	int M=-1;
	for(int i=0; i<n+1; i++)if(a[i]>M)M=a[i];
	for(int y=0; y<M; y++) {
		for(int x=1; x<=n; x++) {
			if(a[x-1]==a[x]+1 && a[x]==M-y-1)printf("\\");else
			if(a[x-1]+1==a[x] && a[x]==M-y)printf("/");else
				printf(".");
		}
		printf("\n");
	}
	return 0;
}
