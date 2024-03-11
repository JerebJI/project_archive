#include<stdio.h>
#include<stdlib.h>

typedef struct vozlisce {
	struct vozlisce* next;
	int x;
} Vozlisce;

Vozlisce* prepisi(int* t) {
	if(*t==0)return NULL;
	Vozlisce* v=(Vozlisce*) malloc(sizeof(Vozlisce));
	v->x=*t;
	Vozlisce* z=v;
	for(int i=1; t[i]!=0; i++) {
		z->next=(Vozlisce*)malloc(sizeof(Vozlisce));
		z->next->x=t[i];
		z=z->next;
	}
	z->next=NULL;
	return v;
}


int main() {
	int a[] = {1,2,3,4,5,6,-2,-1,0};
	Vozlisce* v=prepisi(a);
	for(; v->next!=NULL; v=v->next)printf("%d,",v->x);
	printf("%d\n",v->x);
	return 0;
}
