
public class Test03 {

    public static void main(String[] args) {
        int[][] t = {
            { 31, 76,  9, 97, 13, 27, 91, 35, 42,  6, 64, 59, 87, 33, 35 },
        };

        for (int krog = 0;  krog < 15;  krog++) {
            System.out.println(Druga.najCas(t, krog));
        }
    }
}
