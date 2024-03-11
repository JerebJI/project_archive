#include<stdio.h>
#include<string.h>
#include<stdlib.h>

char res[100][100],ind,t[100];
int pos[13];

int abs(int x){return (x<0)?-x:x;}

bool napadena(int pos[],int n,int k){
  for (int i=0; i<n; i++) if (pos[i]==k) return true;
  for (int i=0; i<n; i++) if (abs(pos[i]-pos[k])==abs(i-k)) return true;
  return false;
}

int main() {
  int n;
  scanf("%d",&n);
  bool gre=true;
  while (gre) {
    for(int i=0; i<n && gre; i++) {
      while (napadena(pos,n,i) || pos[i]>=n) pos[i]++;
      if (pos[i]>=n) {
	if (pos[i]==0) {
	  i--;
	  gre=(i>=0);
	} else {
	  pos[i]--;
	}
      }
    }
    for(int i=0; i<n && gre; i++){
      strcpy(t,res[i]);
      sprintf(res[i],"%s%x",t,pos[i]);
    }
    ind++;
  }
  qsort(res,ind,sizeof(char)*100,(int(*)(const void*, const void*))*strcmp);
  for(int i=0;i<ind;i++)printf("%d. %s\n",i,res[i]);
  return 0;
}
