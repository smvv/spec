Values
------

Integers
~~~~~~~~

All integer numbers are encoded using the `LEB128 <https://en.wikipedia.org/wiki/LEB128>`_ variable-length integer encoding, in either unsigned or signed variant.

Unsigned integers are encoded in `unsigned LEB128 <https://en.wikipedia.org/wiki/LEB128#Unsigned_LEB128>`_ format.
As an additional constraint, the total number of bytes encoding a value of type :math:`\uX{N}` must not exceed :math:`\F{ceil}(N/7)` bytes.

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
   \end{array}

.. note::
   In the case of a value less than 128, both rules apply, allowing for optional padding bytes.

Signed integers are encoded in `signed LEB128 <https://en.wikipedia.org/wiki/LEB128#Signed_LEB128>`_ format, which uses a 2's complement representation.
As an additional constraint, the total number of bytes encoding a value of type :math:`\sX{N}` must not exceed :math:`\F{ceil}(N/7)` bytes.

.. math::
   \encoding
   \begin{array}{lll@{\qquad\qquad}l}
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
   \end{array}

.. note::
   In the case of a non-negative value less than 64, both the first and second rule apply, allowing for optional padding bytes.
   In the case of a negative value greater than or equal to -64, both the second and third rule apply, allowing for optional padding bytes.

Uninterpreted integers are encoded as signed, assuming a 2's complement interpretation.

.. math::
   \encoding
   \begin{array}{lll@{\qquad\qquad}l}
   \encodex{n}{\iX{N}} &=&
     \encodex{n}{\sX{N}}
     & (-2^{N-1} \leq n < 2^{N-1}) \\
   \encodex{n}{\iX{N}} &=&
     \encodex{n-2^N}{\sX{N}}
     & (n \geq 2^{N-1}) \\
   \end{array}


Floating-point Numbers
~~~~~~~~~~~~~~~~~~~~~~

Floating point values are encoded directly by their IEEE bit pattern in `little endian <https://en.wikipedia.org/wiki/Endianness#Little-endian>`_ byte order:

.. math::
   \encoding
   \begin{array}{lll@{\qquad\qquad}l}
   \encodex{z}{\fX{N}} &=& z \\
   \end{array}


Vectors
~~~~~~~

Vectors are encoded with their length followed by the encoding of their element sequence.

.. math::
   \encoding
   \begin{array}{lll@{\qquad\qquad}l}
   \encodex{[x^n]}{\vec(\_)} &=&
     \encodex{n}{\href{#numbers}{\u32}}~
     \encode{x}^n \\
   \end{array}


Strings
~~~~~~~

Strings are encoded directly as a vector of bytes.

.. math::
   \encoding
   \begin{array}{lll@{\qquad\qquad}l}
   \encodex{[b^\ast]}{\string} &=&
     \encode{[b^\ast]} \\
   \encodex{s}{\name} &=&
     \encodex{s}{\string} \\
   \end{array}
