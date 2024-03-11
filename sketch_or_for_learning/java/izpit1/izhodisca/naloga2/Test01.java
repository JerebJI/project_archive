
public class Test01 {

    public static void main(String[] args) {
        int[][] t = {
            { 5, 3, 4, 7 },
            { 2, 6, 5, 8 },
            { 1, 4, 2, 5 },
            { 8, 6, 5, 5 },
            { 4, 3, 5, 6 },
        };

        System.out.println(Druga.najCas(t, 0));
        System.out.println(Druga.najCas(t, 1));
        System.out.println(Druga.najCas(t, 2));
        System.out.println(Druga.najCas(t, 3));
    }
}
