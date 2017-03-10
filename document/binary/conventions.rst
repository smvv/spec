Conventions
-----------

.. index:: !binary format

Encoding
~~~~~~~~

The binary format for WebAssembly modules is defined by *encoding*
functions that map :ref:`abstract syntax <sec-abstract-syntax>` to sequences of raw bytes.
[#compression]_

Some syntactic phrases have multiple possible encodings.
For example, numbers may be encoded as if they had optional leading zeros.
Consequently, encoding functions are in fact defined to yield a (non-empty) *set* of possible byte sequences for each phrase.
Implementations of encoders producing WebAssembly binaries can pick any encoding contained in these sets.

.. [#compression]
   Additional encoding layers -- for example, introducing compression -- may be defined on top the basic representation defined here.
   However, such layers are outside the scope of the current specification.


Decoding
~~~~~~~~

The defined encoding functions are all invertible in the sense that every possible byte sequence is the encoding of at most one syntactic phrase.
Consequently, *decoding* is defined implicitly as the respective inverse function.

Where multiple encodings are possible, a decoder must accept all of them.
Conversely, a decoder must reject all inputs that are not a possible encoding for any phrase.


Notation
~~~~~~~~

The following notation is adopted in defining binary encoding functions.

* The meta variable :math:`b` is used to range over byte values.

* A hexadecimal constant like :math:`\hex{08}` or :math:`\hex{FF}` denotes the respective byte value as a singleton set.

* :math:`\byte(n)` denotes the byte value of the natural number :math:`n` (for :math:`0 \leq n < 256`).

* :math:`\encoding \encodex{x}{t}` denotes the set of encodings of :math:`x` of syntactic class :math:`t`.

  .. note::
     For example, :math:`\encoding \encodex{10}{\u8}` denotes the set of encodings of the |u8| value :math:`10`, which is :math:`\{\hex{0A},` :math:`\hex{8A}~\hex{00}\}`.

* The concatenation :math:`A~B` denotes the set of all encodings that are concatenations of an element from encoding :math:`A` with an element from encoding :math:`B`.

  .. note::
     For example, the concatenation :math:`\encoding \encodex{10}{\u8}~\encodex{13}{\u8}` yields the set :math:`\{\hex{0A}~\hex{0D},` :math:`\hex{0A}~\hex{8D}~\hex{00},` :math:`\hex{8A}~\hex{00}~\hex{0D},` :math:`\hex{8A}~\hex{00}~\hex{8D}~\hex{00}\}` of possible encodings.

* The definition of encoding functions is given in clause form:

  .. math::
     \encoding
     \begin{array}{lll@{\qquad}l}
     \encodex{x}{t} &=&
       \X{byte~sequence~encoding~x}
       & (\mbox{side condition}) \\
     \encodex{y}{t} &=&
       \X{byte~sequence~encoding~y}
       & (\mbox{side condition}) \\
     \end{array}

  The encoding for a single syntactic class :math:`t` may be defined by multiple clauses covering different cases.
  When clauses overlap, either is applicable,
  expressing multiple possible encodings.
  The result of the encoding function then is the union of all applicable clauses.

  .. note::
     For example, the encoding of |u8| values in length-bound `LEB128 <https://en.wikipedia.org/wiki/LEB128>`_ format could be given as follows:

     .. math::
        \encoding
        \begin{array}{lll@{\qquad}l}
        \encodex{n}{\u8} &=&
          \byte(n)
          & (n < 128) \\
        \encodex{m \cdot 128 + n}{\u8} &=&
          \byte(n+128)~
          \byte(m) \\
        \end{array}

     For values smaller than :math:`128`, both clauses apply, resulting in a set of two possible encodings as sampled in the previous note.
