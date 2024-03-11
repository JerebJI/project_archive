#include<stdio.h>

void odstraniDuplikate(FILE* vhod, FILE* izhod) {
	for(char c,p=0; fscanf(vhod,"%c",&c)==1;) {
		if(!(c==p && (('A'<=c && c<='Z') || ('a'<=c && c<='z'))))fprintf(izhod,"%c",c);
		p=c;
	}
}

int main(int argc, char *argv[]) {
	FILE* fv = fopen(argv[1],"r");
	FILE* fi = fopen(argv[2],"w");

	odstraniDuplikate(fv,fi);

	fclose(fv);
	fclose(fi);

	return 0;
}
