The last example reloaded: it now features integration with 
the haskell world.

`Ex4_simple` provides the very basic QML loader from within
haskell (using HsQML). It only loads a qml file, providing no
interaction between haskell and qml. (This is much like the
`qmlscene` tool ...) Note, that the corresponding menu items
and button will call undefined functions, which gets logged
to the console but is otherwise ignored.

`Ex4` shows how to provide a so called *context object* to the
qml engine, a way of communication between haskell and QML:
It is any qml object whose properties and functions will get
exposed to the global scope of the specified qml document.
HsQML provides a number of ways to define such objects and
associate properties/functions, the most important of which
is probably `defMethod'` (see `Ex4.hs` ...).


Use `cabal` to compile these examples and then run the
executables from within the main directory (such that the qml
files will be found -- one way to make this more flexible is
shown in ex5 using cabal's *data-file* mechanism).
