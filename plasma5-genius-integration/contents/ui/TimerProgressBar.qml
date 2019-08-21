import QtQuick 2.0
import QtQuick.Controls 2.5

Item {
    id: root

    property bool running: false

    ProgressBar {
        id: progressBar
    }

    Timer {
        id: theTimer
        interval: 100
        repeat: true
        running: root.running

        onTriggered: {
            progressBar.value = progressBar.value + 100 > progressBar.to ? 0 : progressBar.value + 100;
        }
    }
    
    function updateTo(newValue) {
        progressBar.to = newValue;
        progressBar.value = 0;
    }
}