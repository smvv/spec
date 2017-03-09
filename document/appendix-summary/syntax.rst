Abstract Syntax Summary
-----------------------

Numbers
~~~~~~~

.. math::
   \begin{array}{llll}
   \production{(bytes)} & b &::=& \hex{00} ~|~ \dots ~|~ \hex{FF} \\
   \production{(unsigned integers)} & \uX{N} &::=& 0 ~|~ 1 ~|~ \dots ~|~ 2^N{-}1 \\
   \production{(signed integers)} & \sX{N} &::=& -2^{N-1} ~|~ \dots ~|~ {-}1 ~|~ 0 ~|~ 1 ~|~ \dots ~|~ 2^{N-1}{-}1 \\
   \production{(uninterpreted integers)} & \iX{N} &::=& \uX{N} ~|~ \sX{N} \\
   \production{(floating-point numbers)} & \fX{N} &::=& b^{N/8} \\
   \end{array}


Vectors
~~~~~~~

.. math::
   \begin{array}{llll}
   \production{(vectors)} & \vec(x) &::=& [x^\ast] \\
   \end{array}


Strings
~~~~~~~

.. math::
   \begin{array}{llll}
   \production{(strings)} & \string &::=& \vec(b) \\
   \production{(names)} & \name &::=& \href{#strings}{\string} \\
   \end{array}


Types
~~~~~

.. math::
   \begin{array}{llll}
   \production{(value types)} & \valtype &::=&
     \I32 ~|~ \I64 ~|~ \F32 ~|~ \F64 \\
   \production{(result types)} & \resulttype &::=&
     \valtype^? \\
   \production{(function types)} & \functype &::=&
     \valtype^\ast \to \resulttype \\
   ~ \\
   \production{(memory types)} & \memtype &::=&
     \limits \\
   \production{(table types)} & \tabletype &::=&
     \limits~\elemtype \\
   \production{(element types)} & \elemtype &::=&
     \ANYFUNC \\
   \production{(limits)} & \limits &::=&
      \{ \MIN~\href{#numbers}{\u32},
         \MAX~\href{#numbers}{\u32}^? \} \\
   ~ \\
   \production{(global types)} & \globaltype &::=& \mut~\valtype \\
   \production{(mutability)} & \mut &::=& \MUT^? \\
   ~ \\
   \production{(external types)} & \externtype &::=&
     \FUNC~\functype ~|~ \\&&&
     \TABLE~\tabletype ~|~ \\&&&
     \MEMORY~\memtype ~|~ \\&&&
     \GLOBAL~\globaltype \\
   \end{array}


Indices
~~~~~~~

.. math::
   \begin{array}{llll}
   \production{(type indices)} & \typeidx &::=& \href{#numbers}{\u32} \\
   \production{(function indices)} & \funcidx &::=& \href{#numbers}{\u32} \\
   \production{(table indices)} & \tableidx &::=& \href{#numbers}{\u32} \\
   \production{(memory indices)} & \memidx &::=& \href{#numbers}{\u32} \\
   \production{(global indices)} & \globalidx &::=& \href{#numbers}{\u32} \\
   \production{(local indices)} & \localidx &::=& \href{#numbers}{\u32} \\
   \production{(label indices)} & \labelidx &::=& \href{#numbers}{\u32} \\
   \end{array}


Modules
~~~~~~~

.. index::
   pair: grammar; modules
   pair: grammar; sections

.. math::
   \begin{array}{lllll}
   \production{(modules)} & \module &::=& \{ &
     \TYPES~\vec(\href{#types}{\functype}), \\&&&&
     \FUNCS~\vec(\func), \\&&&&
     \TABLES~\vec(\table), \\&&&&
     \MEMS~\vec(\mem), \\&&&&
     \GLOBALS~\vec(\global), \\&&&&
     \IMPORTS~\vec(\import), \\&&&&
     \EXPORTS~\vec(\export), \\&&&&
     \START~\href{#indices}{\funcidx}, \\&&&&
     \ELEM~\vec(\elemseg), \\&&&&
     \DATA~\vec(\dataseg) \quad\} \\
   \end{array}
   \void{
   \begin{array}{llll}
   \production{(modules)} & \module &::=&
     \typesec^?~\customsec^\ast~\\&&&
     \importsec^?~\customsec^\ast~\\&&&
     \funcsec^?~\customsec^\ast~\\&&&
     \tablesec^?~\customsec^\ast~\\&&&
     \memsec^?~\customsec^\ast~\\&&&
     \globalsec^?~\customsec^\ast~\\&&&
     \exportsec^?~\customsec^\ast~\\&&&
     \startsec^?~\customsec^\ast~\\&&&
     \elemsec^?~\customsec^\ast~\\&&&
     \codesec^?~\customsec^\ast~\\&&&
     \datasec^?~\customsec^\ast \\
   ~ \\
   \production{(custom sections)} & \customsec &::=&
     \CUSTOM~\href{#strings}{\name}~b^\ast \\
   \production{(type sections)} & \typesec &::=&
     \TYPE~\href{#types}{\functype}^\ast \\
   \production{(import sections)} & \importsec &::=&
     \IMPORT~\import^\ast \\
   \production{(function sections)} & \funcsec &::=&
     \FUNC~\href{#indices}{\typeidx}^\ast \\
   \production{(table sections)} & \tablesec &::=&
     \TABLE~\href{#types}{\tabletype}^\ast \\
   \production{(memory sections)} & \memsec &::=&
     \MEMORY~\href{#types}{\memtype}^\ast \\
   \production{(global sections)} & \globalsec &::=&
     \GLOBAL~\global^\ast \\
   \production{(export sections)} & \exportsec &::=&
     \EXPORT~\export^\ast \\
   \production{(start sections)} & \startsec &::=&
     \START~\href{#indices}{\funcidx} \\
   \production{(code sections)} & \codesec &::=&
     \CODE~\code^\ast \\
   \production{(element sections)} & \elemsec &::=&
     \ELEM~\elemseg^\ast \\
   \production{(data sections)} & \datasec &::=&
     \DATA~\dataseg^\ast \\
   \end{array}
   }

.. math::
   \begin{array}{llll}
   \production{(functions)} & \func &::=&
     \{ \TYPE~\typeidx, \LOCALS~\vec(\href{#types}{\valtype}), \BODY~\expr \} \\
   \production{(tables)} & \table &::=&
     \{ \TYPE~\tabletype \} \\
   \production{(memories)} & \mem &::=&
     \{ \TYPE~\memtype \} \\
   \production{(globals)} & \global &::=&
     \{ \TYPE~\href{#types}{\globaltype}, \INIT~\href{#expressions}{\expr} \} \\
   \production{(expressions)} & \expr &::=&
     \href{#instructions}{\instr}^\ast~\END \\
   ~ \\
   \production{(data segments)} & \dataseg &::=&
     \{ \OFFSET~\href{#expressions}{\expr}, \INIT~\vec(\href{#numbers}{b}) \} \\
   \production{(element segments)} & \elemseg &::=&
     \{ \OFFSET~\href{#expressions}{\expr}, \INIT~\vec(\href{#indices}{\funcidx}) \} \\
   ~ \\
   \production{(imports)} & \import &::=&
     \{ \MODULE~\href{#strings}{\name}, \NAME~\href{#strings}{\name}, \DESC~\importdesc \} \\
   \production{(import descriptions)} & \importdesc &::=&
     \FUNC~\href{#indices}{\typeidx} ~|~ \\&&&
     \TABLE~\href{#types}{\tabletype} ~|~ \\&&&
     \MEMORY~\href{#types}{\memtype} ~|~ \\&&&
     \GLOBAL~\href{#types}{\globaltype} \\
   ~ \\
   \production{(exports)} & \export &::=&
     \{ \NAME~\href{#strings}{\name}, \DESC~\exportdesc \} \\
   \production{(export descriptions)} & \exportdesc &::=&
     \FUNC~\href{#indices}{\funcidx} ~|~ \\&&&
     \TABLE~\href{#indices}{\tableidx} ~|~ \\&&& \MEMORY~\href{#indices}{\memidx} ~|~ \\&&&
     \GLOBAL~\href{#indices}{\globalidx} \\
   \end{array}


Instructions
~~~~~~~~~~~~

.. index::
   pair: grammar; instructions

.. math::
   \begin{array}{llll}
   \production{(width)} & \X{nn}, \X{mm} &::=&
     \K{32} ~|~ \K{64} \\
   \production{(signedness)} & \sx &::=&
     \K{u} ~|~ \K{s} \\
   \production{(memory operators)} & \memop &::=&
     \{ \ALIGN~\u32, \OFFSET~\u32 \} \\
   \end{array}

.. math::
   \begin{array}{llll}
   \production{(instructions)} & \instr &::=&
     \K{unreachable} ~|~ \\&&&
     \K{nop} ~|~ \\&&&
     \K{block}~\href{#types}{\resulttype}~\instr^\ast~\END ~|~ \\&&&
     \K{loop}~\href{#types}{\resulttype}~\instr^\ast~\END ~|~ \\&&&
     \K{if}~\href{#types}{\resulttype}~\instr^\ast~\K{else}~\instr^\ast~\END ~|~ \\&&&
     \K{br}~\href{#indices}{\labelidx} ~|~ \\&&&
     \K{br\_if}~\href{#indices}{\labelidx} ~|~ \\&&&
     \K{br\_table}~\vec(\href{#indices}{\labelidx})~\href{#indices}{\labelidx} ~|~ \\&&&
     \K{return} ~|~ \\&&&
     \K{call}~\href{#indices}{\funcidx} ~|~ \\&&&
     \K{call\_indirect}~\href{#indices}{\typeidx} ~|~ \\&&&
     \K{drop} ~|~ \\&&&
     \K{select} ~|~ \\&&&
     \K{get\_local}~\href{#indices}{\localidx} ~|~ \\&&&
     \K{set\_local}~\href{#indices}{\localidx} ~|~ \\&&&
     \K{tee\_local}~\href{#indices}{\localidx} ~|~ \\&&&
     \K{get\_global}~\href{#indices}{\globalidx} ~|~ \\&&&
     \K{set\_global}~\href{#indices}{\globalidx} ~|~ \\&&&
     \K{i}\X{nn}\K{.load}~\memop ~|~
     \K{f}\X{nn}\K{.load}~\memop ~|~ \\&&&
     \K{i}\X{nn}\K{.store}~\memop ~|~
     \K{f}\X{nn}\K{.store}~\memop ~|~ \\&&&
     \K{i}\X{nn}\K{.load8\_}\sx~\memop ~|~ \\&&&
     \K{i}\X{nn}\K{.load16\_}\sx~\memop ~|~ \\&&&
     \K{i64.load32\_}\sx~\memop ~|~ \\&&&
     \K{i}\X{nn}\K{.store8}~\memop ~|~ \\&&&
     \K{i}\X{nn}\K{.store16}~\memop ~|~ \\&&&
     \K{i64.store32}~\memop ~|~ \\&&&
     \K{i}\X{nn}\K{.const}~\iX{\X{nn}} ~|~
     \K{f}\X{nn}\K{.const}~\fX{\X{nn}} ~|~ \\&&&
     \K{i}\X{nn}\K{.eqz} ~|~ \\&&&
     \K{i}\X{nn}\K{.eq} ~|~
     \K{i}\X{nn}\K{.ne} ~|~
     \K{i}\X{nn}\K{.lt\_}\sx ~|~
     \K{i}\X{nn}\K{.gt\_}\sx ~|~
     \K{i}\X{nn}\K{.le\_}\sx ~|~
     \K{i}\X{nn}\K{.ge\_}\sx ~|~ \\&&&
     \K{f}\X{nn}\K{.eq} ~|~
     \K{f}\X{nn}\K{.ne} ~|~
     \K{f}\X{nn}\K{.lt} ~|~
     \K{f}\X{nn}\K{.gt} ~|~
     \K{f}\X{nn}\K{.le} ~|~
     \K{f}\X{nn}\K{.ge} ~|~ \\&&&
     \K{i}\X{nn}\K{.clz} ~|~
     \K{i}\X{nn}\K{.ctz} ~|~
     \K{i}\X{nn}\K{.popcnt} ~|~ \\&&&
     \K{i}\X{nn}\K{.add} ~|~
     \K{i}\X{nn}\K{.sub} ~|~
     \K{i}\X{nn}\K{.mul} ~|~
     \K{i}\X{nn}\K{.div\_}\sx ~|~
     \K{i}\X{nn}\K{.rem\_}\sx ~|~ \\&&&
     \K{i}\X{nn}\K{.and} ~|~
     \K{i}\X{nn}\K{.or} ~|~
     \K{i}\X{nn}\K{.xor} ~|~ \\&&&
     \K{i}\X{nn}\K{.shl} ~|~
     \K{i}\X{nn}\K{.shr\_}\sx ~|~
     \K{i}\X{nn}\K{.rotl} ~|~
     \K{i}\X{nn}\K{.rotr} ~|~ \\&&&
     \K{f}\X{nn}\K{.abs} ~|~
     \K{f}\X{nn}\K{.neg} ~|~
     \K{f}\X{nn}\K{.sqrt} ~|~ \\&&&
     \K{f}\X{nn}\K{.ceil} ~|~ 
     \K{f}\X{nn}\K{.floor} ~|~ 
     \K{f}\X{nn}\K{.trunc} ~|~ 
     \K{f}\X{nn}\K{.nearest} ~|~ \\&&&
     \K{f}\X{nn}\K{.add} ~|~
     \K{f}\X{nn}\K{.sub} ~|~
     \K{f}\X{nn}\K{.mul} ~|~
     \K{f}\X{nn}\K{.div} ~|~ \\&&&
     \K{f}\X{nn}\K{.min} ~|~
     \K{f}\X{nn}\K{.max} ~|~
     \K{f}\X{nn}\K{.copysign} ~|~ \\&&&
     \K{i32.wrap/i64} ~|~
     \K{i64.extend\_}\sx/\K{i32} ~|~
     \K{i}\X{nn}\K{.trunc\_}\sx/\K{f}\X{mm} ~|~ \\&&&
     \K{f32.demote/f64} ~|~
     \K{f64.promote/f32} ~|~
     \K{f}\X{nn}\K{.convert\_}\sx/\K{i}\X{mm} ~|~ \\&&&
     \K{i}\X{nn}\K{.reinterpret/f}\X{nn} ~|~
     \K{f}\X{nn}\K{.reinterpret/i}\X{nn} \\
   \end{array}
