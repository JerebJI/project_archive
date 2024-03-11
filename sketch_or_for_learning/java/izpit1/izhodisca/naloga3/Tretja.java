
/*
 * Testiranje:
 *
 * tj.exe
 */

import java.util.*;

public class Tretja {

    public static void main(String[] args) {
        // koda za ro"cno testiranje (po "zelji)
    }

    public static class Zaposleni {
        private String ip;
        private int placa;
        private Vodja nadrejeni;

        public Zaposleni(String ip, int placa, Vodja nadrejeni) {
            this.ip = ip;
            this.placa = placa;
            this.nadrejeni = nadrejeni;
        }

        @Override
        public String toString() {
            return this.ip;
        }

        public int placaNadrejenega() {
            // popravite / dopolnite ...
            return 0;
        }

        public static int steviloAnomalij(Zaposleni[] zaposleni) {
            // popravite / dopolnite ...
            return 0;
        }
    }

    public static class Delavec extends Zaposleni {
        public Delavec(String ip, int placa, Vodja nadrejeni) {
            super(ip, placa, nadrejeni);
        }
    }

    public static class Vodja extends Zaposleni {
        public Vodja(String ip, int placa, Vodja nadrejeni) {
            super(ip, placa, nadrejeni);
        }

        public Vodja vrhovni() {
            // popravite / dopolnite ...
            return null;
        }
    }
}
