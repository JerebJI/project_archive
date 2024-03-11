#include<stdio.h>

char buf[1001][1001];

void obrni(FILE* vhod,FILE* izhod) {
	int i;
	for(i=0; fscanf(vhod, "%[^\n]s", buf[i])==1; i++){
		fgetc(vhod);
	}
	for(;i>=0;i--)fprintf(izhod,"%s\n",buf[i]);
}

int main(int argc, char *argv[]) {
	FILE *fv=fopen(argv[1],"r");
	FILE *fi=fopen(argv[2],"w");
	
	obrni(fv,fi);
	
	fclose(fv);
	fclose(fi);
	return 0;
}
