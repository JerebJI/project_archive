-- odkril sem, da se morda da instalirati knjiznico z apt
-- sudo apt-get install microlens microlens-th

-- 1. instaliraj cabal s .. sudo apt-get install cabal-install
-- 2. refreshaj cabal s .. cabal update
-- 3. instaliraj microlens z .. cabal install --lib microlens microlens-th

-- Kaj je Lens?
-- Lens je getter in setter:
-- namenjen je temu, da sprejme strukturo (ponavadi je record, vendar je lahko karkoli)
-- in jo znotraj spremeni ali pa izvlece ven del nje
-- je sestavljen iz dveh funkcij view in over
-- view: izvlece del strukture
-- over: spremeni del strukture

-- Kaj je Traversal?
-- "Lens", ki del nad vecimi elementi znotraj strukture.
-- namesto view ima toListOf

-- napisi to na zacetek programa
{-# LANGUAGE TemplateHaskell #-} -- zato da lahko uporabis macroje za generiranje Lensov
import Lens.Micro -- knjiznica z Lensi (ne ta glavna, ker je tista zelo velika, zato sem izbral manjso)
import Lens.Micro.TH -- knjiznica, ki generira Lense za recorde

-- za generiranje Lensov rabis imena elementov v recordu predznaciti z '_'
data Atom = Atom { _element :: String, _point :: Point } deriving (Show)
data Point = Point { _x :: Double, _y :: Double } deriving (Show)

-- (z makrojem) ustvaris Lense z
$(makeLenses ''Atom)
$(makeLenses ''Point)

-- funkcija, ki zamakne x za ena
shiftAtomX :: Atom -> Atom
shiftAtomX = over (point . x) (+1)

-- razlaga .. over 'polozaj oz. kaj' 'funkcija' 'record'
--  .. over deluje kakor map prejme funkcijo, polozaj v strukturi in strukturo na katero naj deluje
-- polozaj ima isto ime kot element samo brez '_' in ce zelis dostopati record v recordu dodas piko vmes
-- alternativa over je %~
-- Primer: shiftAtomX = (point.x) %~ (+1)
--     oz. shiftAtomX atom = atom & (point.x) %~ (+1)

data Molecule = Molecule { _atoms :: [Atom] } deriving (Show)
$(makeLenses ''Molecule)

shiftMoleculeX :: Molecule -> Molecule
shiftMoleculeX = over (atoms . traverse . point . x) (+1)
-- s traverse gres lahko cez cel list

-- druge funkcije
-- view .. ven da element iz strukture je 'getter'
-- alternativno lahko za lense uporabis ^.
-- npr.: "atom.point.x" lahko zapises kot atom^.point.x (( atom ^. (point.x) ))
-- za traverse lahko uporabis ^..
-- npr.: molecule ^.. (atoms.traverse.point)

-- set
-- set je poseben primer za over .. nastavi neko vrednost na nekaj
-- alternativa za set je .~
-- Primer: set (point.x) 10 atom
--         atom & (point.x) .~ 10

-- lense lahko podajas drugim funkcijam
-- npr. lahko namesto funkcij shiftAtomX in shiftMoleculeX zdruzis v
shift lens = over lens (+1)

-- in potem naredis
-- shift (point.x) :: Atom -> Atom
-- shift (atoms.traverse.point.x) :: Molecule -> Molecule

-- lahko celo definiras sinonime za sestavljene Lense
atomX :: Lens' Atom Double
atomX = point.x

moleculeX :: Traversal' Molecule Double
moleculeX = atoms.traverse.point.x

-- shift atomX :: Atom -> Atom
-- shift moleculeX :: Molecule -> Molecule

-- ce uporabis traverse namesto view uporabis toListOf (ker delas z vec kot enim elementom)
-- primer: -view moleculeX- NAROBE!!
--         toListOf moleculeX :: Molecule -> [Double]

-- Dodatne uporabne stvari

-- delo s tupli:
-- imas _1,_2,...,_5 (deluje za tuple do velikosti 5): Primer: (1,2,3,4,5) ^. _2 => 2
-- imas both: Primer: (2,3) & both %~ 1 => (3,4)

-- & skoraj isto kot $ samo da: (+1)&show  ==  show$(+1)
-- uporaben, ko hoces nekaj veckrat spremeniti:
-- (1,2,3) & _1 .~ 0
--         & _3 %~ negate


-- -~,+~,*~ kakor +=
-- Primer: atom & (point.x) -~ 1

-- ?~ za Maybe: l ?~ b = l .~ Just b

-- ce hoces kombinirati navadne funkcije z Lensi uporabi 'to': a ^. to f = f a

-- Za (veliko..) vec (vsi primeri so kopirani od tukaj):
-- https://hackage.haskell.org/package/lens-tutorial-1.0.4/docs/Control-Lens-Tutorial.html
-- https://hackage.haskell.org/package/microlens-0.4.12.0/docs/Lens-Micro.html
