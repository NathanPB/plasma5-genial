import QtQuick 2.0

Item {
    id: containing_rect
    property string text

    Text {
        id: text_field
        anchors.top: parent.top
        anchors.left: parent.left

        height: parent.height
        width: parent.width
        text: parent.text
        wrapMode: Text.WordWrap
        font.bold: true
        font.pointSize: 12
        horizontalAlignment: Text.AlignHCenter
        color: "#FFFFFF"
    }

    Text {
        id: dummy_text
        text: parent.text
        visible: false
    }

    states: [
        State {
            name: "WIDE_TEXT"
            when: containing_rect.text.length > 20
            PropertyChanges {
                target: containing_rect
                width: 256
                height: text_field.paintedHeight
            }
        },
        State {
            name: "SHORT_TEXT"
            when: containing_rect.text.length <= 20
            PropertyChanges {
                target: containing_rect
                width: dummy_text.paintedWidth
                height: text_field.paintedHeight
            }
        }
    ]
}