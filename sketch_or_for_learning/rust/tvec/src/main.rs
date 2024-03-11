use std::collections::HashMap;

fn main() {
    let mut v = vec![4,7,3,5,4,5,6,4,3,2,9,8];
    v.sort();
    let mut hm = HashMap::new();
    v.iter().for_each(|x|*hm.entry(x).or_insert(0)+=1);
    println!("{:?}\n{:?}\nMediana: {}\nModus: {}\nPovprecje: {}",
              v,hm,v[v.len()/2],
              hm.iter().max_by(|a,b|a.1.cmp(&b.1)).map(|(k,_v)|k).unwrap(),
              v.iter().sum::<usize>()/v.len() );
}
