Appendix: Binary Encoding Summary
---------------------------------

Numbers
~~~~~~~

.. math::
   \begin{array}{lll@{\qquad\qquad}l}
   \encode{n}{\uint_N} &=& \byte(n) & (n < 128) \\
   \encode{m \cdot 128 + n}{\uint_N} &=& \byte(n+128)~\encode{m}{\uint_{N-7}} & (n < 128) \\
   ~ \\
   \encode{n}{\sint_N} &=& \byte(n) & (0 \leq n < 64) \\
   \encode{-n}{\sint_N} &=& \byte(128-n) & (0 < n \leq 64) \\
   \encode{\pm m \cdot 128 + n}{\sint_N} &=& \byte(n+128)~\encode{\pm m}{\sint_{N-7}} & (n < 128) \\
   ~ \\
   \encode{z}{\float_N} &=& z \\
   \end{array}


Types
~~~~~

.. math::
   \begin{array}{lll@{\qquad\qquad}l}
   \encode{\i32}{\valtype} &=& \F{7F} \\
   \encode{\i64}{\valtype} &=& \F{7E} \\
   \encode{\f32}{\valtype} &=& \F{7D} \\
   \encode{\f64}{\valtype} &=& \F{7C} \\
   ~\\
   \encode{t_1^\ast \to t_2^?}{\functype} &=& \F{60}~\encode{t_1^\ast}{}~\encode{t_2^?}{} \\
   ~ \\
   \encode{\anyfunc}{\elemtype} &=& \F{70} \\
   \encode{t[n~m^?]}{\tabletype} &=& \encode{t}{\elemtype}~\encode{n~m^?}{\limits} \\
   \encode{[n~m^?]}{\memtype} &=& \encode{n~m^?}{\limits} \\
   ~ \\
   \encode{n}{\limits} &=& \F{00}~\encode{n}{\uint32} \\
   \encode{n~m}{\limits} &=& \F{01}~\encode{n}{\uint32}~\encode{m}{\uint32} \\
   ~ \\
   \encode{\mut^?~t}{\globaltype} &=& \encode{t}{\valtype}~\encode{\mut^?}{\mutablility} \\
   ~ \\
   \encode{\epsilon}{\mutability} &=& \F{00} \\
   \encode{\mut}{\mutability} &=& \F{01} \\
   \end{array}


Modules
~~~~~~~

.. index::
   pair: binary encoding; modules
