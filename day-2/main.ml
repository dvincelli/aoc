open Batteries

type password_record =
  { low : int;
    high : int;
    char : char;
    password : string
  }

let parse_records filename =
  let rex = Re.Pcre.regexp "-|:| " in
  File.lines_of filename
    |> Enum.map (fun l ->
      let matches = Re.Pcre.split ~rex:rex l in
      {
        low = int_of_string (List.at matches 0);
        high = int_of_string (List.at matches 1);
        char = String.get (List.at matches 2) 0;
        password = List.at matches 4;
      }
    )
    |> List.of_enum
;;

let part1 records =
   List.filter
     (fun record ->
         (
           let ss = String.filter ((=) record.char) record.password in
           let slen = String.length ss in
           slen >= record.low && slen <= record.high
         )
     ) records
   |> List.length
;;

let part2 records =
   List.filter
     (fun record ->
        let low = record.low - 1 and
            high = record.high - 1 in
         (
           ((String.get record.password low = record.char) && (String.get record.password high != record.char))
         ||
           ((String.get record.password low != record.char) && (String.get record.password high = record.char))
         )
     ) records
   |> List.length
;;

let main =
  let records = parse_records "input" in
  part1 records
    |> print_int;
  print_newline ();
  part2 records
    |> print_int;
  print_newline ();
;;
