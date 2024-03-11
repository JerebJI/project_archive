
public class Test06 {

    public static void main(String[] args) {
        int[][] t = {
            { 5, 3, 4, 7 },
            { 2, 6, 5, 8 },
            { 1, 4, 2, 5 },
            { 8, 6, 5, 5 },
            { 4, 3, 5, 6 },
        };

        int[][] kumulativa = Druga.kumulativa(t);

        for (int i = 0;  i < kumulativa.length;  i++) {
            for (int j = 0;  j < kumulativa[i].length;  j++) {
                System.out.printf("%3d", kumulativa[i][j]);
            }
            System.out.println();
        }
    }
}
