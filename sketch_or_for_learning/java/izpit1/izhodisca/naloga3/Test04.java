
public class Test04 {

    public static void main(String[] args) {
        Tretja.Vodja suzana = new Tretja.Vodja("Suzana", 5000, null);
        Tretja.Vodja stane  = new Tretja.Vodja("Stane",  4000, suzana);
        Tretja.Vodja sonja  = new Tretja.Vodja("Sonja",  3000, stane);
        Tretja.Vodja simon  = new Tretja.Vodja("Simon",  3500, null);
        Tretja.Vodja sanja  = new Tretja.Vodja("Sanja",  6000, simon);
        Tretja.Vodja sandra = new Tretja.Vodja("Sandra", 4500, sonja);

        Tretja.Vodja[] vodje = {sandra, sanja, simon, sonja, suzana, stane};

        System.out.println("[ vrhovni ]");
        for (Tretja.Vodja v: vodje) {
            System.out.printf("%s -> %s%n", v, v.vrhovni());
        }
    }
}
