
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class Test01 {

    private static final boolean T = true;
    private static final boolean F = false;

    public static void main(String[] args) {
        List<Cetrta.Celica> celice = new ArrayList<>(Arrays.asList(
            new Cetrta.Celica(3, 5),
            new Cetrta.Celica(2, 8),
            new Cetrta.Celica(3, 7),
            new Cetrta.Celica(2, 1),
            new Cetrta.Celica(2, 9)
        ));
        celice.sort(null);
        System.out.println(celice);
    }
}
