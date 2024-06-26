import Tocka;
public class Premica {
    private double k;
    private double n;
    public Premica(double k, double n) {
	this.k=k;
	this.n=n;
    }
    public double vrniK() {
	return k;
    }
    public double vrniN() {
	return n;
    }
    public String toString() {
	return String.format("y = %.2f x + %.2f",k,n);
    }
    public Tocka tockaPriX(double x) {
	return new Tocka(x,k*x+n);
    }
    public static Premica skoziTocko(double k, Tocka t) {
	return new Premica(k,t.y-k*t.x);
    }
    public Premica vzporednica(Tocka t) {
	return new Premica(k,t.x-k*t.x);
    }
    public Premica pravokotnica(Tocka t) {
	return new Premica(-1/k,t.x-(-1/k)*t.x);
    }
    public Tocka presecisce(Premica p, double epsilon) {
	if (p.k-k<=epsilon) return null;
	double xp=(p.n-n)/(k-p.k);
	return Tocka(xp,tockaPriX(xp));
    }
    public Tocka projekcija(Tocka t) {
	return presecisce(pravokotnica(t),0.1);
    }
    public double razdalje(Tocka t) {
	return projekcija(t).razdalja(t);
    }
    public double razdaljaOdIzhodisca() {
	return projekcija(izhodisce()).razdalje(izhodisce());
    }
    public double razdalja(double n) {
	Premica q = new Premica(k,n);
	return projekcija(q.tockaPriX(0)).razdalja(q.tockaPriX(0));
    }
}
