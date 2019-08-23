import QtQuick 2.0
import QtGraphicalEffects 1.12

Item {
    id: root
    property string source

    Image {
        id: img
        sourceSize: Qt.size(root.parent.width, root.parent.height)
        width: 256
        height: 256
        smooth: true
        visible: false
        source: root.source
    }

    FastBlur {
        id: blur
        anchors.fill: img
        source: img
        radius: 8

        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Item {
                width: img.width
                height: img.height
                Rectangle {
                    anchors.centerIn: parent
                    width: Math.min(img.width, img.height)
                    height: img.height
                    radius: 4
                }
            }
        }
    }
}   