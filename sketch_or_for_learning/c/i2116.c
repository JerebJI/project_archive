#include<stdio.h>

int a[11];
int main() {
	for(char c='9'+1; c!=' '; c=getc(stdin))a[c-'0']=1;
	for(char c='9'+1; c!='\n'; c=getc(stdin))a[c-'0']+=1;
	int r=0;
	for(int i=0; i<10; i++)r+=(a[i]!=0);
	printf("%d\n",r);
	return 0;
}
