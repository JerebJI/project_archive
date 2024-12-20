let rec last = function
  | [] -> None
  | [x] -> Some x
  | _::y -> last y

let rec last_two = function
  | [] | [_] -> None
  | [x; y] -> Some (x,y)
  | _ :: x -> last_two x

let rec at x y =
  match x, y with
  | 1, h :: _ -> Some h
  | _, [] -> None
  | _, _ :: t -> at ( x - 1 ) t

let rec length = function
  | [] -> 0
  | _ :: t -> 1 + length t

let rec tlen x y =
  match x, y with
  | x, [] -> x
  | x, _ :: t -> tlen ( x + 1 ) t

let rec tlength = tlen 0

let rec tlength' =
  let rec aux n = function
    | [] -> n
    | _ :: t -> aux (n + 1) t
  in aux 0

let rec rev = function
  | [] -> []
  | [x] -> [x]
  | h :: t -> (rev t) @ [h]

let rec rev' =
  let rec f x = function
    | [] -> x
    | h :: t -> f (h :: x) t
  in f []

let is_palindrome x = x = (rev' x)

type 'a node =
  | One of 'a
  | Many of 'a node list

let flatten x =
  let rec flat l = function
    | [] -> l
    | One x :: t -> flat (x :: l) t
    | Many x :: t -> flat (flat l x) t
  in List.rev (flat [] x)

let trav2 f x =
  let rec aux a = function
    | [] -> a
    | [x] -> a
    | x :: y :: [] -> aux (f x y :: a) []
    | x :: y :: t -> aux (f x y :: a) (y :: t)
  in List.rev (aux [] x)

let filt2 f x y = if f x y then [x; y] else []
