import java.util.Scanner;
import java.util.Arrays;
public class DN04_63210124 {
    public static void main(String[] args) {
	Scanner sc = new Scanner(System.in);
	int n = sc.nextInt();
	int k = sc.nextInt();
	int l = k+1;
	int a[] = new int[l];
	for (int i=0; i<n; i++)
	    a[sc.nextInt()]++;
	int r=0;
	for (int i=0; i<=k; i++)
	    r+=a[i]*a[k-i];
	System.out.println(r);
    }
}
		
