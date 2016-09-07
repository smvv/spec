(*
 * Simple collection of functions useful for writing test cases.
 *)

open Types
open Values
open Instance


let global = function
  | I32Type -> I32 666l
  | I64Type -> I64 666L
  | F32Type -> F32 (F32.of_float 666.0)
  | F64Type -> F64 (F64.of_float 666.0)

let table = Table.create {min = 10l; max = Some 20l}
let memory = Memory.create {min = 1l; max = Some 2l}

let print out vs =
  Print.print_result vs;
  List.map default_value out


let lookup name t =
  match name, t with
  | "print", ExternalFuncType (FuncType (_, out)) ->
    ExternalFunc (HostFunc (print out))
  | "print", _ -> ExternalFunc (HostFunc (print []))
  | "global", ExternalGlobalType (GlobalType (t, Immutable)) ->
    ExternalGlobal (global t)
  | "global", _ -> ExternalGlobal (global I32Type)
  | "table", _ -> ExternalTable table
  | "memory", _ -> ExternalMemory memory
  | _ -> raise Not_found
