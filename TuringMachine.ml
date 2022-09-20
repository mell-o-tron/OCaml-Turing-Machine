(* Assume all elements of the tape are in the alphabet, all states in transition are state set *)

type character  = C of char | White | Resp
type state      = Final | State of int
type movement   = L | R | N;;
type transition = (state * character) -> state * character * movement
type t_machine  = TM of transition * state
type config     = Conf of state * character list * character * character list | Done


let remove_first lst = match lst with _::lst1 -> lst1 | [] -> []
let remove_last lst  = match (List.rev lst) with _::lst1 -> (List.rev lst1) | [] -> []

let get_first lst = match lst with a::_-> a | [] -> failwith "Overflow"
let get_last lst  = match (List.rev lst) with a::_ -> a | [] -> failwith "Underflow"


let step tfun configuration = match configuration with
    | Conf (cur_state, l, c, r) ->
        (match tfun (cur_state, c) with
            | new_s, new_c, dir -> (match dir with
                | N -> print_endline "idle"  ; Conf (new_s, l, new_c, r)
                | L -> print_endline "left"  ; Conf (new_s, remove_last l, get_last l, new_c :: r)
                | R -> print_endline "right" ; Conf (new_s, l @ [new_c], get_first r, remove_first r)
                ))
    | Done -> failwith "Computation is complete"

let run tm (l, c, r) = match tm with
    | TM (tfun, state) ->
        let rec steps (configuration) = (match configuration with
        | Conf (state, l, c, r) ->
            (if state = Final then Done else
                steps (step tfun (Conf (state, l, c, r))))
        | Done -> Done)
        in steps (Conf(state, l, c, r))


(* ################################################# *)

let left  = [Resp ; C 'a']
let cent  = White
let right = [C 'a' ; White ; White ; White ; White]

let tfun (s, c) = match (s, c) with
    | State x, Resp  -> State x, Resp,   R
    | State 0, C 'a' -> State 1, C 'a',  R
    | State 1, C 'a' -> Final,   C 'a',  R
    | State x, C 'b' -> State x, C 'a',  N
    | State x, White -> State x, C 'a',  N
    | _ -> failwith ("Got stuck, transition is not total")



let tm = TM (tfun, State 0);;
run tm (left, cent, right)
