Abstract Syntax
---------------

.. index:: !notation
.. index:: !abstract syntax

WebAssembly is defined in terms of an *abstract syntax*.


Grammar
~~~~~~~

The following conventions are adopted in defining grammar rules.

* Terminal symbols (atoms) are written in sans-serif: :math:`\K{i32}, \K{end}`.

* Nonterminal symbols are written in italic: :math:`\X{valtype}, \X{instr}`.

* :math:`x^n` is a sequence of :math:`n\geq 0` iterations  of :math:`x`.

* :math:`x^\ast` is a possibly empty sequence of iterations of :math:`x`.
  (This is a shorthand for :math:`x^n` used where :math:`n` is not relevant.)

* :math:`x^+` is a non-empty sequence of iterations of :math:`x`.
  (This is a shorthand for :math:`x^n` where :math:`n \geq 1`.)

* :math:`x^?` is an optional occurrence of :math:`x`.
  (This is a shorthand for :math:`x^n` where :math:`n \leq 1`.)

Each non-terminal defines a syntactic class.


Auxiliary Notation
~~~~~~~~~~~~~~~~~~

When dealing with syntactic constructs the following notation is also used:

* :math:`\epsilon` denotes the empty sequence.

* :math:`|s|` denotes the length of a sequence :math:`s`.

* :math:`s[i]` denotes the :math:`i`-th element of a sequence :math:`s`, starting from :math:`0`.


Semantic Objects
~~~~~~~~~~~~~~~~

For convenience, some objects of the semantic domain are also defined syntactically.
In particular, grammars of the following form define *records* that collect different semantic information:

.. math::
   \X{name} ~::=~ \{ \K{field}_1 = x_1, \K{field}_2 = x_2, \dots \}

The following notation is adopted for manipulating such records:

* :math:`r.\K{field}` denotes the :math:`\K{field}` component of :math:`r`.

* :math:`r,\K{field}\,s` denotes the same record as :math:`r` but with the sequence :math:`s` appended to its :math:`\K{field}` component.
