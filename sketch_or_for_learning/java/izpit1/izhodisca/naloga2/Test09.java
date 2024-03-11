
public class Test09 {

    public static void main(String[] args) {
        int[][] t = {
            { 247 },
            { 798 },
            { 605 },
            { 866 },
            {  66 },
            { 774 },
            { 883 },
            { 101 },
            { 211 },
            { 728 },
            { 274 },
            { 946 },
            { 916 },
            { 331 },
            {  41 },
            { 511 },
            { 467 },
            { 695 },
            { 258 },
            { 277 },
        };

        int[][] kumulativa = Druga.kumulativa(t);
        for (int i = 0;  i < 20;  i++) {
            for (int j = 0;  j < 1;  j++) {
                System.out.printf("%5d ", kumulativa[i][j]);
            }
            System.out.println();
        }

    }
}
