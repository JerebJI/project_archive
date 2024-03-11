
public class Test07 {

    public static void main(String[] args) {
        int[][] t = {
            { 4, 2, 2, 4, 5, 6, 1 },
            { 8, 8, 5, 5, 6, 4, 9 },
            { 4, 1, 4, 5, 8, 1, 7 },
            { 4, 8, 2, 7, 6, 9, 2 },
            { 8, 7, 3, 9, 8, 5, 7 },
            { 4, 9, 4, 5, 7, 7, 9 },
            { 2, 4, 9, 9, 4, 4, 1 },
            { 6, 5, 2, 6, 9, 8, 2 },
            { 3, 8, 5, 8, 3, 2, 9 },
            { 2, 1, 4, 4, 3, 8, 9 },
        };

        int[][] kumulativa = Druga.kumulativa(t);
        for (int i = 0;  i < 10;  i++) {
            for (int j = 0;  j < 7;  j++) {
                System.out.printf("%3d ", kumulativa[i][j]);
            }
            System.out.println();
        }

    }
}
