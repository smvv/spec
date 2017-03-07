Validation
----------

.. index:: !validation

Validation is described *declaratively* in terms of rules specifying constraints on phrases of abstract syntax.
These can be understood as typing rules.

For every construct, the validation rules are given in two equivalent forms:

1. In *prose*, describing the meaning in intuitive form.
2. In *formal notation*, describing the rule in mathematical form.

.. note::
   Understanding of the formal notation is *not* required to read this specification, but it provides an effective means of communication and is amenable to mathematical proof.


Contexts
~~~~~~~~

Validity of a definition is defined relative to a *context* :math:`C`, which collects relevant information about the surrounding module and other definitions:

* *Types*: the list of types defined in the current module.
* *Functions*: the list of functions declared in the current module, represented by their function type.
* *Table*: the optional table declared in the current module, represented by its table type.
* *Memory*: the optional memory declared in the current module, represented by its memory type.
* *Globals*: the list of globals declared in the current module, represented by their global type.
* *Locals*: the list of locals declared in the current function (including parameters), represented by their value type.
* *Labels*: the stack of labels accessible from the current position, represented by their result type.

Locals and labels are only used for validating function bodies, and are left empty elsewhere.
The label stack is the only part of the context that changes as validation of a function body proceeds.

Formally, a context can be defined as a record of the aforementioned components, described by the following grammar:

.. math::
   \begin{array}{llll}
   \mbox{(context)} & C &::=&
     \begin{array}[t]{l@{~}lll}
     \{ & \TYPES &=& \href{../basics/types.html#function-types}{\functype}^\ast, \\
        & \FUNCS &=& \href{../basics/types.html#function-types}{\functype}^\ast, \\
        & \TABLE &=& \href{../basics/types.html#table-types}{\tabletype}^?, \\
        & \MEMORY &=& \href{../basics/types.html#memory-types}{\memtype}^?, \\
        & \GLOBALS &=& \href{../basics/types.html#global-types}{\globaltype}^\ast, \\
        & \LOCALS &=& \href{../basics/types.html#value-types}{\valtype}^\ast, \\
        & \LABELS &=& \href{../basics/types.html#result-types}{\resulttype}^\ast ~\} \\
     \end{array}
   \end{array}


Formal Notation
~~~~~~~~~~~~~~~

.. note::
   This section gives a brief explanation of the notation for specifying typing rules formally.
   For the interested reader, a more thorough introduction can be found in respective text books. [#tapl]_

The proposition that a phrase :math:`x` has a type :math:`t` is written :math:`x : t`.
In general, however, typing is dependent on a context :math:`C`.
To express this, the complete form is a *judgement* :math:`C \vdash x : t`,
which says that :math:`x : t` holds under the assumptions encoded in :math:`C`.
In this document, the ":math:`C \vdash`" part is often omitted when :math:`C` either does not matter or is clear from context.

The typing rules use a standard approach for specifying formal type systems, rendering them into *deduction rules*.
Every rule has the following general form:

.. math::
   \frac{
     \X{premise}_1 \qquad \X{premise}_2 \qquad \dots \qquad \X{premise}_n
   }{
     \X{conclusion}
   }

Such a rule is read as a big implication: if all premises hold, then the conclusion holds.
Some rules have no premises; they are *axioms* whose conclusion holds unconditionally.

A judgement holds when there is a deduction rule with a matching conclusion for which all premises hold, recursively until only axioms are reached.

.. note::
   For example, consider the following rudimentary language of expressions over numbers and Booleans:

   .. math::
      \X{expr} ~~::=~~ \X{num} ~|~ \X{ident} ~|~ \X{expr} + \X{expr} ~|~ \X{expr} = \X{expr} ~|~ \K{if}~\X{expr}~\X{expr}~\X{expr}

   The typing rules for this language can be expressed as follows:

   .. math::
      \frac{
      }{
        C \vdash \X{num} : \K{Num}
      }
      \qquad
      \frac{
        C(\X{ident}) = t
      }{
        C \vdash \X{ident} : t
      }

   .. math::
      \frac{
        C \vdash \X{expr}_1 : \K{Num}
        \quad
        C \vdash \X{expr}_2 : \K{Num}
      }{
        C \vdash \X{expr}_1 + \X{expr}_2 : \K{Num}
      }
      \quad
      \frac{
        C \vdash \X{expr}_1 : t
        \quad
        C \vdash \X{expr}_2 : t
      }{
        C \vdash \X{expr}_1 = \X{expr}_2 : \K{Bool}
      }

   .. math::
      \frac{
        C \vdash \X{expr}_1 : \K{Bool}
        \qquad
        C \vdash \X{expr}_2 : t
        \qquad
        C \vdash \X{expr}_3 : t
      }{
        C \vdash \K{if}~\X{expr}_1~\X{expr}_2~\X{expr}_3 : t
      }

   There is one rule for each syntactic construct, defining the typing of that construct.
   The rule for numbers is an axiom.
   The rule for identifiers refers to the context :math:`C` to look up its type :math:`t`
   (in this type system, the context is simply a mapping from identifiers to types).
   The other rules have premises deducing the types of subexpressions.
   In the rule for addition, both their types must be :math:`\K{Num}`.
   In the rule for comparison, their type can be any :math:`t`, but must be the same :math:`t` for both operands.
   In the rule for the conditional, the first operand must be a Boolean, the others again can have any type but must be consistent.

   For example, the type of the expression ":math:`\K{if}~\F{x}~\F{y}~(\F{y} + 1)`" can be derived by recursively applying the typing rules.
   Under a context where :math:`C(\F{x}) = \K{Bool}` and :math:`C(\F{y}) = \K{Num}` they will deduce this expression to have type :math:`\K{Num}`.
   Under a context where, for example, :math:`C(\F{x}) = \K{Num}`, no such derivation exists, and the expression would be ill-typed.
   Similarly, if :math:`C(\F{x})` is not defined, that is, :math:`x` is unbound.


.. [#tapl]
   For example: Benjamin Pierce. `Types and Programming Languages <https://www.cis.upenn.edu/~bcpierce/tapl/>`_. The MIT Press 2002
