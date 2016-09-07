open Values
open Types
open Instance
open Ast
open Source


(* Errors *)

module Link = Error.Make ()
module Trap = Error.Make ()
module Crash = Error.Make ()

exception Link = Link.Error
exception Trap = Trap.Error
exception Crash = Crash.Error (* failure that cannot happen in valid code *)

let memory_error at = function
  | Memory.Bounds -> Trap.error at "out of bounds memory access"
  | Memory.SizeOverflow -> Trap.error at "memory size overflow"
  | Memory.SizeLimit -> Trap.error at "memory size limit reached"
  | Memory.Type -> Crash.error at "type mismatch at memory access"
  | exn -> raise exn

let numeric_error at = function
  | Eval_numeric.TypeError (i, v, t) ->
    Crash.error at
      ("type error, expected " ^ Types.string_of_value_type t ^ " as operand " ^
       string_of_int i ^ ", got " ^ Types.string_of_value_type (type_of v))
  | Numeric_error.IntegerOverflow ->
    Trap.error at "integer overflow"
  | Numeric_error.IntegerDivideByZero ->
    Trap.error at "integer divide by zero"
  | Numeric_error.InvalidConversionToInteger ->
    Trap.error at "invalid conversion to integer"
  | exn -> raise exn


(* Configurations *)

type config =
{
  instance : instance;
  locals : value ref list;
  resources : int;
}

type 'a stack = 'a list

type admin_expr =
  | Instr of instr
  | Label of admin_expr list * value stack * admin_expr list
  | Local of instance * value list * int * value stack * admin_expr list
  | Trapping of Source.region * string

let resource_limit = 100
let config inst = {instance = inst; locals = []; resources = resource_limit}

let lookup category list x =
  try List.nth list x.it with Failure _ ->
    Crash.error x.at ("undefined " ^ category ^ " " ^ string_of_int x.it)

let type_ inst x = lookup "type" inst.module_.it.types x
let func c x = lookup "function" c.instance.funcs x
let table c x = lookup "table" c.instance.tables x
let memory c x = lookup "memory" c.instance.memories x
let global c x = lookup "global" c.instance.globals x
let local c x = lookup "local" c.locals x

let elem c x i t at =
  match Table.load (table c x) i t with
  | Some j -> j
  | None ->
    Trap.error at ("uninitialized element " ^ Int32.to_string i)
  | exception Table.Bounds ->
    Trap.error at ("undefined element " ^ Int32.to_string i)

let func_elem c x i at =
  match elem c x i AnyFuncType at with
  | Func f -> f
  | _ -> Crash.error at ("type mismatch for element " ^ Int32.to_string i)

let func_type_of t at =
  match t with
  | AstFunc (inst, f) -> lookup "type" (!inst).module_.it.types f.it.ftype
  | HostFunc _ -> Link.error at "invalid use of host function"


(* Evaluation *)

(*
 * Conventions:
 *   c  : config
 *   e  : instr
 *   v  : value
 *   es : instr list
 *   vs : value list
 *)

let i32 v at =
  match v with
  | I32 i -> i
  | _ -> Crash.error at "type error: i32 value expected"

let keep n (vs : value stack) at =
  try Lib.List.take n vs with Failure _ ->
    Crash.error at "stack underflow"

let drop n (vs : value stack) at =
  try Lib.List.drop n vs with Failure _ ->
    Crash.error at "stack underflow"

let rec step_instr (c : config) (vs : value stack) (e : instr)
  : value stack * admin_expr list =
  match e.it, vs with
  | Unreachable, vs ->
    vs, [Trapping (e.at, "unreachable executed")]

  | Nop, vs ->
    vs, []

  | Drop, v :: vs' ->
    vs', []

  | Block es, vs ->
    vs, [Label ([], [], List.map (fun e -> Instr e) es)]

  | Loop es, vs ->
    vs, [Label ([Instr e], [], List.map (fun e -> Instr e) es)]

  | Br (n, x), vs ->
    assert false  (* abrupt *)

  | BrIf (n, x), I32 0l :: vs' ->
    drop n vs' e.at, []

  | BrIf (n, x), I32 i :: vs' ->
    vs', [Instr (Br (n, x) @@ e.at)]

  | BrTable (n, xs, x), I32 i :: vs' when I32.ge_u i (Lib.List.length32 xs) ->
    vs', [Instr (Br (n, x) @@ e.at)]

  | BrTable (n, xs, x), I32 i :: vs' ->
    vs', [Instr (Br (n, Lib.List.nth32 xs i) @@ e.at)]

  | Return, vs ->
    assert false  (* abrupt *)

  | If (es1, es2), I32 0l :: vs' ->
    vs', [Instr (Block es2 @@ e.at)]

  | If (es1, es2), I32 i :: vs' ->
    vs', [Instr (Block es1 @@ e.at)]

  | Select, I32 0l :: v2 :: v1 :: vs' ->
    v2 :: vs', []

  | Select, I32 i :: v2 :: v1 :: vs' ->
    v1 :: vs', []

(* TODO***: need type in host_func
  | Call x, vs ->
    if c.resources = 0 then Trap.error e.at "call stack exhausted";
    let f = func c x in
    let FuncType (ins, out) = type_ c f.it.ftype in
    let n = List.length ins in
    let m = List.length out in
    let args = List.rev (keep n vs e.at) in
    let locals = List.map default_value f.it.locals in
    drop n vs e.at, Local (inst, args @ locals, m, [], f.it.body)

  match func with
  | AstFunc (inst, f) ->
    if List.length vs <> List.length (func_type_of func at).ins then
      Crash.error at "function called with wrong number of arguments";
    let args = List.map ref vs in
    let vars = List.map (fun t -> ref (default_value t)) f.it.locals in
    let locals = args @ vars in
    eval_expr {(empty_config !inst) with locals} f.it.body

  | HostFunc f ->
    try f vs with Crash (_, msg) -> Crash.error at msg

  | CallImport x, vs ->
    let x, f = import c x in
    let FuncType (ins, out) = type_ c (x @@ e.at) in
    let n = List.length ins in
    (try
      let vs' = List.rev (f (List.rev (keep n vs e.at))) in
      drop n vs e.at @ vs', []
    with Crash (_, msg) -> Crash.error e.at msg)

  | CallIndirect x, I32 i :: vs ->
    let f = func_elem c (0 @@ e.at) i e.at in
    if type_ c.instance x <> func_type_of f e.at then
      Trap.error e.at "indirect call signature mismatch";
    vs, [Instr (Call y @@ e.at)]
*)

  | GetLocal x, vs ->
    !(local c x) :: vs, []

  | SetLocal x, v :: vs' ->
    local c x := v;
    vs', []

  | TeeLocal x, v :: vs' ->
    local c x := v;
    v :: vs', []

  | GetGlobal x, vs ->
    !(global c x) :: vs, []

  | SetGlobal x, v :: vs' ->
    global c x := v;
    vs', []

  | Load {offset; ty; sz; _}, I32 i :: vs' ->
    let mem = memory c (0 @@ e.at) in
    let addr = I64_convert.extend_u_i32 i in
    let v =
      try
        match sz with
        | None -> Memory.load mem addr offset ty
        | Some (sz, ext) -> Memory.load_packed sz ext mem addr offset ty
      with exn -> memory_error e.at exn
    in v :: vs', []

  | Store {offset; sz; _}, v :: I32 i :: vs' ->
    let mem = memory c (0 @@ e.at) in
    let addr = I64_convert.extend_u_i32 i in
    (try
      match sz with
      | None -> Memory.store mem addr offset v
      | Some sz -> Memory.store_packed sz mem addr offset v
    with exn -> memory_error e.at exn);
    vs', []

  | Const v, vs ->
    v.it :: vs, []

  | Unary unop, v :: vs' ->
    (try Eval_numeric.eval_unop unop v :: vs', []
    with exn -> numeric_error e.at exn)

  | Binary binop, v2 :: v1 :: vs' ->
    (try Eval_numeric.eval_binop binop v1 v2 :: vs', []
    with exn -> numeric_error e.at exn)

  | Test testop, v :: vs' ->
    (try value_of_bool (Eval_numeric.eval_testop testop v) :: vs', []
    with exn -> numeric_error e.at exn)

  | Compare relop, v2 :: v1 :: vs' ->
    (try value_of_bool (Eval_numeric.eval_relop relop v1 v2) :: vs', []
    with exn -> numeric_error e.at exn)

  | Convert cvtop, v :: vs' ->
    (try Eval_numeric.eval_cvtop cvtop v :: vs', []
    with exn -> numeric_error e.at exn)

  | CurrentMemory, vs ->
    let mem = memory c (0 @@ e.at) in
    I32 (Memory.size mem) :: vs, []

  | GrowMemory, I32 delta :: vs' ->
    let mem = memory c (0 @@ e.at) in
    let old_size = Memory.size mem in
    let result =
      try Memory.grow mem delta; old_size
      with Memory.SizeOverflow | Memory.SizeLimit | Memory.OutOfMemory -> -1l
    in I32 result :: vs', []

  | _, _ ->
    Crash.error e.at "type error: missing or ill-typed operand on stack"

and step_admin (c : config)  (vs : value stack) (e : admin_expr) : value stack * admin_expr list =
  match e, vs with
  | Instr e', vs ->
    step_instr c vs e'

  | Label (es_cont, vs', []), vs ->
    vs' @ vs, []

  | Label (es_cont, vs', Instr {it = Br (n, i); at} :: es), vs when i.it = 0 ->
    keep n vs' at @ vs, es_cont

  | Label (es_cont, vs', Instr {it = Br (n, i); at} :: es), vs ->
    vs', [Instr (Br (n, (i.it - 1) @@ i.at) @@ at)]

  | Label (es_cont, vs', Instr {it = Return; at} :: es), vs ->
    vs', [Instr (Return @@ at)]

  | Label (es_cont, vs', Trapping (at, msg) :: es), vs ->
    [], [Trapping (at, msg)]

  | Label (es_cont, vs', e :: es), vs ->
    let vs'', es' = step_admin c vs' e in
    vs, [Label (es_cont, vs'', es' @ es)]

  | Local (inst, vs_local, n, vs', []), vs ->
    vs' @ vs, []

  | Local (inst, vs_local, n, vs', Instr {it = Br (n', i); at} :: es), vs
      when i.it = 0 ->
    if n <> n' then Crash.error at "inconsistent result arity";
    keep n vs' at @ vs, []

  | Local (inst, vs_local, n, vs', Instr {it = Return; at} :: es), vs ->
    keep n vs' at @ vs, []

  | Local (inst, vs_local, n, vs', Trapping (at, msg) :: es), vs ->
    [], [Trapping (at, msg)]

  | Local (inst, vs_local, n, vs', e :: es), vs ->
    let c' =
      { instance = inst;
        locals = List.map ref vs_local;
        resources = c.resources - 1 }
    in
    let vs'', es' = step_admin c' vs' e in
    vs, [Local (inst, List.map (!) c'.locals, n, vs'', es' @ es)]

  | Trapping _, vs ->
    assert false (* abrupt *)


let rec eval_block (c : config) (vs : value stack) (es : admin_expr list) : value stack =
  match es with
  | [] -> vs
  | [Trapping (at, msg)] -> Trap.error at msg
  | e :: es ->
    let vs', es' = step_admin c vs e in
    eval_block c vs' (es' @ es)


(* Functions & Constants *)

(*TODO****
and eval_func func vs at =
  match func with
  | AstFunc (inst, f) ->
    if List.length vs <> List.length (func_type_of func at).ins then
      Crash.error at "function called with wrong number of arguments";
    let args = List.map ref vs in
    let vars = List.map (fun t -> ref (default_value t)) f.it.locals in
    let locals = args @ vars in
    eval_expr {(empty_config !inst) with locals} f.it.body

  | HostFunc f ->
    try f vs with Crash (_, msg) -> Crash.error at msg
*)

let eval_func _ = assert false
(*
let eval_func (func : func) (vs : value list) : value list =
  match func with
  | AstFunc (inst, f) ->
    if List.length vs <> List.length (func_type_of func at).ins then
      Crash.error at "function called with wrong number of arguments";
    let args = List.map ref vs in
    let vars = List.map (fun t -> ref (default_value t)) f.it.locals in
    let locals = args @ vars in
    eval_expr {(empty_config !inst) with locals} f.it.body

  | HostFunc f ->
    try f vs with Crash (_, msg) -> Crash.error at msg

let eval_func (inst : instance) (vs : value list) (x : var) : value list =
  let c = {instance = inst; locals = []; resources = resource_limit} in
  List.rev (eval_block c (List.rev vs) [Call x @@ x.at])
*)

let eval_const c const =
  match eval_block c [] (List.map (fun e -> Instr e) const.it) with
  | [v] -> v
  | _ -> Crash.error const.at "type error: wrong number of values on stack"

let const (m : module_) const =
  eval_const (config (instance m)) const


(* Modules *)

let create_func m f =
  AstFunc (ref (instance m), f)

let create_table tab =
  let {ttype = TableType (lim, t)} = tab.it in
  Table.create lim  (* TODO: elem_type *)

let create_memory mem =
  let {mtype = MemoryType lim} = mem.it in
  Memory.create lim

let create_global glob =
  let {gtype = GlobalType (t, _); _} = glob.it in
  ref (default_value t)

let init_func c f =
  match f with
  | AstFunc (inst, _) -> inst := c.instance
  | _ -> assert false

let check_elem c seg =
  let {init; _} = seg.it in
  List.iter (fun x -> ignore (func_type_of (func c x) x.at)) init

let init_table c seg =
  let {index; offset = e; init} = seg.it in
  let tab = table c index in
  let offset = i32 (eval_const c e) e.at in
  Table.blit tab offset (List.map (fun x -> Some (Func (func c x))) init)

let init_memory c seg =
  let {index; offset = e; init} = seg.it in
  let mem = memory c index in
  let offset = Int64.of_int32 (i32 (eval_const c e) e.at) in
  Memory.blit mem offset init

let init_global c ref glob =
  let {value = e; _} = glob.it in
  ref := eval_const c e

let check_limits actual expected at =
  if I32.lt_u actual.min expected.min then
    Link.error at "actual size smaller than declared";
  if
    match actual.max, expected.max with
    | _, None -> false
    | None, Some _ -> true
    | Some i, Some j -> I32.gt_u i j
  then Link.error at "maximum size larger than declared"

let add_import (ext : extern) (imp : import) (inst : instance) : instance =
  match ext, imp.it.ikind.it with
  | ExternalFunc f, FuncImport x ->
    (match f with
    | AstFunc _ when func_type_of f x.at <> type_ inst x ->
      Link.error imp.it.ikind.at "type mismatch";
    | _ -> ()
    );
    {inst with funcs = f :: inst.funcs}
  | ExternalTable tab, TableImport (TableType (lim, _)) ->
    check_limits (Table.limits tab) lim imp.it.ikind.at;
    {inst with tables = tab :: inst.tables}
  | ExternalMemory mem, MemoryImport (MemoryType lim) ->
    check_limits (Memory.limits mem) lim imp.it.ikind.at;
    {inst with memories = mem :: inst.memories}
  | ExternalGlobal v, GlobalImport (GlobalType _) ->
    {inst with globals = ref v :: inst.globals}
  | _ ->
    Link.error imp.it.ikind.at "type mismatch"

let add_export c ex map =
  let {name; ekind; item} = ex.it in
  let ext =
    match ekind.it with
    | FuncExport -> ExternalFunc (func c item)
    | TableExport -> ExternalTable (table c item)
    | MemoryExport -> ExternalMemory (memory c item)
    | GlobalExport -> ExternalGlobal !(global c item)
  in ExportMap.add name ext map

let init m externals =
  let
    { imports; tables; memories; globals; funcs;
      exports; elems; data; start } = m.it
  in
  assert (List.length externals = List.length imports);  (* TODO: better exception? *)
  let fs = List.map (create_func m) funcs in
  let gs = List.map create_global globals in
  let inst =
    List.fold_right2 add_import externals imports
      { (instance m) with
        funcs = fs;
        tables = List.map create_table tables;
        memories = List.map create_memory memories;
        globals = gs;
      }
  in
  let c = config inst in
  List.iter (init_func c) fs;
  List.iter (check_elem c) elems;
  List.iter (init_table c) elems;
  List.iter (init_memory c) data;
  List.iter2 (init_global c) gs globals;
  Lib.Option.app (fun x -> ignore (eval_func (func c x) [] x.at)) start;
  {inst with exports = List.fold_right (add_export c) exports inst.exports}

let invoke func vs =
  (try eval_func func vs no_region
  with Stack_overflow -> Trap.error no_region "call stack exhausted")
