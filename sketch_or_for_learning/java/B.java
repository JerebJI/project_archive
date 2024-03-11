public class B extends A {
    public void f(A a){
        System.out.println("B/A");
    }
    public void f(B b) {
        System.out.println("B/B");
    }

    public static void main(String[] args) {
        A a1 = new A();
        A a2 = new B();
        B b = new B();
        a1.f(a1);
        a1.f(a2);
        a1.f(b);
        a2.f(a1);
        a2.f(a2);
        a2.f(b);
        b.f(a1);
        b.f(a2);
        b.f(b);
    }
}
