import QtQuick 2.0

Item {
    id: root
    property var descriptionArray: []
    property int currentIndex: 0
    property bool isEmpty: descriptionArray.length === 0

    signal triggered(string desc, int delay)

    Timer {
        id: theTimer
        running: !root.isEmpty
        repeat: true
        triggeredOnStart: true
        interval: Math.max((root.descriptionArray[root.currentIndex] || '').length * 75, 5000)

        onTriggered: {
            if(root.currentIndex+1 >= root.descriptionArray.length){
                root.currentIndex = 0;
            } else {
                root.currentIndex++;
            }

            if(!root.isEmpty)
                root.triggered(root.descriptionArray[root.currentIndex], theTimer.interval);
        }
    }


    function forceUpdate() {
        if(theTimer.running) theTimer.restart();   
    }

    function clear() {
        root.descriptionArray = [];
        root.currentIndex = 0;
    }
}