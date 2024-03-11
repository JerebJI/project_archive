use rand::Rng;
use std::cmp::Ordering;

const N: [&str;7] = ["c","d","e","f","g","a","b"];
const V: [&str;3] = [",", "", "'"];
const R: [i32; 7] = [0,2,4,5,7,9,11];

#[derive(Debug,PartialEq,Eq,Clone,Copy)]
struct Nota {
	vis: i32,
	ime: i32,
	dol: i32,
}

#[derive(Debug,PartialEq,Eq,Clone,Copy)]
struct Interval {
	razv: i32,
	razi: i32,
}

fn wrap(i: i32,lu: usize) -> usize {
	let l: i32 = i32::try_from(lu).unwrap();
	usize::try_from((i%l+l)%l).unwrap()
}

fn del(i: i32,lu: usize) -> usize {
	let l: i32 = i32::try_from(lu).unwrap();
	usize::try_from(i/l).unwrap()
}

fn to_vis(im: i32) -> i32 {
	(im/7)*12+R[wrap(im,7)]
}

fn spr(n: &Nota) -> String {
	let v: i32 = n.vis-to_vis(n.ime);
    match v.cmp(&0) {
        Ordering::Less    => "es".to_string().repeat(v.abs().try_into().unwrap()),
        Ordering::Greater => "is".to_string().repeat(v.abs().try_into().unwrap()),
        Ordering::Equal   => "".to_string()
    }
}

fn rspr() -> i32 {
    if rand::thread_rng().gen_range(0..=4)==2 {
	    i32::pow(-1,rand::thread_rng().gen_range(0..=1))
    } else {0}
}

impl std::fmt::Display for Nota {
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        write!(f,"{}{}{}{}",N[wrap(self.ime,N.len())],
                            spr(self),
                            V[del(self.ime,7)],
                            self.dol)
    }
}

fn gen_noto(n: Nota) -> Nota {
    let mut n1: Nota;
    let g: Nota = Nota {vis:27, ime:15, dol:4};
    let s: Nota = Nota {vis:4, ime:3, dol:4};
    loop {
		let dv:  i32 = rand::thread_rng().gen_range(-5..=5);
		let ddv: i32 = rspr();
        if dv == 7 && ddv==1 { continue }
        n1 = Nota {
          vis: to_vis(n.ime+dv)+ddv,
          ime: n.ime+dv,
          dol: 4,
        };
        if n1.vis-n.vis == 6 { continue }
        if n1.vis-n1.vis == 6 { continue }
        //println!("{:?}",n1);
        if s.vis<n1.vis && n1.vis<g.vis { break }
        if s.vis == n1.vis { n1.ime=s.ime; break }
        if g.vis == n1.vis { n1.ime=g.ime; break }
    }
    //println!("[{:?} tvis:{}]",n1,to_vis(n1.ime));
    n1
}	

fn main() {
	//println!("{}",Nota {vis:12,ime:6,dol:4});
    print!("{{ \\clef F ");
    let mut n: Nota = Nota {vis:1, ime:0, dol:4};
    for _i in 1..850 {
		n = gen_noto(n);
		print!("{n} ");
	}
    println!("}}");
}
