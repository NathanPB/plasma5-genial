import QtQuick 2.0

Item {
    id: root
    property string text

    Rectangle {
        width: 250
        height: 250
        radius: 8
        opacity: .7
        color: "#000000"
        anchors.verticalCenter: descriptionText.verticalCenter
        anchors.horizontalCenter: descriptionText.horizontalCenter
    }

    DescriptionText {
        id: descriptionText
        text: root.text
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }
    

}