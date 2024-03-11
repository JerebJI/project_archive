#include<stdio.h>
#include<stdbool.h>
#include<string.h>
#include<stdlib.h>

/*
char s[100001],t[100001];
int main() {
	int n=0,r=0,p=0,p1=0,i=0;
	scanf("%[^\n]s",s);
	for(;s[i]!=0;i+=p+p1) {
		sscanf(s+i,"%[^0123456789]s",t);
		p=strlen(t);
		sscanf(s+i+p,"%d%n",&n,&p1);
		printf("%s;%s;%d\n",t,s+i+p,n);
		r+=n;
	}
	printf("%d\n",r);
}
*/
/*
char s[100001];
int main() {
	int n;
	for(int i=0; i<10; i++){
		scanf("%[^0123456789]s%d",s,&n);
		printf("[%s;%d]\n",s,n);
	}
	return 0;
}
*/

char s[100001],t[100001];
int main() {
	int r=0;
	scanf("%[^\n]s",s);
	for(int i=0; 1==sscanf(s+i,"%[^ ]s",t); i+=1+strlen(t))
		if(strspn(t,"0123456789")==strlen(t))
			r+=atoi(t);
	printf("%d\n",r);
	return 0;
}
