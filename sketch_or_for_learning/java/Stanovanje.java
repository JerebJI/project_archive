public class Stanovanje {
	private Oseba[] stanovalci;
	private Stanovanje[] sosed;
	private int stSosedov=0;
	final int L=0,D=1,Z=2,S=3;

	public Stanovanje(Oseba[] stanovalci) {
		this.stanovalci=stanovalci;
	}

	public int steviloStanovalcev() {
		return stanovalci.length;
	}

	public steviloStarejsihOd(Oseba os) {
		int r=0;
		for(Oseba o: stanovalci)
			if(o.jeStarejsaOd(os))
				r++;
		return r;
	}

	public int[] mz() {
		int mz[2]={0,0};
		for(Oseba o: stanovalci)
			switch (o.getSpol()) {
				case 'M': mz[0]++; break;
				case 'Z': mz[1]++; break;
			}
		return mz;
	}

	public Oseba starosta() {
		Oseba r=stanovalci[0];
		for(Oseba o:stanovalci)
			if(o.starejsaOd(r))
				r=o;
		return r;
	}

	public void nastaviSosede(Stanovanje levi, Stanovanje zgornji, Stanovanje desni, Stanovanje spodnji) {
		sosed={levi,desni,zgornji,spodnji};
		int r=0;
		for(Stanovanje s:sosed)
			if (sosed!=null)
				r++;
		stSosedov=r;
	}

	public int getStSosedov() {
		return stSosedov;
	}

	public Oseba starostaSosescine() {
		Oseba r=this.starosta();
		for(Stanovanje s:sosed)
			if (s!=null) {
				Oseba st = s.starosta()
				if(st.jeStarejsaOd(r))
					r=st;
			}
		return r;
	}

	public Stanovanje[] sosedje() {
		return sosed;
	}

	public Oseba sosedjeSosedov() {
		// 2D array sosedov sosedov
		Stanovanje[4][4] ss = new Stanovanje[4][4];
		for(int i=0; i<4; i++)
			if(sosed[i]!=null)
				ss[i]=sosed[i].sosed();
		// izracun stevila sosedov sosedov (pazi null)
		int l=0;
		for(Stanovanje[] sa: ss)
			if (s!=null)
				for(Stanovanje s:sa)
					if(s!=null)
						l+=s.steviloStanovalcev();
		// prepis sosedov sosedov v 1D array
		Oseba[] r = new Oseba[l];
		int ind = 0;
		for(Stanovanje[] sa: ss)
			if (sa!=null)
				for (Stanovanje s: sa)
					if(s!=null)
						for (Oseba o: s.stanovalci)
							r[ind++]=o;
		return r;
	}
}

