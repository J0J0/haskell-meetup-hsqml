import QtQml 2.0

Timer {
    property int count: 1
    property var callback
    repeat: true

    onTriggered: {
        count--
        if(count > 0) {
            callback.call()
        } else {
            running = false
        }
    }
}
