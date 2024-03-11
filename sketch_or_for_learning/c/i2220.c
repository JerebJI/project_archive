#include<stdio.h>
#include<stdlib.h>

typedef struct _vozlisce {
	int podatek;
	struct _vozlisce* naslednje;
} Vozlisce;

Vozlisce* izloci(Vozlisce* zac, Vozlisce* v) {
	if(zac==v)return zac->next;
	for(int i=zac; i->naslednje!=NULL; i=i->zac) {
		if(i->naslednje==v){
			i->naslednje=v->naslednje;
			break;
		}
	}
	return zac;
}

int main() {
}
