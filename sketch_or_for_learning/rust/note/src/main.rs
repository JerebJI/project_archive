use rand::Rng;
use std::cmp::Ordering;

#[derive(PartialEq,Eq,PartialOrd,Ord,Clone,Copy)]
enum Ime { C, D, E, F, G, A, H, N }
//const SI: [Ime; 7] = [Ime::C,Ime::D,Ime::E,Ime::F,Ime::G,Ime::A,Ime::H];
const SN: i32 = 7;

#[derive(PartialEq,Eq,Copy,Clone)]
struct Visina {
    ime: Ime,
    okt: i32,
}

#[derive(PartialEq,Eq,Copy,Clone)]
struct Nota {
    vis: Visina,
    spr: i32,
    dol: i32,
}

impl PartialOrd for Visina {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(&other))
    }
}

impl Ord for Visina {
    fn cmp(&self, other: &Self) -> Ordering {
        let r=self.okt.cmp(&other.okt);
        if r==Ordering::Equal  {
            self.ime.cmp(&other.ime)
        } else {
            r
        }
    }
}

fn add(mut n: Nota, pr: i32) -> Nota {
	n.vis.okt+=pr/SN  ;
	n.vis.ime=Ime::from((i32::from(n.vis.ime)+pr)%SN);
	n
}

impl std::fmt::Display for Ime {
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        let r=match self {
            Ime::A => "a",
            Ime::H => "b",
            Ime::C => "c",
            Ime::D => "d",
            Ime::E => "e",
            Ime::F => "f",
            Ime::G => "g",
            Ime::N => "ERR",
        };
        write!(f,"{}",r)
    }
}

fn spr(n: &Nota) -> String {
    match n.spr.cmp(&0) {
        Ordering::Less    => "es".to_string().repeat(n.spr.abs().try_into().unwrap()),
        Ordering::Greater => "is".to_string().repeat(n.spr.abs().try_into().unwrap()),
        Ordering::Equal   => "".to_string()
    }
}

fn okt(n: &Nota) -> &'static str {
    match n.vis.okt {
        0 => ",",
        1 => "",
        2 => "'",
        _ => "ERROR 'nyi\n",
    }
}

impl std::fmt::Display for Nota {
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        write!(f, "{}{}{}{}", self.vis.ime, spr(self), okt(self), self.dol)
    }
}

impl From<Ime> for i32 {
    fn from(ime: Ime) -> i32 {
        match ime {
            Ime::C => 0,
            Ime::D => 1,
            Ime::E => 2,
            Ime::F => 3,
            Ime::G => 4,
            Ime::A => 5,
            Ime::H => 6,
            Ime::N => -1,
        }
    }
}

impl From<i32> for Ime {
    fn from(ime: i32) -> Ime {
        match ime {
            0 => Ime::C,
            1 => Ime::D,
            2 => Ime::E,
            3 => Ime::F,
            4 => Ime::G,
            5 => Ime::A,
            6 => Ime::H,
            _ => Ime::N,
        }
    }
}

impl std::ops::Sub for Ime {
    type Output = i32;
    fn sub(self, other: Ime) -> Self::Output {
        i32::from(self)-i32::from(other)
    }
}

impl std::ops::Sub for Visina {
    type Output = i32;
    fn sub(self, other: Visina) -> Self::Output {
        ((self.okt-other.okt) as i32)+(self.ime-other.ime)
    }
}

fn rspr() -> i32 {
    if rand::thread_rng().gen_range(0..=4)==2 {
	    i32::pow(-1,rand::thread_rng().gen_range(0..=1))
    } else {0}
}

fn gen_noto(n: Nota) -> Nota {
    let mut n1: Nota;
    let g: Nota = Nota {vis: Visina {ime: Ime::D, okt: 2}, spr: 0, dol: 4};
    let s: Nota = Nota {vis: Visina {ime: Ime::E, okt: 0}, spr: 0, dol: 4};
    loop {
        n1 = Nota {
          vis: add(n,rand::thread_rng().gen_range(-8..=8)).vis,
          spr: rspr(),
          dol: 4,
        };
        //println!("[{} s:{} g:{}]",n1,s,g);
        if n1.vis.ime!=Ime::N && s.vis <= n1.vis && n1.vis <= g.vis { break }
    }
    n1
}

// POZOR !! SLABA KODA (NOTA NE USTREZA, LAHKO BI NOTO PREDSTAVIL S TREMI i32 (NE BI RABIL VISINA)...) POVSOD
fn main() {
	//println!("{}",Visina{ime: Ime::E, okt: 0}<=Visina{ime: Ime::H, okt: 1});
    print!("{{ \\clef F ");
    let mut n: Nota = Nota {vis: Visina {ime: Ime::C, okt:1}, spr: 0, dol: 8};
    for _i in 1..800 {
        n=gen_noto(n);
        print!("{} ",n);
    }
    print!("}}");
}
