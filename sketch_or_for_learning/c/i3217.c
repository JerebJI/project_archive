#include<stdio.h>
#include<stdlib.h>
#include<string.h>
int main() {
	char s[1001]; scanf("%s",s);
	int k; scanf("%d",&k);
	char r[1001];
	int l=strlen(s);
	int o;
	for(int i=0; i<l; i++) {
		r[i]='0'+(o*10+s[i]-'0')/k;
		o=(o*10+s[i]-'0')%k;
	}
	r[l]=0;
	printf("%s\n",r);
	return 0;
}

