Overview
--------

.. todo::

   Describe general structure of modules


Indices
~~~~~~~

Definitions in a module or function are referenced by index.
All indices are encoded as |uint32| numbers.

.. math::
   \begin{array}{llll}
   \production{(type indices)} & \typeindex &::=& \uint32 \\
   \production{(function indices)} & \funcindex &::=& \uint32 \\
   \production{(table indices)} & \tableindex &::=& \uint32 \\
   \production{(memory indices)} & \memindex &::=& \uint32 \\
   \production{(global indices)} & \globalindex &::=& \uint32 \\
   \production{(local indices)} & \localindex &::=& \uint32 \\
   \production{(label indices)} & \labelindex &::=& \uint32 \\
   \end{array}
