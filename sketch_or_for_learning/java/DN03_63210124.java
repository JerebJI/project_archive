import java.util.Scanner;
public class DN03_63210124 {
    private static long plosc(long h, long w, long k) {
	long v = (int)Math.pow(2,k);
	long kh = h / v;
	long kw = w / v;
	long st = kh * kw;
	if ((st==0 && k==0)||k==0) {
	    return st;
	} else {
	    return st + plosc(h%v, w, k-1) + plosc(h-h%v, w%v, k-1);
	}
    }
    public static void main(String[] args) {
	Scanner sc = new Scanner(System.in);
	long h = sc.nextInt();
	long w = sc.nextInt();
	long k = sc.nextInt();
	System.out.println(plosc(h,w,k));
    }
}
