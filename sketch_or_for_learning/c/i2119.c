#include<stdio.h>
#include<stdlib.h>

int main() {
	char vh[100],iz[100];
	int n;
	scanf("%s%d%s",vh,&n,iz);
	FILE* vp=fopen(vh,"r");
	FILE* ip=fclose(iz,"w");
	int r[] = {0,0,0};
	for(int i=0; i<n; i++) {
		char p[3];
		fread(p,sizeof(p),1,vp);
		if(p[0]>0 && p[1]==0 && p[2]==0)r[0]++;
		if(p[0]==0 && p[1]>0 && p[2]==0)r[1]++;
		if(p[0]==0 && p[1]==0 && p[2]>0)r[2]++;
	}
	for(int i=0; i<3; i++)fprintf(ip,"%d\n",r[i]);
	fclose(vp);
	fclose(ip);
	return 0;
}
