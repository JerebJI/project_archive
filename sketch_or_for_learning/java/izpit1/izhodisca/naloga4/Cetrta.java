
/*
 * Testiranje:
 *
 * tj.exe
 */

import java.util.*;

public class Cetrta {

    public static void main(String[] args) {
        // koda za ro"cno testiranje (po "zelji)
    }

    public static class Celica implements Comparable<Celica> {
        private int vrstica;
        private int stolpec;

        public Celica(int vrstica, int stolpec) {
            this.vrstica = vrstica;
            this.stolpec = stolpec;
        }

        @Override
        public String toString() {
            return String.format("(%d, %d)", this.vrstica, this.stolpec);
        }

        public int compareTo(Celica c) {
            return ((this.vrstica==c.vrstica)?(stolpec-c.stolpec):vrstica-c.vrstica);
        }
    }

    public static class Ovojnik implements Iterable<Celica> {
        private boolean[][] tabela;

        public Ovojnik(boolean[][] tabela) {
            this.tabela = tabela;
        }

        private TreeSet<Celica> vse() {
            int vis=tabela.length;
            int sir=tabela[0].length;
            TreeSet<Celica> r=new TreeSet<Celica>();
            for(int i=0; i<vis;i++)
                for(int j=0; j<sir; j++)
                    r.add(new Celica(i,j));
            return r;
        }

        public NavigableSet<Celica> enice() {
            int vis=tabela.length;
            int sir=tabela[0].length;
            class Manh implements Comparator<Celica> {
                private int manh(Celica c){
                    return Math.abs(c.vrstica-vis/2)+Math.abs(c.stolpec-sir/2);
                }
                public int compare(Celica t, Celica c) {
                    return (manh(t)==manh(c))?(t.compareTo(c)):manh(t)-manh(c);
                }
            }
            TreeSet<Celica> v=vse();
            TreeSet<Celica> r = new TreeSet<Celica>(new Manh());
            r.addAll(v);
            return r;
        }

        public Iterator<Celica> iterator() {
            return vse().iterator();
        }
    }
}
