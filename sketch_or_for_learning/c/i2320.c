#include<stdio.h>

typedef struct par {
	int pos;
	char r;
}par;

par eval(char s[]) { 
	par res;
	res.pos=1;
	if(*s=='T' || *s=='F')res.r=*s;
	if(*s=='!') {
		par r=eval(s+1);
		res.pos+=r.pos;
		res.r=(r.r=='F')?'T':'F';
	}
	if(*s=='&') {
		par r1=eval(s+1);
		par r2=eval(s+1+r1.pos);
		res.pos+=r1.pos+r2.pos;
		res.r=(r1.r=='T' && r2.r=='T')?'T':'F';
	}
	if(*s=='|') {
		par r1=eval(s+1);
		par r2=eval(s+1+r1.pos);
		res.pos+=r1.pos+r2.pos;
		res.r=(r1.r=='T' || r2.r=='T')?'T':'F';
	}
	return res;
}


int main() {
	par r=eval("&T|!TF");
	printf("%c\n",r.r);
	return 0;
}
