import java.util.Scanner;
public class DN02_63210124 {
    public static int rx(int d,int t) {return t;}
    public static int ry(int d,int t) {return 0;}
    public static int kx(int d,int t) {return t%d;}
    public static int ky(int d,int t) {return t/d;}
    public static int px(int d,int t) {
	int r=0,v=1,g=0;
	for(; r<d&&t>g; r++,v+=2,g+=v);
	return t-(g-(v/2));
    }
    public static int py(int d,int t) {
	int r=0,v=1,g=0;
	for(; r<d&&t>g; r++,v+=2,g+=v);
	return r;
    }
    public static int sx(int d,int t) {
	int r=1,k=0,b=0,x=0;
	for(; t>=r*r; r+=2);r-=2;
	for(; t>=r*r+(r+1)*k; k++);
	if(t!=0){
	    switch (k) {
	      case 1: x=t-(r*r+(r+2)/2);         break;
              case 2: x=r/2+1;                   break;
	      case 3: x=(r*r+(r+1)*3)-(r+2)/2-t; break;
              case 4: x=-r/2-1;                  break;
	    }
	} else x=0;
	return x;
    }
    public static int sy(int d,int t) {
	int r=1,k=0,b=0,y=0;
	for(; t>=r*r; r+=2);r-=2;
	for(; t>=r*r+(r+1)*k; k++);
	if(t!=0){
	    switch (k) {
	      case 1: y=r/2+1;                   break;
              case 2: y=(r*r+(r+1)+(r+2)/2)-t;   break;
	      case 3: y=-r/2-1;                  break;
              case 4: y=t-((r+2)*(r+2))+(r+2)/2; break;
	    }
	} else y=0;
	return y;
    }
    public static int dolzina(int d, int t, int t1, int t2) {
	int x1=0,x2=0,y1=0,y2=0;
	if(t==1){x1=rx(d,t1); y1=ry(d,t1); x2=rx(d,t2); y2=ry(d,t2);}
	if(t==2){x1=kx(d,t1); y1=ky(d,t1); x2=kx(d,t2); y2=ky(d,t2);}
	if(t==3){x1=px(d,t1); y1=py(d,t1); x2=px(d,t2); y2=py(d,t2);}
	if(t==4){x1=sx(d,t1); y1=sy(d,t1); x2=sx(d,t2); y2=sy(d,t2);}
	return Math.abs(x1-x2)+Math.abs(y1-y2);
    }
    public static void main(String[] args) {
	Scanner sc = new Scanner(System.in);
	int b = sc.nextInt();
	int d = sc.nextInt();
	int n = sc.nextInt();
	int t,tp,r=0;
	tp=sc.nextInt();
	for(int i=1; i<n; i++,tp=t) {
	    t=sc.nextInt();
	    r+=dolzina(d,b,tp,t);
	}
	System.out.println(r);
    }
}
