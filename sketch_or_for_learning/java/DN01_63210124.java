// r:{+/{(x-z)*y-z}[x;y]'1_!x&y}
import java.util.Scanner;
public class DN01_63210124 {
    public static void main(String[] args) {
	Scanner sc = new Scanner(System.in);
	int a = sc.nextInt();
	int b = sc.nextInt();
	int r = 0;
	for(int i=Math.min(a,b)-1; i>0; i--) r+=(a-i)*(b-i);
	System.out.println(r);
    }
}
