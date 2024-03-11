#include<stdio.h>
#include<string.h>

int a[1001],ind=0;
int main() {
	int n; scanf("%d",&n);
	int r=0;
	char s[1001];
	for(int i=0; i<n; i++) {
		scanf("%s",s);
		int l=strlen(s);
		ind=0;
		for(int i=0; i<l; i++) {
			if(s[i]=='(')a[ind++]=0;
			if(s[i]=='[')a[ind++]=1;
			if(s[i]=='{')a[ind++]=2;
			if(s[i]==')'){if(a[ind-1]==0)ind--;else break;}
			if(s[i]==']'){if(a[ind-1]==1)ind--;else break;}
			if(s[i]=='}'){if(a[ind-1]==2)ind--;else break;}
		}
		if(ind==0)r++;
	}
	printf("%d\n",r);
	return 0;
}
