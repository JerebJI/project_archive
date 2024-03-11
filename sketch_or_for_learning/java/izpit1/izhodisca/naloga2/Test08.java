
public class Test08 {

    public static void main(String[] args) {
        int[][] t = {
            { 31, 76,  9, 97, 13, 27, 91, 35, 42,  6, 64, 59, 87, 33, 35 },
        };

        int[][] kumulativa = Druga.kumulativa(t);
        for (int i = 0;  i < 1;  i++) {
            for (int j = 0;  j < 15;  j++) {
                System.out.printf("%4d ", kumulativa[i][j]);
            }
            System.out.println();
        }

    }
}
