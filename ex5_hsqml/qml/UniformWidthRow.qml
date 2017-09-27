import QtQuick 2.0
import QtQuick.Layouts 1.0

/* Provides a row "layout" type that distributes its availible width
 * uniformly amongst all children, taking their respective 'implicitWidth'
 * into account.
 * 
 * Warning: You should NOT modify the children property after completion
 * (because of established connections, bindings, ...). If you really must
 * ADD a child, be sure to call 'setupChild' on the new item -- otherwise
 * everything might break!
 * 
 * Note, however, that you may modify properties of child items,
 * in particular changes to the 'implicitWidth' should be handled
 * gracefully.
 */

RowLayout {
    property int uniformWidth

    Component.onCompleted: {
        onChildrenChanged.connect(updateUniformWidth)
        
        updateUniformWidth()
        for(var i = 0; i < children.length; ++i) {
            setupChild(children[i])
        }
    }

    function setupChild(child) {
        child.Layout.fillWidth = true
        child.Layout.preferredWidth = Qt.binding(getUniformWidth)
        child.onImplicitWidthChanged.connect(updateUniformWidth)
    }
    
    function updateUniformWidth() {
        if(children === null) return

        var i
        var w, max_w

        max_w = -1
        for(i = 0; i < children.length; ++i) {
            w = children[i].implicitWidth
            if(w > max_w) {
                max_w = w
            }
        }

        if(max_w != uniformWidth) {
            uniformWidth = max_w
        }
    }
    
    function getUniformWidth() {
        return uniformWidth
    }
}
