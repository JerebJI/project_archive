
public class Test08 {

    public static void main(String[] args) {
        Tretja.Vodja v000 = new Tretja.Vodja("v000", 9417, null);
        Tretja.Vodja v001 = new Tretja.Vodja("v001", 1688, v000);
        Tretja.Vodja v002 = new Tretja.Vodja("v002", 3523, null);
        Tretja.Vodja v003 = new Tretja.Vodja("v003", 4992, v001);
        Tretja.Vodja v004 = new Tretja.Vodja("v004", 9482, v002);
        Tretja.Vodja v005 = new Tretja.Vodja("v005", 4923, v000);
        Tretja.Vodja v006 = new Tretja.Vodja("v006", 1811, v002);
        Tretja.Vodja v007 = new Tretja.Vodja("v007", 9164, v002);
        Tretja.Vodja v008 = new Tretja.Vodja("v008", 9161, v000);
        Tretja.Vodja v009 = new Tretja.Vodja("v009", 7348, v006);

        Tretja.Delavec d000 = new Tretja.Delavec("d000", 6371, v008);
        Tretja.Delavec d001 = new Tretja.Delavec("d001", 5433, v004);
        Tretja.Delavec d002 = new Tretja.Delavec("d002", 1614, v008);
        Tretja.Delavec d003 = new Tretja.Delavec("d003", 9939, v002);
        Tretja.Delavec d004 = new Tretja.Delavec("d004", 5195, null);
        Tretja.Delavec d005 = new Tretja.Delavec("d005", 2002, v000);
        Tretja.Delavec d006 = new Tretja.Delavec("d006", 4644, null);

        Tretja.Zaposleni[] zaposleni = {v009, v002, v007, d002, d004, v003, d001, v001, d003, v004, d005, v005, v006, v008, d006, d000, v000};

        System.out.printf("steviloAnomalij = %d%n", Tretja.Zaposleni.steviloAnomalij(zaposleni));
    }
}
