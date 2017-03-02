Values
------

Integers
~~~~~~~~

Different classes of integers with different value ranges are distinguished by their *size* and their *signedness*.
The following auxiliary syntactic classes are assumed:

.. math::
   \begin{array}{llll}
   \production{(unsigned integers)} & \uint_N &::=& 0 ~|~ 1 ~|~ \dots ~|~ 2^N{-}1 \\
   \production{(signed integers)} & \sint_N &::=& -2^{N-1} ~|~ \dots ~|~ {-}1 ~|~ 0 ~|~ 1 ~|~ \dots ~|~ 2^{N-1}{-}1 \\
   \end{array}

When dealing with numbers, the following conventions are adopted:

* The meta variables :math:`m, n, i, j, k` range over integral numbers where the class is clear from context.

* Numbers are sometimes denoted by simple arithmetics.


Binary Encoding
...............

All integral numbers are encoded using the `LEB128 <https://en.wikipedia.org/wiki/LEB128>`_ variable-length integer encoding, in either unsigned or signed variant.

* :math:`\uint_N`: unsigned integers are encoded in `unsigned LEB128 <https://en.wikipedia.org/wiki/LEB128#Unsigned_LEB128>`_ format.
  As an additional constraint, the total number of bytes encoding a value of type :math:`\uint_N` must not exceed :math:`\F{ceil}(N/7)` bytes.

  Formally:

  .. math::
     \begin{array}{lll@{\qquad\qquad}l}
     \encode{n}{\uint_N} &=& \byte(n) & (n < 128) \\
     \encode{m \cdot 128 + n}{\uint_N} &=& \byte(n+128)~\encode{m}{\uint_{N-7}} & (n < 128) \\
     \end{array}

  .. note::
     In the case of a value less than 128, both rules apply, allowing for optional padding bytes.

* :math:`\sint_N`: signed integers are encoded in `signed LEB128 <https://en.wikipedia.org/wiki/LEB128#Signed_LEB128>`_ format, which uses a 2's complement representation.
  As an additional constraint, the total number of bytes encoding a value of type :math:`\sint_N` must not exceed :math:`\F{ceil}(N/7)` bytes.

  Formally:

  .. math::
     \begin{array}{lll@{\qquad\qquad}l}
     \encode{n}{\sint_N} &=& \byte(n) & (0 \leq n < 64) \\
     \encode{-n}{\sint_N} &=& \byte(128-n) & (0 < n \leq 64) \\
     \encode{\pm m \cdot 128 + n}{\sint_N} &=& \byte(n+128)~\encode{\pm m}{\sint_{N-7}} & (n < 128) \\
     \end{array}

  .. note::
     In the case of a non-negative value less than 64, both the first and second rule apply, allowing for optional padding bytes.
     In the case of a negative value greater than or equal to -64, both the second and third rule apply, allowing for optional padding bytes.


Floating-point Numbers
~~~~~~~~~~~~~~~~~~~~~~

All floating point numbers are represented as binary values according to the `IEEE-754 <http://ieeexplore.ieee.org/document/4610935/>`_ standard.

.. math::
   \begin{array}{llll}
   \production{(floating-point numbers)} & \float_N &::=& b^{N/8} \\
   \end{array}

The two possible sizes for :math:`N` are 32 and 64.

When dealing with numbers, the following convention is adopted:

* The variable :math:`z` ranges over floating point values where the class is clear from context.


Binary Encoding
...............

Floating point values are encoded directly by their IEEE bit pattern in `little endian <https://en.wikipedia.org/wiki/Endianness#Little-endian>`_ byte order:

.. math::
   \begin{array}{lll@{\qquad\qquad}l}
   \encode{z}{\float_N} &=& z \\
   \end{array}


Vectors
~~~~~~~

*Vectors* are unterminated sequences of the form :math:`x^n` (or :math:`x^\ast` or :math:`x^?`),
where the :math:`x`-s can either be values or complex phrases.

Binary Encoding
...............

Vectors are encoded with their length followed by the sequence of their element encodings.

.. math::
   \begin{array}{lll@{\qquad\qquad}l}
   \encode{x^n}{t^\ast} &=& \encode{n}{\uint32}~(\encode{x}{t})^n \\
   \end{array}


Strings
~~~~~~~

*Strings* are uninterpreted vectors of bytes.

.. math::
   \begin{array}{llll}
   \production{(strings)} & \string &::=& b^\ast \\
   \end{array}

Binary Encoding
...............

.. math::
   \begin{array}{lll@{\qquad\qquad}l}
   \encode{s}{\string} &=& \encode{s}{b^\ast} \\
   \end{array}
