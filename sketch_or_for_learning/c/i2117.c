#include<stdio.h>
#include<string.h>

int main() {
	char s[1001]; scanf("%s",s);
	int k; scanf("%d",&k);
	int l=strlen(s);
	char r[1001];
	r[l]=0;
	int c=0;
	for(int i=l-1; i>=0; i--) {
		int zmn=(c+(s[i]-'0')*k);
		r[i]='0'+zmn%10;
		c=zmn/10;
	}
	if(c!=0)printf("%d",c);
	printf("%s\n",r);
	return 0;
}
