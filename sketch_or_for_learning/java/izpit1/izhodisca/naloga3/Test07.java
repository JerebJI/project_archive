
public class Test07 {

    public static void main(String[] args) {
        Tretja.Vodja suzana = new Tretja.Vodja("Suzana", 5000, null);
        Tretja.Vodja stane  = new Tretja.Vodja("Stane",  4000, suzana);
        Tretja.Vodja sonja  = new Tretja.Vodja("Sonja",  3000, stane);
        Tretja.Vodja simon  = new Tretja.Vodja("Simon",  3500, null);
        Tretja.Vodja sanja  = new Tretja.Vodja("Sanja",  6000, simon);
        Tretja.Vodja sandra = new Tretja.Vodja("Sandra", 4500, sonja);

        Tretja.Delavec drago  = new Tretja.Delavec("Drago",  3500, null);
        Tretja.Delavec doris  = new Tretja.Delavec("Doris",  5000, sanja);
        Tretja.Delavec ditka  = new Tretja.Delavec("Ditka",  3000, simon);
        Tretja.Delavec dijana = new Tretja.Delavec("Dijana", 2000, sandra);
        Tretja.Delavec denis  = new Tretja.Delavec("Denis",  3600, stane);
        Tretja.Delavec dejan  = new Tretja.Delavec("Dejan",  2500, sonja);

        Tretja.Zaposleni[] zaposleni = {
            dejan, denis, dijana, ditka, doris, drago,
            sandra, sanja, simon, sonja, suzana, stane
        };

        System.out.printf("steviloAnomalij = %d%n",
                Tretja.Zaposleni.steviloAnomalij(zaposleni));
    }
}
