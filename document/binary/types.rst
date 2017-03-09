Types
-----

Value Types
~~~~~~~~~~~

.. math::
   \encoding
   \begin{array}{lll@{\qquad\qquad}l}
   \encodex{\I32}{\valtype} &=& \hex{7F} \\
   \encodex{\I64}{\valtype} &=& \hex{7E} \\
   \encodex{\F32}{\valtype} &=& \hex{7D} \\
   \encodex{\F64}{\valtype} &=& \hex{7C} \\
   \end{array}

.. note::
   These bytes correspond to the encodings of small negative |sX{}| values.
   This scheme is so that types can coexist in a single space with (positive) indices into the type section, which may be relevant for future extensions
   Gaps in this scheme are also reserved for future extensions.


Result Types
~~~~~~~~~~~

.. math::
   \encoding
   \begin{array}{lll@{\qquad\qquad}l}
   \encodex{\epsilon}{\resulttype} &=&
     \hex{40} \\
   \encodex{t}{\resulttype} &=&
     \encodex{t}{\valtype} \\
   \end{array}


Function Types
~~~~~~~~~~~~~~

Function types are encoded by the byte :math:`\hex{60}` followed by the vector of parameter types and the vector of result types.

.. math::
   \encoding
   \begin{array}{lll@{\qquad\qquad}l}
   \encodex{t_1^\ast \to t_2^?}{\functype} &=&
     \hex{60}~
     \encode{[t_1^\ast]}~
     \encode{[t_2^?]} \\
   \end{array}

.. note::
   For future extensibility, the result is encoded as a vector.


Memory Types
~~~~~~~~~~~~

.. math::
   \encoding
   \begin{array}{lll@{\qquad\qquad}l}
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
   \end{array}


Table Types
~~~~~~~~~~~

.. math::
   \encoding
   \begin{array}{lll@{\qquad\qquad}l}
   \encodex{\limits~\elemtype}{\tabletype} &=&
     \encode{\elemtype}~
     \encode{\limits} \\
   \encodex{\ANYFUNC}{\elemtype} &=&
     \hex{70} \\
   \end{array}


Global Types
~~~~~~~~~~~~

.. math::
   \encoding
   \begin{array}{lll@{\qquad\qquad}l}
   \encodex{\mut~t}{\globaltype} &=&
     \encodex{t}{\valtype}~
     \encode{\mut} \\
   \encodex{\epsilon}{\mut} &=&
     \hex{00} \\
   \encodex{\MUT}{\mut} &=&
     \hex{01} \\
   \end{array}
