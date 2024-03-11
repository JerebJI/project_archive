#include<stdio.h>
#include<math.h>

int prast(int x) {
	int s=sqrt(x);
	for(int i=2; i<=s;i++)
		if(x%i==0)return 0;
	return 1;
}

int main() {
	int n,k; scanf("%d%d",&n,&k);
	int j=n+1;
	for(int i=0;i<k;j++){
		if(prast(j)){
			i++;
		}
	}
	printf("%d\n",j-1);
	return 0;
}

