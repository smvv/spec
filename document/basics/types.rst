Types
-----

Value Types
~~~~~~~~~~~

*Value types* classify the types of individual values.
They are defined by the following grammar:

.. math::
   \begin{array}{llll}
   \production{(value types)} & \valtype &::=& \i32 ~|~ \i64 ~|~ \f32 ~|~ \f64 \\
   \end{array}

The types |i32| and |i64| classify 32 and 64 bit integers, respectively.
Integers are not inherently signed or unsigned, their interpretation is determined by individual operations.

The types |f32| and |f64| classify 32 and 64 bit floating points, respectively.
They correspond to single and double precision floating point types as defined by the `IEEE-754 <http://ieeexplore.ieee.org/document/4610935/>`_ standard

The following convention is adopted:

* The meta variable :math:`t` ranges over value types where clear from context.

Binary Encoding
...............

.. math::
   \begin{array}{lll@{\qquad\qquad}l}
   \encode{\i32}{\valtype} &=& \hex{7F} \\
   \encode{\i64}{\valtype} &=& \hex{7E} \\
   \encode{\f32}{\valtype} &=& \hex{7D} \\
   \encode{\f64}{\valtype} &=& \hex{7C} \\
   \end{array}

.. note::
   These bytes correspond to the encodings of small negative |sint| values.
   This scheme is so that types can coexist in a single space with (positive) indices into the type section, which may be relevant for future extensions
   Gaps in this scheme are also reserved for future extensions.


Result Types
~~~~~~~~~~~

*Result types* classify the result values of functions or blocks.
They are defined by the following grammar:

.. math::
   \begin{array}{llll}
   \production{(result types)} & \resulttype &::=& \valtype^? \\
   \end{array}

.. note::
   In the current version of WebAssembly, at most one value is allowed as a result.
   However, this may be generalized to multiple values in future versions.


Function Types
~~~~~~~~~~~~~~

*Function types* classify the signature of functions.
They are defined by the following grammar:

.. math::
   \begin{array}{llll}
   \production{(function types)} & \functype &::=& \valtype^\ast \to \resulttype \\
   \end{array}


Binary Encoding
...............

Function types are encoded by the byte :math:`\hex{60}` followed by the vector of parameter types and the vector of result types.

.. math::
   \begin{array}{lll@{\qquad\qquad}l}
   \encode{t_1^\ast \to t_2^?}{\functype} &=& \hex{60}~\encode{t_1^\ast}{}~\encode{t_2^?}{} \\
   \end{array}


Table Types
~~~~~~~~~~~

*Table types* classify tables over elements classified by *element types*. 
They are defined by the following grammar:

.. math::
   \begin{array}{llll}
   \production{(table types)} & \tabletype &::=& \elemtype[\limits] \\
   \production{(element types)} & \elemtype &::=& \anyfunc \\
   \production{(limits)} & \limits &::=& \uint32~\uint32^? \\
   \end{array}

The limits constrain the minimum and optional maximum size of a table.
If no maximum is given, the table can grow to any size.

.. note::
   In future versions of WebAssembly, additional element types may be introduced.

Binary Encoding
...............

.. math::
   \begin{array}{lll@{\qquad\qquad}l}
   \encode{\anyfunc}{\elemtype} &=& \hex{70} \\
   \encode{t[n~m^?]}{\tabletype} &=& \encode{t}{\elemtype}~\encode{n~m^?}{\limits} \\
   ~ \\
   \encode{n}{\limits} &=& \hex{00}~\encode{n}{\uint32} \\
   \encode{n~m}{\limits} &=& \hex{01}~\encode{n}{\uint32}~\encode{m}{\uint32} \\
   \end{array}


Memory Types
~~~~~~~~~~~~

*Memory types* classify linear memories.
They are defined by the following grammar:

.. math::
   \begin{array}{llll}
   \production{(memory types)} & \memtype &::=& [\limits] \\
   \end{array}

Like tables, memories are constrained by limits for the minimum and optional maximum size.
Both are given in units of page size.

Binary Encoding
...............

.. math::
   \begin{array}{lll@{\qquad\qquad}l}
   \encode{[n~m^?]}{\memtype} &=& \encode{n~m^?}{\limits} \\
   \end{array}


Global Types
~~~~~~~~~~~~

*Global types* classify global variables and consist.
They are defined by the following grammar:

.. math::
   \begin{array}{llll}
   \production{(global types)} & \globaltype &::=& \mutability~\valtype \\
   \production{(mutability)} & \mutability &::=& \mut^? \\
   \end{array}

Binary Encoding
...............

.. math::
   \begin{array}{lll@{\qquad\qquad}l}
   \encode{\mut^?~t}{\globaltype} &=& \encode{t}{\valtype}~\encode{\mut^?}{\mutability} \\
   \encode{\epsilon}{\mutability} &=& \hex{00} \\
   \encode{\mut}{\mutability} &=& \hex{01} \\
   \end{array}


External Types
~~~~~~~~~~~~~~

*External types* classify imports and exports.
They are defined by the following grammar:

.. math::
   \begin{array}{llll}
   \production{(external types)} & \externtype &::=& \func~\functype ~|~ \table~\tabletype ~|~ \memory~\memtype ~|~ \glboal~\globaltype \\
   \end{array}
