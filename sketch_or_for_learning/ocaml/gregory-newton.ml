let read_list () =
  read_line ()
  |> String.split_on_char ' '
  |> List.filter (fun x -> x<>"")
  |> List.map (float_of_string)

let rec diff x =
  if (List.for_all (fun y -> (List.hd x) = y) x) then
    []
  else
    diff (List.fold_left (-) (List.hd x) (List.tl x))
