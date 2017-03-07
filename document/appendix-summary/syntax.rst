Abstract Syntax Summary
-----------------------

Numbers
~~~~~~~

.. math::
   \begin{array}{llll}
   \mbox{(bytes)} & b &::=& \hex{00} ~|~ \dots ~|~ \hex{FF} \\
   \mbox{(unsigned integers)} & \uint_N &::=& 0 ~|~ 1 ~|~ \dots ~|~ 2^N{-}1 \\
   \mbox{(signed integers)} & \sint_N &::=& -2^{N-1} ~|~ \dots ~|~ {-}1 ~|~ 0 ~|~ 1 ~|~ \dots ~|~ 2^{N-1}{-}1 \\
   \mbox{(floating-point numbers)} & \float_N &::=& b^{N/8} \\
   \mbox{(constants)} & c &::=& \sint32 ~|~ \sint64 ~|~ \float32 ~|~ \float64 \\
   \end{array}


Strings
~~~~~~~

.. math::
   \begin{array}{llll}
   \mbox{(strings)} & \string &::=& b^\ast \\
   \mbox{(names)} & \name &::=& \href{#strings}{\string} \\
   \end{array}


Types
~~~~~

.. math::
   \begin{array}{llll}
   \mbox{(value types)} & \valtype &::=& \I32 ~|~ \I64 ~|~ \F32 ~|~ \F64 \\
   \mbox{(result types)} & \resulttype &::=& \valtype^? \\
   \mbox{(function types)} & \functype &::=& \valtype^\ast \to \resulttype \\
   ~ \\
   \mbox{(table types)} & \tabletype &::=& \elemtype[\limits] \\
   \mbox{(memory types)} & \memtype &::=& \PAGE[\limits] \\
   \mbox{(element types)} & \elemtype &::=& \ANYFUNC \\
   \mbox{(limits)} & \limits &::=& \href{#numbers}{\uint32}~\href{#numbers}{\uint32}^? \\
   ~ \\
   \mbox{(global types)} & \globaltype &::=& \mut~\valtype \\
   \mbox{(mutability)} & \mut &::=& \MUT^? \\
   ~ \\
   \mbox{(external types)} & \externtype &::=&
     \FUNC~\functype ~|~ \\&&&
     \TABLE~\tabletype ~|~ \\&&&
     \MEMORY~\memtype ~|~ \\&&&
     \GLOBAL~\globaltype \\
   \end{array}


Indices
~~~~~~~

.. math::
   \begin{array}{llll}
   \mbox{(type indices)} & \typeidx &::=& \href{#numbers}{\uint32} \\
   \mbox{(function indices)} & \funcidx &::=& \href{#numbers}{\uint32} \\
   \mbox{(table indices)} & \tableidx &::=& \href{#numbers}{\uint32} \\
   \mbox{(memory indices)} & \memidx &::=& \href{#numbers}{\uint32} \\
   \mbox{(global indices)} & \globalidx &::=& \href{#numbers}{\uint32} \\
   \mbox{(local indices)} & \localidx &::=& \href{#numbers}{\uint32} \\
   \mbox{(label indices)} & \labelidx &::=& \href{#numbers}{\uint32} \\
   \end{array}


Modules
~~~~~~~

.. index::
   pair: grammar; modules
   pair: grammar; sections

.. math::
   \begin{array}{llll}
   \mbox{(modules)} & \module &::=&
     \customsec^\ast~\\&&&
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
   \mbox{(type sections)} & \typesec &::=&
     \typedef\,^\ast \\
   \mbox{(type definitions)} & \typedef &::=&
     \TYPE~\href{#types}{\functype} \\
   ~ \\
   \mbox{(import sections)} & \importsec &::=&
     \import^\ast \\
   \mbox{(imports)} & \import &::=&
     \IMPORT~\href{#strings}{\string}~\href{#strings}{\name}~\importdesc \\
   \mbox{(import descriptions)} & \importdesc &::=&
     \FUNC~\href{#indices}{\typeidx} ~|~ \\&&&
     \TABLE~\href{#types}{\tabletype} ~|~ \\&&&
     \MEMORY~\href{#types}{\memtype} ~|~ \\&&&
     \GLOBAL~\href{#types}{\globaltype} \\
   ~ \\
   \mbox{(export sections)} & \exportsec &::=&
     \export^\ast \\
   \mbox{(exports)} & \export &::=&
     \EXPORT~\href{#strings}{\name}~\exportdesc \\
   \mbox{(export descriptions)} & \exportdesc &::=&
     \FUNC~\href{#indices}{\funcidx} ~|~ \\&&&
     \TABLE~\href{#indices}{\tableidx} ~|~ \\&&& \MEMORY~\href{#indices}{\memidx} ~|~ \\&&&
     \GLOBAL~\href{#indices}{\globalidx} \\
   ~ \\
   \mbox{(function sections)} & \funcsec &::=&
     \funcdef\,^\ast \\
   \mbox{(function definitions)} & \funcdef &::=&
     \FUNC~\href{#indices}{\typeidx} \\
   ~ \\
   \mbox{(table sections)} & \tablesec &::=&
     \tabledef\,^\ast \\
   \mbox{(table definitions)} & \tabledef &::=&
     \TABLE~\href{#types}{\tabletype} \\
   ~ \\
   \mbox{(memory sections)} & \memsec &::=&
     \memdef\,^\ast \\
   \mbox{(memory definitions)} & \memdef &::=&
     \MEMORY~\href{#types}{\memtype} \\
   ~ \\
   \mbox{(global sections)} & \globalsec &::=&
     \globaldef\,^\ast \\
   \mbox{(global definitions)} & \globaldef &::=&
     \GLOBAL~\href{#types}{\globaltype}~\href{#expressions}{\expr} \\
   ~ \\
   \mbox{(code sections)} & \codesec &::=&
     \code^\ast \\
   \mbox{(code)} & \code &::=&
     \href{#types}{\valtype}^\ast~\href{#instructions}{\instr} \\
   ~ \\
   \mbox{(data sections)} & \datasec &::=&
     \dataseg^\ast \\
   \mbox{(data segments)} & \dataseg &::=&
     \DATA~\href{#expressions}{\expr}~\href{#numbers}{b}^\ast \\
   ~ \\
   \mbox{(element sections)} & \elemsec &::=&
     \elemseg^\ast \\
   \mbox{(element segments)} & \elemseg &::=&
     \ELEM~\href{#expressions}{\expr}~\href{#indices}{\funcidx}^\ast \\
   ~ \\
   \mbox{(start sections)} & \startsec &::=&
     \START~\href{#indices}{\funcidx} \\
   ~ \\
   \mbox{(custom sections)} & \customsec &::=&
     \CUSTOM~\href{#strings}{\name}~b^\ast \\
   \end{array}


Expressions
~~~~~~~~~~~

.. index::
   pair: grammar; expressions

.. math::
   \begin{array}{llll}
   \mbox{(expressions)} & \expr &::=&
     \href{#instructions}{\instr}^\ast~\END \\
   \end{array}


Instructions
~~~~~~~~~~~~

.. index::
   pair: grammar; instructions

.. math::
   \begin{array}{llll}
   \mbox{(width)} & \X{nn}, \X{mm} &::=&
     \K{32} ~|~ \K{64} \\
   \mbox{(signedness)} & \sx &::=&
     \K{u} ~|~ \K{s} \\
   \mbox{(alignment)} & \align &::=&
     \href{#numbers}{\uint32} \\
   \mbox{(offset)} & \offset &::=&
     \href{#numbers}{\uint32} \\
   \mbox{(memory operators)} & \memop &::=&
     \align~\offset \\
   \end{array}

.. math::
   \begin{array}{llll}
   \mbox{(instructions)} & \instr &::=&
     \K{unreachable} ~|~ \\&&&
     \K{nop} ~|~ \\&&&
     \K{block}~\href{#types}{\resulttype}~\instr^\ast~\END ~|~ \\&&&
     \K{loop}~\href{#types}{\resulttype}~\instr^\ast~\END ~|~ \\&&&
     \K{if}~\href{#types}{\resulttype}~\instr^\ast~\K{else}~\instr^\ast~\END ~|~ \\&&&
     \K{br}~\href{#indices}{\labelidx} ~|~ \\&&&
     \K{br\_if}~\href{#indices}{\labelidx} ~|~ \\&&&
     \K{br\_table}~\href{#indices}{\labelidx}^+ ~|~ \\&&&
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
     \K{i}\X{nn}\K{.const}~\sint_{\X{nn}} ~|~
     \K{f}\X{nn}\K{.const}~\float_{\X{nn}} ~|~ \\&&&
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
