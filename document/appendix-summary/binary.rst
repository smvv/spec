Binary Encoding Summary
-----------------------

Numbers
~~~~~~~

.. math::
   \begin{array}{lll@{\qquad\qquad}l}
   \encode{n}{\uint_N} &=& \byte(n) & (n < 128) \\
   \encode{m \cdot 128 + n}{\uint_N} &=& \byte(n+128)~\encode{m}{\uint_{N-7}} & (n < 128 \wedge N > 7) \\
   ~ \\
   \encode{n}{\sint_N} &=& \byte(n) & (0 \leq n < 64) \\
   \encode{-n}{\sint_N} &=& \byte(128-n) & (0 < n \leq 64) \\
   \encode{\pm m \cdot 128 + n}{\sint_N} &=& \byte(n+128)~\encode{\pm m}{\sint_{N-7}} & (n < 128 \wedge N > 7) \\
   ~ \\
   \encode{z}{\float_N} &=& z \\
   \end{array}


Vectors
~~~~~~~

.. math::
   \begin{array}{lll@{\qquad\qquad}l}
   \encode{x^n}{t^\ast} &=& \encode{n}{\href{#numbers}{\uint32}}~(\encode{x}{t})^n \\
   ~ \\
   \encode{s}{\string} &=& \encode{s}{b^\ast} \\
   \end{array}


Types
~~~~~

.. math::
   \begin{array}{lll@{\qquad\qquad}l}
   \encode{\I32}{\valtype} &=& \hex{7F} \\
   \encode{\I64}{\valtype} &=& \hex{7E} \\
   \encode{\F32}{\valtype} &=& \hex{7D} \\
   \encode{\F64}{\valtype} &=& \hex{7C} \\
   ~\\
   \encode{t_1^\ast \to t_2^?}{\functype} &=& \hex{60}~\encode{t_1^\ast}{\href{#vectors}{\valtype^\ast}}~\encode{t_2^?}{\href{#vectors}{\valtype^\ast}} \\
   ~ \\
   \encode{\ANYFUNC}{\elemtype} &=& \hex{70} \\
   \encode{t[n~m^?]}{\tabletype} &=& \encode{t}{\elemtype}~\encode{n~m^?}{\limits} \\
   \encode{\PAGE[n~m^?]}{\memtype} &=& \encode{n~m^?}{\limits} \\
   ~ \\
   \encode{n}{\limits} &=& \hex{00}~\encode{n}{\href{#numbers}{\uint32}} \\
   \encode{n~m}{\limits} &=& \hex{01}~\encode{n}{\href{#numbers}{\uint32}}~\encode{m}{\href{#numbers}{\uint32}} \\
   ~ \\
   \encode{\MUT^?~t}{\globaltype} &=& \encode{t}{\valtype}~\encode{\MUT^?}{\mut} \\
   ~ \\
   \encode{\epsilon}{\mut} &=& \hex{00} \\
   \encode{\MUT}{\mut} &=& \hex{01} \\
   \end{array}


Modules
~~~~~~~

.. index::
   pair: binary encoding; modules

.. todo::
   Collect


Instructions
~~~~~~~~~~~~

.. index::
   pair: binary encoding; instructions

.. todo::
   Collect
