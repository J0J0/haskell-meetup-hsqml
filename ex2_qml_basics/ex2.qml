import QtQml 2.0

QtObject {
    id: main
    property int value: 84 / 2
    property var child
    property var timer
    
    child: QtObject {
        Component.onCompleted: {
            //print("hello world " + value)  // or with explicit reference:
            print("hello world " + main.value) 

	    /* Note, however, that the first alternative easily leads to "name
	       shadowing" problems: if we later decide to give the child object
	       a property 'value' (for whatever reason), only the second line
	       would give the desired result (due to local scoping rules)! */
        }
    }

    timer: Timer {
        running: true
        repeat: true
        interval: 2000

        onTriggered: {
            main.value++
            print(main.value)
        }
    }
}

