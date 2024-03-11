#include<stdlib.h>
#include<stdio.h>
#include<string.h>

typedef struct Oseba Oseba;
struct Oseba {
	char* ime;
	int starost;
};

int swap(Oseba** osebe, int i, int j) {
	Oseba* t;
	t=osebe[i];
	osebe[i]=osebe[j];
	osebe[j]=t;
	return 0;
}

int sort(Oseba** osebe, int n) {
	int r=1;
	for(int i=1; i<n; i++) {
		r=r && strcmp(osebe[i-1]->ime,osebe[i]->ime)<=0;
	}
	return r;
}

void uredi(Oseba** osebe, int n) {
	while(!sort(osebe,n)) {
		for(int i=1; i<n; i++) {
			if(strcmp(osebe[i]->ime,osebe[i-1]->ime)<0)
				swap(osebe,i-1,i);
		}
	}
}

int main() {
	Oseba * osebe[]={&(Oseba){.ime="Bojan",.starost=30},
		        &(Oseba){.ime="Ana",.starost=25},
			&(Oseba){.ime="Bojan",.starost=40},
			&(Oseba){.ime="Cene",.starost=15},
			&(Oseba){.ime="Bojan",.starost=20},
			&(Oseba){.ime="Ana",.starost=20}};
	uredi(osebe,6);
	for(int i=0; i<6; i++) {
		printf("{\"%s\", %d}\n",osebe[i]->ime,osebe[i]->starost);
	}
	return 0;
}
