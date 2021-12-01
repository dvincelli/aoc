open Batteries


let process filename =
  File.lines_of filename
  |> Enum.map (fun line -> int_of_string line)
  |> List.of_enum
;;


let part1 filename =
   let numbers = process filename in
   List.cartesian_product numbers numbers
   |> List.find_opt (fun (x, y) -> x + y == 2020)
   |> Option.map (fun (x, y) -> x * y)
;;

let part2 filename =
  let numbers = process filename in
  let set = Set.of_list numbers in
  numbers
    |> List.cartesian_product numbers
    |> List.find_opt (fun (x, y) -> (
       Set.exists (fun z -> 2020 - x - y  == z) set))
    |> Option.map (fun (x, y) -> (2020 - x - y) * x * y)
;;


let main =
  let ans1 = part1 "input"
  and ans2 = part2 "input" in
    Option.may (fun x -> print_int x) ans1;
    print_newline ();
    Option.may (fun x -> print_int x) ans2;
    print_newline ();
;;
