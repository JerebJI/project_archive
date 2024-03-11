
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class Test02 {

    private static final boolean T = true;
    private static final boolean F = false;

    public static void main(String[] args) {
        List<Cetrta.Celica> celice = new ArrayList<>(Arrays.asList(
            new Cetrta.Celica(0, 2),
            new Cetrta.Celica(2, 1),
            new Cetrta.Celica(1, 0),
            new Cetrta.Celica(1, 2),
            new Cetrta.Celica(6, 5),
            new Cetrta.Celica(3, 5),
            new Cetrta.Celica(5, 0),
            new Cetrta.Celica(3, 1),
            new Cetrta.Celica(4, 6),
            new Cetrta.Celica(6, 0),
            new Cetrta.Celica(0, 4),
            new Cetrta.Celica(6, 1),
            new Cetrta.Celica(1, 4),
            new Cetrta.Celica(4, 0),
            new Cetrta.Celica(2, 4)
        ));
        celice.sort(null);
        System.out.println(celice);
    }
}
