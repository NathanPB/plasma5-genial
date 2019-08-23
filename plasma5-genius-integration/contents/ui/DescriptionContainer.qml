import QtQuick 2.0

Item {
    id: root
    property string text

    width: 250
    height: 250

    Rectangle {
        radius: 8
        opacity: .7
        color: "#000000"

        width: 250
        height: 250
        anchors.verticalCenter: root.verticalCenter
        anchors.horizontalCenter: root.horizontalCenter
    }

    DescriptionText {
        id: descriptionText
        text: root.text
        anchors.verticalCenter: root.verticalCenter
        anchors.horizontalCenter: root.horizontalCenter
    }
}