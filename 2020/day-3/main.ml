open Batteries

let process filename =
  File.lines_of filename
  |> Enum.map (fun line -> String.to_seq line)
  |> List.of_enum
;;

let rec slope ?(x1=1) ?(y1=1) ?(ymax=324) x y =
  if y1 >= ymax then []
  else let x2 = x1 + x and y2 = y1 + y in
    (x2, y2) :: slope ~x1:x2 ~y1:y2 ~ymax x y
;;

let main =
  let map = process "input"
  and s1 = slope 3 1 in
  List.iter (fun (x, y) -> print_int x; print_string " "; print_int y; print_newline() ; ) s1
;;
