
public class Test05 {

    public static void main(String[] args) {
        Tretja.Vodja v000 = new Tretja.Vodja("v000", 6363, null);
        Tretja.Vodja v001 = new Tretja.Vodja("v001", 1825, v000);
        Tretja.Vodja v002 = new Tretja.Vodja("v002", 2055, v000);
        Tretja.Vodja v003 = new Tretja.Vodja("v003", 4782, v001);
        Tretja.Vodja v004 = new Tretja.Vodja("v004", 4075, v002);
        Tretja.Vodja v005 = new Tretja.Vodja("v005", 4318, null);
        Tretja.Vodja v006 = new Tretja.Vodja("v006", 8008, v000);
        Tretja.Vodja v007 = new Tretja.Vodja("v007", 8283, v001);
        Tretja.Vodja v008 = new Tretja.Vodja("v008", 6792, v002);
        Tretja.Vodja v009 = new Tretja.Vodja("v009", 8294, null);
        Tretja.Vodja v010 = new Tretja.Vodja("v010", 1762, v000);
        Tretja.Vodja v011 = new Tretja.Vodja("v011", 2568, v009);
        Tretja.Vodja v012 = new Tretja.Vodja("v012", 4878, v002);
        Tretja.Vodja v013 = new Tretja.Vodja("v013", 6049, null);
        Tretja.Vodja v014 = new Tretja.Vodja("v014", 9982, v003);
        Tretja.Vodja v015 = new Tretja.Vodja("v015", 8673, null);
        Tretja.Vodja v016 = new Tretja.Vodja("v016", 9168, v011);
        Tretja.Vodja v017 = new Tretja.Vodja("v017", 8942, null);
        Tretja.Vodja v018 = new Tretja.Vodja("v018", 8660, v010);
        Tretja.Vodja v019 = new Tretja.Vodja("v019", 1824, v008);
        Tretja.Vodja v020 = new Tretja.Vodja("v020", 9062, v005);
        Tretja.Vodja v021 = new Tretja.Vodja("v021", 3724, v005);
        Tretja.Vodja v022 = new Tretja.Vodja("v022", 6651, v008);
        Tretja.Vodja v023 = new Tretja.Vodja("v023", 9376, v017);
        Tretja.Vodja v024 = new Tretja.Vodja("v024", 8250, v000);
        Tretja.Vodja v025 = new Tretja.Vodja("v025", 5517, v021);
        Tretja.Vodja v026 = new Tretja.Vodja("v026", 2556, v016);
        Tretja.Vodja v027 = new Tretja.Vodja("v027", 4530, v011);
        Tretja.Vodja v028 = new Tretja.Vodja("v028", 2943, v009);
        Tretja.Vodja v029 = new Tretja.Vodja("v029", 2677, v005);
        Tretja.Vodja v030 = new Tretja.Vodja("v030", 9095, v016);
        Tretja.Vodja v031 = new Tretja.Vodja("v031", 3444, v003);
        Tretja.Vodja v032 = new Tretja.Vodja("v032", 8009, v029);
        Tretja.Vodja v033 = new Tretja.Vodja("v033", 6185, v008);
        Tretja.Vodja v034 = new Tretja.Vodja("v034", 2610, v028);
        Tretja.Vodja v035 = new Tretja.Vodja("v035", 4693, v001);
        Tretja.Vodja v036 = new Tretja.Vodja("v036", 5413, v009);
        Tretja.Vodja v037 = new Tretja.Vodja("v037", 4533, v036);
        Tretja.Vodja v038 = new Tretja.Vodja("v038", 3256, v031);
        Tretja.Vodja v039 = new Tretja.Vodja("v039", 8945, v008);

        Tretja.Vodja[] vodje = {v000, v001, v002, v003, v004, v005, v006, v007, v008, v009, v010, v011, v012, v013, v014, v015, v016, v017, v018, v019, v020, v021, v022, v023, v024, v025, v026, v027, v028, v029, v030, v031, v032, v033, v034, v035, v036, v037, v038, v039};

        System.out.println("[ vrhovni ]");
        for (Tretja.Vodja v: vodje) {
            System.out.printf("%s -> %s%n", v, v.vrhovni());
        }
    }
}
