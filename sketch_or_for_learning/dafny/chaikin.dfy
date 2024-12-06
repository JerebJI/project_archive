function chaikin(k:nat, p:seq<real>) : seq<real>
requires |p|>0
ensures |chaikin(k,p)|>0
{
    if k == 0 then
      p 
    else
      var ch := chaikin(k-1,p);
      seq(|ch|*2,
        j => if j%2==0 then
               0.75*ch[(j/2)%|ch|] + 0.25*ch[(j/2+1)%|ch|]
             else
               0.25*ch[(j/2)%|ch|] + 0.75*ch[(j/2+1)%|ch|]
      )
}

function sum(v : seq<real>) : real {
  if |v| == 0 then
    0.0
  else
    v[0] + sum(v[1..])
}

function dot(v1:seq<real>, v2:seq<real>,i:nat) : real 
requires |v1|==|v2|
{
  sum(seq(|v1|, i => v1[i]*v2[i]))
}

function conv(v1:seq<real>, v2:seq<real>) : seq<real>
{
  seq(|v1|-|v2|, i => dot(v1[i..|v2|],v2))
}

function upsample(v:seq<real>) : seq<real>
requires |v|>0
{
  seq(|v|*2, i => if i%2==0 then v[(i/2)%|v|] else 0.0)
}

function chaikin1(k:nat, p:seq<real>) : seq<real>
requires |p|>0
ensures chaikin(k,p)==chaikin1(k,p)
{
  chaikin(k,p)
}

method Main() {
    print("Hello world!");
    print(dot([1.0,2.0,3.0],[4.0,5.0,6.0]));
    print(upsample([1.0,2.0,3.0]));
    print(chaikin(1,[0.0,1.0]));
    assert chaikin(0,[0.0,1.0])==[0.0,1.0];
    assert |chaikin(1,[0.0,1.0])|==4;
    assert chaikin(1,[0.0,1.0])==[0.25,0.75,0.75,0.25];
}