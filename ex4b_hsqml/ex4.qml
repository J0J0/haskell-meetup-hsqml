import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import QtQuick.Dialogs 1.0

ApplicationWindow {
    visible: true
    width:  500
    height: 500

    minimumWidth: mainLayout.implicitWidth
    minimumHeight: 200

    menuBar: MenuBar {
        Menu {
            title: "&Datei"
            MenuItem {
                text: "Laden ..."
                onTriggered: fileDialogLoad.open()
            }
            MenuItem {
                text: "Speichern ..."
                onTriggered: fileDialogSave.open()
            }
            MenuItem {
                text: "Beenden"
                onTriggered: Qt.quit()
            }
        }
    }
    
    FileDialog {
        id: fileDialogLoad
        title: "Lade Datei ..."
        selectExisting: true

        onAccepted: {
            var path = purePath(fileUrl)
            if(path != null) {
                input.text = readTextFrom(path)
            }
        }
    }

    FileDialog {
        id: fileDialogSave
        title: "Wohin speichern?"
        selectExisting: false

        onAccepted: {
            var path = purePath(fileUrl)
            if(path != null) {
                writeTextTo(input.text, path)
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

        UniformWidthRow {
            Button {
                text: "löschen"
                onClicked: input.text = ""
            }
            Button {
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

        Button {
            Layout.fillWidth: true
            text: "ROT13"
            onClicked: input.text = rotateText(input.text)
        }
        
        CountTimer { id: timer }
    }

    function purePath(aUrl) {
        var s = aUrl.toString()
        if(s.startsWith("file://")) {
            return s.substring(7)
        } else {
            return null
        }
    }
}
