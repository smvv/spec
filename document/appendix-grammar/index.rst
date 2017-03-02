Appendix: Grammar Summary
-------------------------

Numbers
~~~~~~~

.. math::
   \begin{array}{llll}
   \mbox{(unsigned integers)} & \uint_N &::=& 0 ~|~ 1 ~|~ \dots ~|~ 2^N{-}1 \\
   \mbox{(signed integers)} & \sint_N &::=& -2^{N-1} ~|~ \dots ~|~ {-}1 ~|~ 0 ~|~ 1 ~|~ \dots ~|~ 2^{N-1}{-}1 \\
   ~ \\
   \mbox{(floating-point numbers)} & \float_N &::=& b^{N/8} \\
   \end{array}


Types
~~~~~

.. math::
   \begin{array}{llll}
   \mbox{(value types)} & \valtype &::=& \i32 ~|~ \i64 ~|~ \f32 ~|~ \f64 \\
   \mbox{(result types)} & \resulttype &::=& \valtype^? \\
   \mbox{(function types)} & \functype &::=& \valtype^\ast \to \resulttype \\
   ~ \\
   \mbox{(table types)} & \tabletype &::=& \elemtype[\limits] \\
   \mbox{(memory types)} & \memtype &::=& [\limits] \\
   \mbox{(limits)} & \limits &::=& \uint32~\uint32^? \\
   \mbox{(element types)} & \elemtype &::=& \anyfunc \\
   ~ \\
   \mbox{(global types)} & \globaltype &::=& \mutability~\valtype \\
   \mbox{(mutability)} & \mutability &::=& \mut^? \\
   ~ \\
   \mbox{(external types)} & \externtype &::=& \func~\functype ~|~ \table~\tabletype ~|~ \\&&& \memory~\memtype ~|~ \global~\globaltype \\
   \end{array}


Indices
~~~~~~~

.. math::
   \begin{array}{llll}
   \mbox{(type indices)} & \typeindex &::=& \uint32 \\
   \mbox{(function indices)} & \funcindex &::=& \uint32 \\
   \mbox{(table indices)} & \tableindex &::=& \uint32 \\
   \mbox{(memory indices)} & \memindex &::=& \uint32 \\
   \mbox{(global indices)} & \globalindex &::=& \uint32 \\
   \mbox{(local indices)} & \localindex &::=& \uint32 \\
   \mbox{(label indices)} & \labelindex &::=& \uint32 \\
   \end{array}


Modules
~~~~~~~

.. index::
   pair: grammar; modules
