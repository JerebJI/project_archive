datatype Partial<T> = Undef | Def (value : T)

function chaikin(p:nat->Partial<real>, k:nat, j:nat) : Partial<real> {
    if k==0 then
        p(j)
    else 
        if j%2==0 then
            match (chaikin(p,k-1,j/2),chaikin(p,k-1,j/2+1)) {
                case (Def(a),Def(b)) => Def(0.75*a + 0.25*b)
                case _ => Undef
            }
        else
            match (chaikin(p,k-1,(j-1)/2),chaikin(p,k-1,(j-1)/2+1)) {
                case (Def(a),Def(b)) => Def(0.25*a + 0.75*b)
                case _ => Undef
            }
}

function tp(n:nat) : Partial<real> {
    match n {
        case 0 => Def(0.0)
        case 1 => Def(1.0)
        case 2 => Def(0.0)
        case 3 => Def(0.0)
        case _ => Undef
    }
}

lemma testTp() {
    assert chaikin(tp,1,0)==Def(0.25);
    assert chaikin(tp,1,1)==Def(0.75);
    assert chaikin(tp,1,2)==Def(0.75);
    assert chaikin(tp,1,3)==Def(0.25);
    assert chaikin(tp,1,4)==Def(0.0);
    assert chaikin(tp,1,5)==Def(0.0);
    assert chaikin(tp,1,6)==Undef;
}

function conv(u:nat->Partial<real>, v:nat->Partial<real>,
            Du:seq<nat>, Dv:set<nat>, k:nat) : Partial<real> {
    var j := Du[0];
    match v(k-j+1) {
            case Def(vr) => Def(u(j).value*vr)
            case _ => Undef
    }
}

function chaikp(n:nat) : Partial<real> {
    match n {
        case 0 => Def(0.25)
        case 1 => Def(0.75)
        case 2 => Def(0.75)
        case 3 => Def(0.25)
        case _ => Undef
    }
}

lemma Enakost(p:nat->Partial<real>, Dp:set<nat>, j:nat)
requires forall e:nat :: e in Dp <==> p(e)!=Undef  
ensures conv(p,chaikp,Dp,{0,1,2,3},j)==chaikin(p,1,j)

method Main() {
    
}