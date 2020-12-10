open Batteries


let process filename =
  let filelines = File.lines_of filename in
  Enum.map ( fun line -> int_of_string line ) filelines


(*
let data = process "input"
let rec permute = function
  | [] -> []
  | hd :: [] -> [[hd]]
  | hd :: tl ->
    List.fold_left (fun acc p -> acc @ 
    let r = permute (hd :: acc) [] (lst @ tl) in
    if tl <> [] then
      r @ permute acc (hd :: lst) tl
    else
      r
      *)

let () =
   let pairs = Enum.cartesian_product (process "input") (process "input")
   in
     let answer = Enum.find ( fun t -> (fst t) != (snd t) && (fst t) + (snd t) == 2020 ) pairs
     in
       print_int ((fst answer) * (snd answer));
       print_newline ();
