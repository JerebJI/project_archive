#include<stdio.h>
#define S 20
int a[S],b[S],d[S],k[S],n;

int pov() {
	for(int i=n-1; i>=0; i--) {
		if(k[i]<d[i]) {
			k[i]++;
			break;
		} else {
			if(i==0)return -1;
			k[i]=0;
		}
	}
	return 0;
}

int main() {
	scanf("%d",&n);
	for(int i=0; i<n; i++) {
		scanf("%d%d",&a[i],&b[i]);
		d[i]=b[i]-a[i];
	}

	do {
		for(int i=0; i<n; i++) {
			printf("%d",a[i]+k[i]);
		}
		printf("\n");
	} while(pov()!=-1);

	return 0;
}
