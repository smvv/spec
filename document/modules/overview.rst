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
   \production{(type indices)} & \typeidx &::=& \uint32 \\
   \production{(function indices)} & \funcidx &::=& \uint32 \\
   \production{(table indices)} & \tableidx &::=& \uint32 \\
   \production{(memory indices)} & \memidx &::=& \uint32 \\
   \production{(global indices)} & \globalidx &::=& \uint32 \\
   \production{(local indices)} & \localidx &::=& \uint32 \\
   \production{(label indices)} & \labelidx &::=& \uint32 \\
   \end{array}
