#include<stdio.h>
#include<stdlib.h>
#include<string.h>

char pop(char p, char c) {
	if(p=='_' && 'a'<=c && c<='z') return c+='A'-'a';
	return c;
}

int main() {
	int n; char s[1001];
	scanf("%d %s",&n,s);
	printf("%c",pop('_',s[0]));
	for(int i=1; i<n; i++) {
		printf("%c",pop(s[i-1],s[i]));
	}
	return 0;
}
