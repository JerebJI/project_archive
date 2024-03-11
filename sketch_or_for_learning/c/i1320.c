#include<stdio.h>
#include<stdlib.h>

int main() {
	int n; scanf("%d", &n);
	int a[20];
	for(int i=0; i<n; i++)scanf("%d",&a[i]);
	for(int i=0; i<(1<<n); i++) {
		printf("{");
		int je=0;
		for(int j=0; j<n; j++) {
			if((i>>j)&1){
				printf("%s%d",(je)?", ":"",a[j]);
				je=1;
			}
		}
		printf("}\n");
	}
	return 0;
}
