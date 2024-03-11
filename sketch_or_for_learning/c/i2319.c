#include<stdlib.h>
#include<stdio.h>
#include<string.h>
#include<stdbool.h>

char a[30][30][5];
int ind=0;
char pot[100];
int resi(int x, int y, int odkje) {
	pot[ind]=0;
	bool je=false;
	if(a[y][x][0]=='0' && 0!=odkje) {
		pot[ind++]='0';
		resi(x-1,y,2);
		je=true;
	}
	if(a[y][x][1]=='0' && 1!=odkje) {
		pot[ind++]='1';
		resi(x,y-1,3);
		je=true;
	}
	if(a[y][x][2]=='0' && 2!=odkje) {
		pot[ind++]='2';
		resi(x+1,y,0);
		je=true;
	}
	if(a[y][x][3]=='0' && 3!=odkje) {
		pot[ind++]='3';
		resi(x,y+1,1);
		je=true;
	}
	if(!je) {
		ind--;
	}
	return 0;
}

int main() {
	int m,n; scanf("%d%d",&m,&n);
	for(int y=0; y<m; y++)
		for(int x=0; x<n; x++)
			scanf("%s",a[y][x]);
	resi(0,0,0);
	printf("%s\n",pot);
	return 0;
}
