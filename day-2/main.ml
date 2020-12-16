open Batteries


let process filename =
  let filelines = File.lines_of filename in
  Enum.map ( fun line -> int_of_string line ) filelines


let () =
   let numbers = process "input"
   in
   let pairs = Enum.cartesian_product numbers numbers
   in
     let answer = Enum.find ( fun t -> (fst t) != (snd t) && (fst t) + (snd t) == 2020 ) pairs
     in
       print_int ((fst answer) * (snd answer));
       print_newline ();
