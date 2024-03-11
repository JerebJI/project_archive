#include<stdio.h>
#include<string.h>

#define max(x,y) ((x<y)?(y):(x))
char s[1001];
int main() {
	int a[1000],ind=0;
	scanf("%s",s);
	int l=strlen(s),M=0;
	for(int i=0; i<l; i++) {
		if(s[i]=='(')a[ind++]=1;
		if(s[i]==',')a[ind-1]++;
		if(s[i]==')') {
			M=max(M,a[ind-1]);
			ind--;
		}
	}
	printf("%d\n",M);
	return 0;
}
