open Values
open Instance

type 'a stack = 'a list

exception Link of Source.region * string
exception Trap of Source.region * string
exception Crash of Source.region * string

val init : Ast.module_ -> extern list -> instance
val invoke : func -> value list -> value list (* raises Trap *)
val const : Ast.module_ -> Ast.const -> value
