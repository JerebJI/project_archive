
public class Test25 {

    public static void main(String[] args) {
        int[][] t = {
            { 53, 74, 99, 11, 93, 76, 51, 29, 11 },
            { 69, 30, 70,  6, 11, 26, 93, 46, 64 },
            { 11, 92, 75, 20, 63, 56, 97, 23, 10 },
            { 11, 96, 63, 90, 26, 53, 87, 57, 64 },
            { 47, 27,  9, 64,  4, 69, 30, 79, 50 },
            { 85, 21, 49, 58, 15, 44, 20, 94, 19 },
            { 88, 50, 14, 23, 67, 92, 46, 25, 49 },
            { 49, 28, 71, 10, 19, 79, 20, 30, 83 },
            { 86, 88, 62, 19, 19, 49, 17, 26, 71 },
            { 18,  5, 18, 78, 77, 55, 91, 35, 99 },
            { 23, 18, 69, 12, 77, 89, 40, 22, 49 },
            { 77, 81, 94, 11, 21, 29,  3, 14,  6 },
            { 88, 53, 84, 10, 98, 18, 75, 67, 62 },
            { 81,  8, 85, 15, 12, 73, 27, 30, 99 },
            { 77, 74, 81, 78, 47, 55, 58, 37, 67 },
        };

        for (int krog = 0;  krog < 9;  krog++) {
            System.out.println(Druga.najCas(t, krog));
        }
    }
}
