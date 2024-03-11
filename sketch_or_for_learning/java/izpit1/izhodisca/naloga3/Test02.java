
public class Test02 {

    public static void main(String[] args) {
        Tretja.Vodja v000 = new Tretja.Vodja("v000", 9054, null);
        Tretja.Vodja v001 = new Tretja.Vodja("v001", 9057, null);
        Tretja.Vodja v002 = new Tretja.Vodja("v002", 1868, v001);
        Tretja.Vodja v003 = new Tretja.Vodja("v003", 9097, v001);
        Tretja.Vodja v004 = new Tretja.Vodja("v004", 8023, null);
        Tretja.Vodja v005 = new Tretja.Vodja("v005", 1121, v002);
        Tretja.Vodja v006 = new Tretja.Vodja("v006", 7046, v003);
        Tretja.Vodja v007 = new Tretja.Vodja("v007", 6540, v000);
        Tretja.Vodja v008 = new Tretja.Vodja("v008", 6291, v003);
        Tretja.Vodja v009 = new Tretja.Vodja("v009", 9370, null);
        Tretja.Vodja v010 = new Tretja.Vodja("v010", 7101, v006);
        Tretja.Vodja v011 = new Tretja.Vodja("v011", 5811, v002);
        Tretja.Vodja v012 = new Tretja.Vodja("v012", 1346, v011);
        Tretja.Vodja v013 = new Tretja.Vodja("v013", 6849, null);
        Tretja.Vodja v014 = new Tretja.Vodja("v014", 9908, v008);
        Tretja.Vodja v015 = new Tretja.Vodja("v015", 9307, v007);
        Tretja.Vodja v016 = new Tretja.Vodja("v016", 6632, v009);
        Tretja.Vodja v017 = new Tretja.Vodja("v017", 2832, v012);
        Tretja.Vodja v018 = new Tretja.Vodja("v018", 3281, v012);
        Tretja.Vodja v019 = new Tretja.Vodja("v019", 2827, v003);

        Tretja.Delavec d000 = new Tretja.Delavec("d000", 6758, null);
        Tretja.Delavec d001 = new Tretja.Delavec("d001", 6557, v012);
        Tretja.Delavec d002 = new Tretja.Delavec("d002", 8418, v011);
        Tretja.Delavec d003 = new Tretja.Delavec("d003", 1300, v007);
        Tretja.Delavec d004 = new Tretja.Delavec("d004", 9636, v004);
        Tretja.Delavec d005 = new Tretja.Delavec("d005", 9888, v009);
        Tretja.Delavec d006 = new Tretja.Delavec("d006", 7158, v007);
        Tretja.Delavec d007 = new Tretja.Delavec("d007", 5037, null);
        Tretja.Delavec d008 = new Tretja.Delavec("d008", 3634, v016);
        Tretja.Delavec d009 = new Tretja.Delavec("d009", 6298, v008);
        Tretja.Delavec d010 = new Tretja.Delavec("d010", 7936, v008);
        Tretja.Delavec d011 = new Tretja.Delavec("d011", 6223, null);
        Tretja.Delavec d012 = new Tretja.Delavec("d012", 7870, null);
        Tretja.Delavec d013 = new Tretja.Delavec("d013", 4956, null);
        Tretja.Delavec d014 = new Tretja.Delavec("d014", 5986, v000);

        Tretja.Zaposleni[] zaposleni = {
            v000, v001, v002, v003, v004, v005, v006, v007, v008, v009, v010, v011, v012, v013, v014, v015, v016, v017, v018, v019,
            d000, d001, d002, d003, d004, d005, d006, d007, d008, d009, d010, d011, d012, d013, d014
        };

        System.out.println("[ placaNadrejenega ]");
        for (Tretja.Zaposleni z: zaposleni) {
            System.out.printf("%s -> %d%n", z, z.placaNadrejenega());
        }
    }
}
