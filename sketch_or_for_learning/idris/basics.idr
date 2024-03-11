module Basics

%access public export

namespace Days
  data Day = Monday | Tuesday | Wednesday | Thursday | Friday | Saturday | Sunday
  %name Day day, day1, day2

  nextWeekday : Day -> Day
  nextWeekday Monday = Tuesday
  nextWeekday Tuesday = Wednesday
  nextWeekday Wednesday = Thursday
  nextWeekday Thursday = Friday
  nextWeekday Friday = Monday
  nextWeekday Saturday = Monday
  nextWeekday Sunday = Monday

  testNextWeekday : (nextWeekday (nextWeekday Saturday)) = Tuesday
  testNextWeekday = Refl

namespace Booleans
  data Mbool = T | F
  not : Mbool -> Mbool
  not T = F
  not F = T
  andb : (b1 : Mbool) -> (b2:Mbool) -> Mbool
  andb T T = T
  andb T F = F
  andb F T = F
  andb F F = F
  orb : (b1 : Mbool) -> (b2:Mbool) -> Mbool
  orb T T = T
  orb T F = T
  orb F T = T
  orb F F = F
  tOrb1 : (orb T T) = T
  tOrb1 = Refl
  -- ...
  infixl 4 /\, \/
  (/\) : Mbool -> Mbool -> Mbool
  (/\) = andb
  (\/) : Mbool -> Mbool -> Mbool
  (\/) = orb
  torb2 : F \/ F \/ T = T
  torb2 = Refl

namespace Numbers
  data Nar : Type where
    P : Nar
    N : Nar -> Nar
  pred : (n:Nar) -> Nar
  pred P     = P
  pred (N x) = x
  minusTwo : (n:Nar) -> Nar
  minusTwo P         = P
  minusTwo (N x)     = P
  minusTwo (N (N x)) = x
