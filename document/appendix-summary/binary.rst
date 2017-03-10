Binary Encoding Summary
-----------------------

Numbers
~~~~~~~

.. math::
   \encoding
   \begin{array}{lll@{\qquad\qquad}l}
   \encodex{n}{\uX{N}} &=&
     \byte(n)
     & (n < 128) \\
   \encodex{m \cdot 128 + n}{\uX{N}} &=&
     \byte(n+128)~
     \encodex{m}{\uX{N-7}}
     & (n < 128 \wedge N > 7) \\
   ~ \\
   \encodex{n}{\sX{N}} &=&
     \byte(n)
     & (0 \leq n < 64) \\
   \encodex{-n}{\sX{N}} &=&
     \byte(128-n)
     & (0 < n \leq 64) \\
   \encodex{\pm m \cdot 128 + n}{\sX{N}} &=&
     \byte(n+128)~
     \encodex{\pm m}{\sX{N-7}}
     & (n < 128 \wedge N > 7) \\
   ~ \\
   \encodex{n}{\iX{N}} &=&
     \encodex{n}{\sX{N}}
     & (-2^{N-1} \leq n < 2^{N-1}) \\
   \encodex{n}{\iX{N}} &=&
     \encodex{n-2^N}{\sX{N}}
     & (n \geq 2^{N-1}) \\
   ~ \\
   \encodex{z}{\fX{N}} &=&
     z \\
   \end{array}


Vectors
~~~~~~~

.. math::
   \encoding
   \begin{array}{lll@{\qquad\qquad}l}
   \encodex{[x^n]}{\vec(\_)} &=&
     \encodex{n}{\href{#numbers}{\u32}}~
     \encode{x}^n \\
   \end{array}


Strings
~~~~~~~

.. math::
   \encoding
   \begin{array}{lll@{\qquad\qquad}l}
   \encodex{[b^\ast]}{\string} &=&
     \encode{[b^\ast]} \\
   \encodex{s}{\name} &=&
     \encodex{s}{\string} \\
   \end{array}


Types
~~~~~

.. math::
   \encoding
   \begin{array}{lll@{\qquad\qquad}l}
   \encodex{\I32}{\valtype} &=& \hex{7F} \\
   \encodex{\I64}{\valtype} &=& \hex{7E} \\
   \encodex{\F32}{\valtype} &=& \hex{7D} \\
   \encodex{\F64}{\valtype} &=& \hex{7C} \\
   ~ \\
   \encodex{t_1^\ast \to t_2^?}{\functype} &=&
     \hex{60}~
     \encode{[t_1^\ast]}~
     \encode{[t_2^?]} \\
   ~ \\
   \encodex{\ANYFUNC}{\elemtype} &=&
     \hex{70} \\
   \encodex{\limits~\elemtype}{\tabletype} &=&
     \encode{\elemtype}~
     \encode{\limits} \\
   \encodex{\limits}{\memtype} &=&
     \encode{\limits} \\
   ~ \\
   \encodex{\{\MIN~n, \MAX~\epsilon\}}{\limits} &=&
     \hex{00}~
     \encodex{n}{\href{#numbers}{\u32}} \\
   \encodex{\{\MIN~n, \MAX~m\}}{\limits} &=&
     \hex{01}~
     \encodex{n}{\href{#numbers}{\u32}}~
     \encodex{m}{\href{#numbers}{\u32}} \\
   ~ \\
   \encodex{\mut~t}{\globaltype} &=&
     \encodex{t}{\valtype}~
     \encode{\mut} \\
   ~ \\
   \encodex{\epsilon}{\mut} &=&
     \hex{00} \\
   \encodex{\MUT}{\mut} &=&
     \hex{01} \\
   \end{array}


Modules
~~~~~~~

.. index::
   pair: binary encoding; modules

.. math::
   \encoding
   \begin{array}{llll}
   \encodex{m}{\module} &=&
     \encode{\customsec_1}^\ast~\\&&
     \encode{m.\TYPES}{\typesec}~
     \encode{\customsec_2}^\ast~\\&&
     \encodex{m.\IMPORTS}{\importsec}~
     \encode{\customsec_3}^\ast~\\&&
     \encodex{m.\FUNCS}{\funcsec}~
     \encode{\customsec_4}^\ast~\\&&
     \encodex{m.\TABLES}{\tablesec}~
     \encode{\customsec_5}^\ast~\\&&
     \encodex{m.\MEMS}{\memsec}~
     \encode{\customsec_6}^\ast~\\&&
     \encodex{m.\GLOBALS}{\globalsec}~
     \encode{\customsec_7}^\ast~\\&&
     \encodex{m.\EXPORTS}{\exportsec}~
     \encode{\customsec_8}^\ast~\\&&
     \encodex{m.\START}{\startsec}~
     \encode{\customsec_9}^\ast~\\&&
     \encodex{m.\ELEM}{\elemsec}~
     \encode{\customsec_{10}}^\ast~\\&&
     \encodex{m.\FUNCS}{\codesec}~
     \encode{\customsec_{11}}^\ast~\\&&
     \encodex{m.\DATA}{\datasec}~
     \encode{\customsec_{12}}^\ast \\
   \end{array}

.. math::
   \encoding
   \begin{array}{llll}
   \sec(b)(\epsilon) &=&
     \epsilon \\
   \sec(b)([\epsilon]) &=&
     \epsilon \\
   \sec(b)(x) &=&
     b~\encodex{|\encode{x}|}{\u32}~\encode{x} \\
   ~ \\
   \encodex{\href{#strings}{\name}~b^\ast}{\customsec} &=&
     \sec(\hex{00})(\name~b^\ast) \\
   \encodex{[\functype^\ast]}{\typesec} &=&
     \sec(\hex{01})([\href{#types}{\functype}^\ast]) \\
   \encodex{[\import^\ast]}{\importsec} &=&
     \sec(\hex{02})([\import^\ast]) \\
   \encodex{[\func^\ast]}{\funcsec} &=&
     \sec(\hex{03})([(\func.\TYPE)^\ast]) \\
   \encodex{[\tabletype^\ast]}{\tablesec} &=&
     \sec(\hex{04})([\href{#types}{\tabletype}^\ast]) \\
   \encodex{[\memtype^\ast]}{\memsec} &=&
     \sec(\hex{05})([\href{#types}{\memtype}^\ast]) \\
   \encodex{[\global^\ast]}{\globalsec} &=&
     \sec(\hex{06})([\global^\ast]) \\
   \encodex{[\export^\ast]}{\exportsec} &=&
     \sec(\hex{07})([\export^\ast]) \\
   \encodex{\funcidx^?}{\startsec} &=&
     \sec(\hex{08})(\funcidx^?) \\
   \encodex{[\elemseg^\ast]}{\elemsec} &=&
     \sec(\hex{09})([\elemseg^\ast]) \\
   \encodex{[\func^\ast]}{\codesec} &=&
     \sec(\hex{0A})([\func^\ast]) \\
   \encodex{[\dataseg^\ast]}{\datasec} &=&
     \sec(\hex{0B})([\dataseg^\ast]) \\
   ~ \\
   \encodex{g}{\global} &=&
     \encode{g.\TYPE}~
     \encode{g.\INIT} \\
   \encodex{\instr^\ast~\END}{\expr} &=&
     \encode{\href{#instructions}{\instr}}^\ast~
     \encode{\END} \\
   \encodex{f}{\func} &=&
     \encode{|\encodex{f}{\code}|}{\u32}~
     \encodex{f}{\code} \\
   \encodex{f}{\code} &=&
     \encodex{f.\LOCALS}{\locals}~
     \encode{f.\BODY} \\
   \encodex{[]}{\locals} &=&
     \epsilon \\
   \encodex{[t^n~t^\ast]}{\locals} &=&
     \~\encodex{[t^\ast]}{\locals} \\
   ~ \\
   \encodex{\X{seg}}{\dataseg} &=&
     \encode{\X{seg}.\OFFSET}~
     \encode{\X{seg}.\INIT} \\
   \encodex{\X{seg}}{\elemseg} &=&
     \encode{\X{seg}.\OFFSET}~
     \encode{\X{seg}.\INIT} \\
   ~ \\
   \encodex{\X{im}}{\import} &=&
      \encode{\X{im}.\MODULE}~
      \encode{\X{im}.\NAME}~
      \encode{\X{im}.\DESC} \\
   \encodex{\FUNC~\typeidx}{\importdesc} &=&
     \hex{00}~\encode{\href{#indices}{\typeidx}} \\
   \encodex{\TABLE~\tabletype}{\importdesc} &=&
     \hex{01}~\encode{\href{#types}{\tabletype}} \\
   \encodex{\MEMORY~\memtype}{\importdesc} &=&
     \hex{02}~\encode{\href{#types}{\memtype}} \\
   \encodex{\GLOBAL~\globaltype}{\importdesc} &=&
     \hex{03}~\encode{\href{#types}{\globaltype}} \\
   ~ \\
   \encodex{\X{ex}}{\export} &=&
      \encode{\X{ex}.\NAME}~
      \encode{\X{ex}.\DESC} \\
   \encodex{\FUNC~\typeidx}{\exportdesc} &=&
     \hex{00}~\encode{\href{#indices}{\funcidx}} \\
   \encodex{\TABLE~\tableidx}{\exportdesc} &=&
     \hex{01}~\encode{\href{#indices}{\tableidx}} \\
   \encodex{\MEMORY~\memidx}{\exportdesc} &=&
     \hex{02}~\encode{\href{#indices}{\memidx}} \\
   \encodex{\GLOBAL~\globalidx}{\exportdesc} &=&
     \hex{03}~\encode{\href{#indices}{\globalidx}} \\
   \end{array}


Instructions
~~~~~~~~~~~~

.. index::
   pair: binary encoding; instructions

.. todo::
   Collect
