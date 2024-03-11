#include<stdio.h>
#include<stdlib.h>

typedef struct Vozlisce Vozlisce;
struct Vozlisce {
	int podatek;
	Vozlisce* naslednje;
};

Vozlisce* obrni(Vozlisce* zacetek) {
	if(zacetek==NULL)return zacetek;
	if(zacetek->naslednje==NULL) {
		return zacetek;
	}
	if(zacetek->naslednje->naslednje==NULL) {
		Vozlisce * v=zacetek->naslednje;
		v->naslednje=zacetek;
		zacetek->naslednje=NULL;
		return v;
	}
	if(zacetek->naslednje->naslednje->naslednje==NULL) {
		Vozlisce * v = zacetek->naslednje->naslednje;
		Vozlisce * v1= zacetek->naslednje;
		v->naslednje=v1;
		v1->naslednje=zacetek;
		zacetek->naslednje=NULL;
		return v;
	}
	Vozlisce *p=zacetek;
	Vozlisce *v=zacetek->naslednje;
	Vozlisce *n=zacetek->naslednje->naslednje;
	p->naslednje=NULL;
	for(;n->naslednje!=NULL; p=v, v=n, n=n->naslednje) {
		v->naslednje=p;
	}
	v->naslednje=p;
	n->naslednje=v;
	return n;
}

int main() {
	Vozlisce * z = malloc(sizeof(Vozlisce));
	z->podatek=-1;
	int n=9;
	int i=0;
	for(Vozlisce * v=z; i<n; i++, v=v->naslednje) {
		v->naslednje=malloc(sizeof(Vozlisce));
		v->naslednje->podatek=i;
	}

	z=obrni(z);
	
	for(Vozlisce* v=z; v!=NULL; v=v->naslednje)
		printf("[%d]",v->podatek);
	return 0;
}
