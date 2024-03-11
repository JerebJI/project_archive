#include<stdio.h>
#include<stdlib.h>
#include<string.h>

typedef struct _vozl {
	int podatek;
	struct _vozl* naslednje;
} Vozlisce;

Vozlisce* odstrani(Vozlisce* osnova, Vozlisce* indeksi) {
	 Vozlisce * ind = indeksi;
	 if(ind->podatek==0) {
		 osnova=osnova->naslednje;
		 ind=ind->naslednje;
	 }
	 Vozlisce* v=osnova;
	 for(int i=0; ind!=NULL; i++) {
		 if(i+1==ind->podatek) {
			 v->naslednje=v->naslednje->naslednje;
			 ind=ind->naslednje;
		 }else v=v->naslednje;
	 }
	 return osnova;
}

int main() {
	Vozlisce* osnova=malloc(sizeof(Vozlisce));
	Vozlisce* inde=malloc(sizeof(Vozlisce));
	int ind[] = {1,2,4};
	int pod[] = {70,30,60,40,50};
	Vozlisce* v=osnova;
	Vozlisce* p;
	for(int i=0; i<5; i++,p=v, v=v->naslednje) {
		v->naslednje=malloc(sizeof(Vozlisce));
		v->podatek=pod[i];
	}
	free(p->naslednje);
	p->naslednje=NULL;
	v=inde;
	for(int i=0; i<3; i++,p=v, v=v->naslednje) {
		v->naslednje=malloc(sizeof(Vozlisce));
		v->podatek=ind[i];
	}
	free(p->naslednje);
	p->naslednje=NULL;

	odstrani(osnova, inde);

	for(v=osnova; v!=NULL; v=v->naslednje) {
		printf("[%d]",v->podatek);
	}
	return 0;
}
