#include <stdio.h>

struct sw {
	int f, g;
} w, *q;

void swap3(int *pa, int *pb, int *pc) {
	int d;
	d=*pa; *pa=*pb; *pb=*pc; *pc=d;
}

int test(int a[]){
	printf("[%d]\n",sizeof(a));
	return 0;
}

int main() {
	int a=1, b=2, c=3, abc[]={1,2,3,4,5};
	int *x, **y, *z;

	w.f=1; w.g=2;
	q=&w;

	printf("%d %d\n", (*q).f, q->g);

	void *v;
	((ws*)v)->f

/*
	x=&a;
	y=&x;

	z=abc;
	printf("%d (z:%d, abc:%d)\n",z[2],sizeof(z),sizeof(abc));

	printf("%d\n", **y); 

	printf("%d %d %d -> ", a, b, c);
	swap3(&a, &b, &c);
	printf("%d %d %d\n", a, b, c);

	test(abc);
	a[c] == *(a+c)
	abc+3*sizeof(int)*/


	return 0;
}
