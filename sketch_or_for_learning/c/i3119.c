#include<stdio.h>
#include<stdlib.h>

int main() {
	char in[100]; scanf("%s",in);
	int n; scanf("%d",&n);
	char iz[100]; scanf("%s",iz);
	FILE* vf = fopen(in,"r");
	FILE* of = fopen(iz,"w");
	for(int i=0; i<n; i++) {
		char c;
		fscanf(vf,"%c",&c);
		fprintf(of,"%02X\n",c);
	}
	fclose(vf);
	fclose(of);
	return 0;
}
