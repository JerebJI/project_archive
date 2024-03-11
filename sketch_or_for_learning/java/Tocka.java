public class Tocka {
    private double x;
    private double y;
    public Tocka(double x, double y) {
	this.x=x;
	this.y=y;
    }
    public double vrniX() {
	return x;
    }
    public double vrniY() {
	return y;
    }
    public String toString() {
	return "("+x+", "+y+")";
    }
    public double razdalja(Tocka t) {
	return Math.sqrt(Math.pow((x-t.x),2)+Math.pow((y-t.y),2));
    }
    public static Tocka izhodisce() {
	return new Tocka(0,0);
    }
    public double razdaljaOdIzhodisca() {
	return razdalja(izhodisce());
    }
}
