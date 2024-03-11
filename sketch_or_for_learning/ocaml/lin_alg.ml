open Graphics
#load "unix.cma"

let ps = 7
let rs = 5

let ris size = function
               | (x,y) -> draw_circle x y size

let rec loop () = loop ()

let novi_p i pp pr =
  match pp, pr with
  | (px,py), (rx,ry) -> (px+(rx-px)/i,py+(ry-py)/i)

let rec p pp pr i =
  match pp, pr with
  | (x,y), [] -> set_color red; ris ps (x,y); set_color green; fill_circle x y rs
  | (px,py), ((x,y) :: t) -> draw_segments [|(px,py,x,y)|];
                             set_color red; ris ps pp;
                             set_color black; ris rs (x,y) ;
                             Unix.sleep 1 ;
                           p (novi_p i pp (x,y)) t (i+1)

let povpr_tock = function
  | h :: t -> ris rs h ; p h t 2

let main =
  open_graph " 500x500"; set_color black;
  povpr_tock [(120,230); (240,140); (150,350); (130,190)] ;
  loop ()
