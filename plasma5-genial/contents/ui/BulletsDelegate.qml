import QtQuick 2.12

Rectangle {

    property bool active: false

    signal clicked()

    width: 10
    height: 10

    color: active ? border.color : "transparent"

    border.width: 2
    border.color: "grey"

    radius: width * 0.5

    MouseArea {
        anchors.fill: parent
        onClicked: parent.clicked()
    }
}