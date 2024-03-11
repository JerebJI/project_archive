#include<stdio.h>
#include<stdlib.h>

int main() {
	int n; scanf("%d",&n);
	char s[1001];getc(stdin); scanf("%[^\n]s",s);
	int j=0,a[1001];
	for(int i=0; i<1001; i++)a[i]=0;
	for(int i=0; i<n; i++) {
		if(s[i]=='+')j++;
		if(s[i]=='-')a[j]++;
	}
	int r=0;
	for(int i=0; i<j; i++)r+=a[j];
	printf("%d\n",r/j);
	return 0;
}
