import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

ApplicationWindow {
    width:  500
    height: 500

    minimumWidth: mainLayout.implicitWidth
    minimumHeight: 200

    menuBar: MenuBar {
        Menu {
            title: "&Datei"
            MenuItem {
                text: "Quit"
                onTriggered: Qt.quit()
            }
        }
    }

    ColumnLayout {
        id: mainLayout
        anchors.fill: parent
        anchors.margins: 5  // some spacing to the main window's border

        TextArea {
            id: input
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: "Hallo Welt"
        }

        RowLayout {
            Button {
                id: b1
                Layout.fillWidth: true
                Layout.preferredWidth: Math.max(b1.implicitWidth,b2.implicitWidth)
                text: "löschen"
                onClicked: input.text = ""
            }
            Button {
                id: b2
                Layout.fillWidth: true
                Layout.preferredWidth: Math.max(b1.implicitWidth,b2.implicitWidth)
                text: "spam"
                onClicked: {
                    timer.interval = 100
                    timer.count = 50
                    timer.callback = (function(){
                        input.text += "lorem ipsum "
                    })
                    timer.start()
                }
            }
        }
        CountTimer { id: timer }
    }
}
