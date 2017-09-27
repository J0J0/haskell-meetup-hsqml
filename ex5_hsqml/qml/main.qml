import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.0
import HsQML.Model 1.0

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    minimumWidth: splitView.implicitWidth
    minimumHeight: 400
    
    title: "ex5"

    menuBar: MenuBar {
        Menu {
            title: "&File"
            MenuItem {
                text: "Quit"
                onTriggered: Qt.quit()
            }
        }
    }

    SplitView {
        id: splitView
        anchors.fill: parent
        orientation: Qt.Horizontal
        
        ToolBar {
            id: mainTools
            width: 200
            Layout.minimumWidth: 100
            
            ExclusiveGroup { id: modeSelectionGroup }
            ColumnLayout {
                width: parent.width
                
                StretchButton {
                    id: recipesModeButton
                    text: "Recipes"
                    checked: true
                    exclusiveGroup: modeSelectionGroup
                    onClicked: mainArea.currentIndex = mainArea.indexOf(recipesArea)
                }
                StretchButton {
                    id: testModeButton
                    text: "TEST"
                    exclusiveGroup: modeSelectionGroup
                    onClicked: mainArea.currentIndex = mainArea.indexOf(testingArea)
                }
            }
        }
        
        StackLayoutX {
            id: mainArea
            Layout.leftMargin: 6
            Layout.rightMargin: 5
            Layout.bottomMargin: 3
            
            ColumnLayout {
                id: recipesArea

                Label { text: "Elements from the selected categories will be shown below:" }
                
                TableView {
                    id: recipesCategories
                    Layout.fillWidth: true
                    selectionMode: SelectionMode.MultiSelection

                    /* The 'model' specifies how the TableView obtains its data.
                     * Here we use the 'AutoListModel' type that comes with HsQML
                     * to specify that we want to display stuff from the JavaScript
                     * array 'categoriesList' (which is in fact supplied by the
                     * haskell side of this application). The view will be updated
                     * automatically every time 'categoriesList' changes (visibly
                     * to QML). */
                     model: AutoListModel {
                         source: categoriesList  // provided by haskell backend
                     }
                    
                    TableViewColumn {
                        title: "Categories"
                        resizable: false
                    }
                    
                    Component.onCompleted: updateCategories()  // call to haskell backend
		    selection.onSelectionChanged: {
                        var sel = []
                        selection.forEach( function(k) { sel.push(k) } )
                        updateRecipes(sel)  // call to haskell backend
		    }
                }

                UniformWidthRow {
                    Button {
                        text: "Select all"
                        onClicked: recipesCategories.selection.selectAll()
                    }
                    Button {
                        text: "Select none"
                        onClicked: recipesCategories.selection.clear()
                    }
                }

                Item { height: 3 } // spacer
                
                Label { text: "Elements from selected categories:" }
                TableView {
                    id: recipesRecipes
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    
                    model: AutoListModel {
                        source: recipesList  // provided by haskell backend
                    }
                    
                    TableViewColumn {
                        title: "Elements"
                        resizable: false
                    }
                }
            }
            
            Label { id: testingArea; text: "TESTING" }
        }
    }
}
