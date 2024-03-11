#include<stdio.h>
#include<string.h>

#define S 10001
char a[S],b[S],r[S];
int main() {
	scanf("%10000s%10000s",a,b);
	printf("[%s;%s]\n",a,b);
	int c=0,s=S-1;
	for(int i=S-1; i>=0; i--) {
		int v=c+(a[i]-'0')+(b[i]-'0');
		int c=v/10;
		r[i]=c%10;
		if(c!=0)s=i;
	}
	printf("%s\n",r+s+1);
	return 0;
}
