
public class Test04 {

    private static final boolean T = true;
    private static final boolean F = false;

    public static void main(String[] args) {
        Cetrta.Ovojnik ovojnik = new Cetrta.Ovojnik(new boolean[][]{
            {F, F, T},
            {T, T, F},
            {T, T, F},
        });
        System.out.println(ovojnik.enice());
   }
}
