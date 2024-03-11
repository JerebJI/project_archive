
/*
 * tj.exe
 */

import java.util.*;

public class Cetrta {

    public static void main(String[] args) {
        List<Integer> s = new ArrayList<Integer>();
        s.add(3);
        s.add(2);
        s.add(5);
        s.add(7);
        s.add(9);
        s.add(0);
        System.out.println(razmnozi(s,3));
        for(Iterator<Integer>i=razmnozevalnik(s,3); i.hasNext();)
            System.out.println(i.next());
    }

    public static <T> List<T> razmnozi(List<T> seznam, int n) {
        ArrayList<T> r = new ArrayList<T>();
        for(int i=0; i<seznam.size(); i++) {
            int p=i%n+1;
            for(int j=0; j<p; j++)r.add(seznam.get(i));
        }
        return r;
    }

    public static <T> Iterator<T> razmnozevalnik(List<T> s, int n) {
        class Miter implements Iterator<T> {
            int i=0;
            int j=0;
            public boolean hasNext() {
                return (i<s.size()-1)||(i==s.size()-1 && j<n);
            }
            public T next() {
                int p=i%n+1;
                if(j>=p){
                    j=0;
                    i++;
                }
                j++;
                return s.get(i);
            }
        }
        return new Miter();
    }
}
