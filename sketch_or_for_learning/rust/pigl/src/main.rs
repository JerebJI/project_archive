fn main() {
    let s = "first apple hay median text".to_string();
    for w in s.split_whitespace() {
		let mut cs=w.chars();
		let f = cs.nth(0).unwrap();
		let b = f=='h' || f=='a' || f=='y';
		if b { print!("{f}"); }
		for c in cs {
			print!("{}",c);
		}
		print!("-{}ay ",if b {'h'}else{f});
	}
    println!("\n{}\n",s);
}
