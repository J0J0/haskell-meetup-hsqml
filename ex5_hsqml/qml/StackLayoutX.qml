import QtQuick.Layouts 1.3

StackLayout {
    function indexOf(item) {
        for(var i=0; i < count; i++) {
            if(item == itemAt(i)) {
                return i;
            }
        }
        return -1;
    }
}
