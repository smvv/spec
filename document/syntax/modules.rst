.. _syntax-module:

Modules
-------

WebAssembly programs are organized around *modules*,
which are the unit of deployment and compilation.
A module collects definitions for :ref:`types <syntax-type>`, :ref:`functions <syntax-func>`, :ref:`tables <syntax-table>`, :ref:`memories <syntax-mem>`, and :ref:`globals <syntax-global>`.
In addition, it can declare :ref:`imports <syntax-import>` and :ref:`exports <syntax-export>`
and provide initialization logic in the form of :ref:`data <syntax-data>` and :ref:`element <syntax-elem>` segments or a :ref:`start function <syntax-start>`.

.. index::
   pair: grammar; modules

.. math::
   \begin{array}{lllll}
   \production{modules} & \module &::=& \{ &
     \TYPES~\vec(\functype), \\&&&&
     \FUNCS~\vec(\func), \\&&&&
     \TABLES~\vec(\table), \\&&&&
     \MEMS~\vec(\mem), \\&&&&
     \GLOBALS~\vec(\global), \\&&&&
     \ELEM~\vec(\elemseg), \\&&&&
     \DATA~\vec(\dataseg), \\&&&&
     \START~\funcidx, \\&&&&
     \IMPORTS~\vec(\import), \\&&&&
     \EXPORTS~\vec(\export) \quad\} \\
   \end{array}


.. _syntax-idx:

Indices
~~~~~~~

Definitions are referenced with zero-based *indices*.
Each class of definition has its own *index space*, as distinguished by the following classes.

.. math::
   \begin{array}{llll}
   \production{type indices} & \typeidx &::=& \u32 \\
   \production{function indices} & \funcidx &::=& \u32 \\
   \production{table indices} & \tableidx &::=& \u32 \\
   \production{memory indices} & \memidx &::=& \u32 \\
   \production{global indices} & \globalidx &::=& \u32 \\
   \production{local indices} & \localidx &::=& \u32 \\
   \production{label indices} & \labelidx &::=& \u32 \\
   \end{array}

The index space for functions, tables, memories and globals includes respective imports declared in the same module.
The indices of these imports precede the indices of other definitions in the same index space.

The index space for locals is only accessible inside a function and includes the parameters and local variables of that function, which precede the other locals.

Label indices reference block instructions inside an instruction sequence.


Conventions
...........

* The meta variable :math:`l` ranges over label indices.

* The meta variable :math:`x` ranges over indices in any of the other index spaces.


.. _syntax-type:

Types
~~~~~

The |TYPES| component of a module defines a vector of :ref:`function types <syntax-functype>`.

All function types used in a module must be defined in the type section.
They are referenced by :ref:`type indices <syntax-idx>`.

.. note::
   Future versions of WebAssembly may add additional forms of type definitions.


.. _syntax-func:

Functions
~~~~~~~~~

The |FUNCS| component of a module defines a vector of *functions* defined as follows:

.. math::
   \begin{array}{llll}
   \production{functions} & \func &::=&
     \{ \TYPE~\typeidx, \LOCALS~\vec(\valtype), \BODY~\expr \} \\
   \end{array}

The |TYPE| of a function declares its signature by reference to a :ref:`type <syntax-type>` defined in the module.
The parameters of the function are referenced through 0-based :ref:`local indices <syntax-idx>` in the function's body.

The |LOCALS| declare a vector of mutable local variables and their types.
These variables are referenced through :ref:`local indices <syntax-idx>` in the function's body.
The index of the first local is the smallest index not referencing a parameter.

The |BODY| is an :ref:`instruction <syntax-expr>` sequence that must evaluate to a stack matching the function type's :ref:`result type <syntax-resulttype>`.


.. _syntax-table:

Tables
~~~~~~

The |TABLES| component of a module defines a vector of *tables* described by their :ref:`table type <syntax-tabletype>`:

.. math::
   \begin{array}{llll}
   \production{tables} & \table &::=&
     \{ \TYPE~\tabletype \} \\
   \end{array}

A table is a vector of opaque values of a particular table :ref:`element type <syntax-elemtype>`.
The initial size of each table is given by the |MIN| size specified in the :ref:`limits <syntax-limits>` of its table type.
Each table may be grown dynamically, but only up to its |MAX| size if specified.

Tables can be initialized through :ref:`element segments <syntax-elem>`.

Tables are referenced through :ref:`table indices <syntax-idx>`.
Most constructs implicitly reference table index :math:`0`.

.. note::
   Currently, at most one table may be defined or imported in a single module,
   and *all* constructs implicitly reference this table :math:`0`.
   This restriction may be lifted in future versions of WebAssembly.

   Tables can contain values that are not otherwise accessible --
   like host object references, raw OS handles, or native pointers --
   so that they can be accessed indirectly through an integer index.
   That bridges the gap between low-level, untrusted linear memory and high-level opaque handles or references.

   Currently, the primary purpose of tables is to emulate function pointers,
   which can be represented as integers indexing into a table of type |ANYFUNC|
   holding functions and can be called via the :math:`\K{call\_indirect}` instruction.


.. _syntax-mem:

Memories
~~~~~~~~

The |MEMS| component of a module defines a vector of *linear memories* as described by their :ref:`memory type <syntax-memtype>`:

.. math::
   \begin{array}{llll}
   \production{memories} & \mem &::=&
     \{ \TYPE~\memtype \} \\
   \end{array}

A memory is a vector of raw uninterpreted bytes.
The initial size of each memory is given by the |MIN| size specified in the `limit <limits>`_ of its table type.
Each memory may be grown dynamically in units of :ref:`page size <page-size>`, but only up to its |MAX| size if specified.

Memories can be initialized through :ref:`data segments <syntax-data>`, but are otherwise initialized with zero bytes.

Memories are referenced through :ref:`memory indices <syntax-idx>`.
Most constructs implicitly reference memory index :math:`0`.

.. note::
   Currently, at most one memory may be defined or imported in a single module,
   and *all* constructs implicitly reference this memory :math:`0`.
   This restriction may be lifted in future versions of WebAssembly.

   It is unspecified how embedders map this array into their process' own virtual memory.
   However, linear memory is sandboxed and does not alias other memory regions.


.. _syntax-global:

Globals
~~~~~~~

.. math::
   \begin{array}{llll}
   \production{globals} & \global &::=&
     \{ \TYPE~\globaltype, \INIT~\expr \} \\
   \production{expressions} & \expr &::=&
     \instr^\ast~\END \\
   \end{array}


.. _syntax-elem:

Element Segments
~~~~~~~~~~~~~~~~

.. math::
   \begin{array}{llll}
   \production{element segments} & \elemseg &::=&
     \{ \OFFSET~\expr, \INIT~\vec(\funcidx) \} \\
   \end{array}


.. _syntax-data:

Data Segments
~~~~~~~~~~~~~

.. math::
   \begin{array}{llll}
   \production{data segments} & \dataseg &::=&
     \{ \OFFSET~\expr, \INIT~\vec(\by) \} \\
   \end{array}


.. _syntax-start:

Start Function
~~~~~~~~~~~~~~


.. _syntax-export:

Exports
~~~~~~~

.. math::
   \begin{array}{llll}
   \production{exports} & \export &::=&
     \{ \NAME~\name, \DESC~\exportdesc \} \\
   \production{export descriptions} & \exportdesc &::=&
     \FUNC~\funcidx ~|~ \\&&&
     \TABLE~\tableidx ~|~ \\&&&
     \MEM~\memidx ~|~ \\&&&
     \GLOBAL~\globalidx \\
   \end{array}


.. _syntax-import:

Imports
~~~~~~~

.. math::
   \begin{array}{llll}
   \production{imports} & \import &::=&
     \{ \MODULE~\name, \NAME~\name, \DESC~\importdesc \} \\
   \production{import descriptions} & \importdesc &::=&
     \FUNC~\typeidx ~|~ \\&&&
     \TABLE~\tabletype ~|~ \\&&&
     \MEM~\memtype ~|~ \\&&&
     \GLOBAL~\globaltype \\
   \end{array}
