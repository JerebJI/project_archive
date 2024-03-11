#include<stdio.h>
#include<stdlib.h>

typedef struct _vozl {
	int podatek;
	struct _vozl* n;
	struct _vozl* nn;
} Vozlisce;

int vstavi(int pod,Vozlisce* pred) {
	Vozlisce* v = (Vozlisce*) malloc(sizeof(Vozlisce));
	v->podatek=pod;
	v->n=pred->n;
	v->nn=pred->nn;
	pred->n=v;
	pred->nn=v->n;
	return 0;
}

Vozlisce* vstaviUrejeno(Vozlisce* zacetek, int element) {
	if(zacetek->podatek > element) {
		Vozlisce* v = (Vozlisce*) malloc(sizeof(Vozlisce));
		v->n=zacetek;
		v->nn=zacetek->n;
		v->podatek=element;
		return v;
	}
	Vozlisce* i;
	for(i=zacetek; i->n!=NULL; i=i->n) {
		if(i->n->podatek > element){
			vstavi(element,i);
			break;
		}
		if(i->nn==NULL) {
			vstavi(element,i->n);
			break;
		}
	}
	return zacetek;
}
