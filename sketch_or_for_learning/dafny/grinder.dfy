// moral sem dopolniti primer iz knjige...
// lahko se izogneš nekaj kode, če implementiraš podrazrede
// in tam specificiraš "ohranjanje" Repr množice

class Grinder {
  var HasBeans: bool
  ghost var Repr: set<object>
  ghost predicate Valid()
    reads this, Repr
  constructor ()
    ensures Valid() && fresh(Repr)
  method AddBeans()
    requires Valid()
    modifies Repr
    ensures Valid() && fresh(Repr - old(Repr)) && HasBeans
  method Grind()
    requires Valid() && HasBeans
    modifies Repr
    ensures Valid() && fresh(Repr - old(Repr))
}

class WaterTank {
  var Level: nat
  ghost var Repr: set<object>
  ghost predicate Valid()
    reads this, Repr
  constructor ()
    ensures Valid() && fresh(Repr)
  method Fill()
    requires Valid()
    modifies Repr
    ensures Valid() && fresh(Repr - old(Repr)) && Level == 10
  method Use()
    requires Valid() && Level != 0
    modifies Repr
    ensures Valid() && fresh(Repr - old(Repr)) &&
      Level == old(Level) - 1
}

class Cup {
  constructor ()
}

class CoffeeMaker {
  ghost var Repr: set<object>
  var g: Grinder
  var w: WaterTank
  ghost predicate Valid()
    reads this, Repr
    ensures Valid() ==> this in Repr
  {
    this in Repr &&
    g in Repr && g.Repr <= Repr && this !in g.Repr && g.Valid() &&
    w in Repr && w.Repr <= Repr && this !in w.Repr && w.Valid() &&
    ({g}+g.Repr) !! ({w}+w.Repr)
  }
  constructor ()
    ensures Valid()
    ensures fresh(Repr)
  {
    g := new Grinder();
    w := new WaterTank();
    new;
    Repr := {this,g,w} + g.Repr + w.Repr;
  }
  predicate Ready()
    requires Valid()
    reads Repr
  {
    g.HasBeans && 2<=w.Level
  }
  method Restock()
    requires Valid()
    modifies Repr
    ensures Valid() && fresh(Repr - old(Repr)) && Ready()
  {
    g.AddBeans();
    w.Fill();
    Repr := Repr + g.Repr + w.Repr;
  }
  method Dispense(double: bool) returns (c: Cup)
    requires Valid() && Ready()
    modifies Repr
    ensures Valid()
    ensures fresh(Repr - old(Repr))
  {
    g.Grind();
    if double {
        w.Use(); w.Use();
    } else {
        w.Use();
    }
    c := new Cup();
    Repr := Repr+{g}+g.Repr+{w}+w.Repr;
  }
  method ChangeGrinder()
    requires Valid()
    modifies Repr
    ensures Valid() && fresh(Repr - old(Repr))
  {
    g := new Grinder();
    Repr := Repr + {g} + g.Repr;
  }
  method InstallCustomGrinder(grinder: Grinder)
    requires Valid() && grinder.Valid()
    requires ({grinder}+grinder.Repr)!!({g}+g.Repr)!!({w}+w.Repr)
    requires this !in grinder.Repr
    modifies Repr
    ensures Valid()
    ensures fresh(Repr - old(Repr) - {grinder} - grinder.Repr)
  {
    g := grinder;
    Repr := Repr + {g} + g.Repr;
  }
  method RemoveGrinder() returns (g1:Grinder)
    requires Valid()
    modifies Repr
    ensures Valid()
    ensures fresh(Repr - old(Repr))
    ensures g1.Valid()
    ensures ({g1}+g1.Repr) <= old(Repr)-Repr
  {
    g1 := this.g;
    g := new Grinder();
    Repr := (Repr+{g}+g.Repr+{w}+w.Repr)-{g1}-g1.Repr;
  }
}

method CoffeeTestHarness() {
  var cm := new CoffeeMaker();
  cm.Restock(); // modifies clause violated
  var c := cm.Dispense(true); // modifies clause violated
}

method RemoveGrinderHarness() {
  var cm := new CoffeeMaker();
  var grinder := cm.RemoveGrinder();
  cm.Restock();
  grinder.AddBeans();
}