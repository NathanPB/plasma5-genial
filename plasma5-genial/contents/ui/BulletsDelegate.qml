import QtQuick 2.12

Rectangle {
    id: root

    property bool active: false
    property int interval: 0
    property int progress: 0

    signal clicked()

    width: active ? 13 : 10
    height: width

    color: "transparent"

    border.width: 2
    border.color: "grey"

    radius: width * 0.5

    MouseArea {
        anchors.fill: parent
        onClicked: parent.clicked()
    }

    Canvas {
        id: canvas

        anchors.fill: parent
        visible: parent.active
        property var ctx
        onAvailableChanged: if(available) ctx = getContext("2d")

        onPaint: {
            if(!ctx) return;
            ctx.reset();

            let centreX = width / 2;
            let centreY = height / 2;
            let paintedAngle =  (progress * Math.PI * 2) / 100

            ctx.beginPath();
            ctx.fillStyle = "grey";
            ctx.moveTo(centreX, centreY);
            ctx.arc(centreX, centreY, centreX, Math.PI + Math.PI / 2, paintedAngle + Math.PI + Math.PI / 2, false);
            ctx.lineTo(centreX, centreY);
            ctx.fill();
        }
    }

    Timer {
        running: root.active
        interval: 100
        repeat: true

        property int sumInterval: 0

        onTriggered: {
            if(sumInterval + interval > root.interval) {
                sumInterval = 0
            } else {
                sumInterval += interval
            }
            root.progress = (sumInterval * interval) / root.interval
            canvas.requestPaint();
        }
    }

    anchors.verticalCenter: parent.verticalCenter
}