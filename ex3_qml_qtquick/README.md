This example becomes visual -- finally! Using the QML
standard library `QtQuick` we can draw stuff onto the
screen. In the scope of (most) QtQuick objects we can
define as many children as we like (without explicitly
allocating any property name for them in the parent).
Instead, the hierachy gets build automatically in a
tree-like manner (but the latter is totally opaque to
the qml user).

To see this example in action, execute the follwing:
    qmlscene --resize-to-root ex3.qml
(The extra argument is necessary because otherwise the
root window's size won't update with changes to the size
of the 'main' rectangle in the qml code.)
