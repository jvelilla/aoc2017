open System
open System.Text.RegularExpressions

module Aoc16a =

  type Program = char

  type State = array<Program>

  let stateFromString (s: string): State = s.ToCharArray()

  let stateToString (state: State): string =
    state |> Array.map Char.ToString |> String.concat ""

  let swap (i: int) (j: int) (arr: array<'a>): array<'a> =
      let tmp = Array.get arr i
      Array.set arr i (Array.get arr j)
      Array.set arr j tmp
      arr

  type Move =
    | Spin of count: int
    | Exchange of posA: int * posB: int
    | Partner of programA: Program * programB: Program

  let (|Match|_|) (regexp: string) (s: string) =
    let m = Regex.Match(s, regexp)
    if m.Success
    then Some(m.Groups |> Seq.cast<Group> |> Seq.map (fun g -> g.Value) |> Seq.toArray)
    else None

  let parseInt (s: string): int = s |> System.Int32.Parse

  let parseProgram (s: string): Program = s.[0]

  let parseMove (s: string): Move =
    match s with
      | Match "s(\d+)" groups -> Spin(groups.[1] |> parseInt)
      | Match "x(\d+)/(\d+)" groups -> Exchange((groups.[1] |> parseInt), (groups.[2] |> parseInt))
      | Match "p(.)/(.)" groups -> Partner((groups.[1] |> parseProgram), (groups.[2] |> parseProgram))
      | _ -> failwith "no match found"

  let parseDance (s: string): seq<Move> = s.Split(',') |> Array.map parseMove |> Array.toSeq

  let startState: State =
    stateFromString "abcdefghijklmnop"

  let makeMove (state: State) (move: Move) =
    match move with
      | Spin(count) ->
          Array.append
            (Array.sub state (state.Length - count) count)
            (Array.sub state 0 (state.Length - count))
      | Exchange(i, j) ->
          Array.copy state |> swap i j
      | Partner(a, b) ->
          let i = Array.IndexOf(state, a)
          let j = Array.IndexOf(state, b)
          Array.copy state |> swap i j

  let dance (start: State) (dance: seq<Move>): State =
    Seq.fold makeMove start dance

  [<EntryPoint>]
  let main argv =
    Console.ReadLine() |> parseDance |> dance startState |> stateToString |> printf "%s\n"
    0
