#include<stdio.h>
#include<stdlib.h>

int b[255][255][255];

int main() {
	char s[21]; scanf("%s",s);
	FILE *fp=fopen(s,"r");
	int w,h;
	fscanf(fp,"P6 %d %d 255",&w,&h);
	for(int i=0; i<h*w; i++) {
		char p[3];
		fread(p,sizeof(p),1,fp);
		b[p[0]][p[1]][p[2]]++;
	}
	int M=-1,stb=0;
	for(int i=0; i<255; i++)
		for(int j=0; j<255; j++)
			for(int k=0; k<255; k++) {
				stb+=b[i][j][k]>0;
				if(b[i][j][k]>M) {
					M=b[i][j][k];
				}
			}
	printf("%d\n%d\n",stb,M);
	return 0;
}
