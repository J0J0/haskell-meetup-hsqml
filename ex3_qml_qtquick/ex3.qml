import QtQuick 2.0

Rectangle {
    id: main
    width: 500
    height: 500
    color: "green"

    Rectangle {
        id: child
        width: 200
        height: main.height / 2   /* so called binding to 'main.height';
                                   * it will be autmomatically(!) re-evaluated
                                   * each time the 'main' rectangle's height is
                                   * changed. */
        // uses the default color (white)
    }

    Timer {
        running: true
        interval: 2000
        onTriggered: main.height = 800
    }

    MouseArea {
        anchors.fill: parent  /* make the clickable area the complete
                               * 'main' rectangle */
        onClicked: child.width = main.width
    }
}
