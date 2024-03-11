
/*
 * tj.exe
 */

/*
 * Razli"cni objekti tipa Oseba, Cilj oz. Nocitev predstavljajo razli"cne
 * osebe, cilje oz. no"citve.
 */

import java.util.*;

public class Tretja {

    public static void main(String[] args) {
        // koda za ro"cno testiranje (po "zelji)
    }

    //=========================================================================
    public static class Oseba {
        private String ip;
        private String drzava;

        public Oseba(String ip, String drzava) {
            this.ip = ip;
            this.drzava = drzava;
        }
    }

    //=========================================================================
    public static class Cilj {
        private String kraj;
        private String drzava;

        public Cilj(String kraj, String drzava) {
            this.kraj = kraj;
            this.drzava = drzava;
        }
    }

    //=========================================================================
    public static class Nocitev {
        private Oseba oseba;
        private Cilj cilj;
        private int leto;

        public Nocitev(Oseba oseba, Cilj cilj, int leto) {
            this.oseba = oseba;
            this.cilj = cilj;
            this.leto = leto;
        }
    }

    //=========================================================================
    public static int notranje(Nocitev[] nocitve) {
        // popravite / dopolnite ...
        return 0;
    }

    //=========================================================================
    public static boolean jeZvesta(Nocitev[] nocitve, Oseba oseba) {
        // popravite / dopolnite ...
        return false;
    }

    //=========================================================================
    public static int[][] obiskanost(Nocitev[] nocitve, Cilj[] cilji,
                                     int minLeto, int maxLeto) {
        // popravite / dopolnite ...
        return null;
    }
}
