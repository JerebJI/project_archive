public class Blok {
	private Stanovanje stanovanje;
	public Blok(Stanovanje stanovanje) {
		this.stanovanje=stanovanje;
	}
	public Oseba starosta() {
		return starosta(stanovanje.starosta(),stanovanje);
	}
	public Oseba starosta(star,stan) {
		Oseba st=stan.starosta();
		if (st.jeStarejsaOd(star))star=st;
		for(Stanovanje s:stan.sosedje()) {
			if(s!=null) {
				star=this.starosta(star,s);
			}
		}
		return star;
	}
}
