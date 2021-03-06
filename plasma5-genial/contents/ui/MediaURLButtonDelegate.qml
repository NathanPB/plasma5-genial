import QtQuick 2.0
import org.kde.plasma.components 2.0 as PlasmaComponents

import '../code/media-helper.js' as MediaHelper

Item {
    id: root

    property string url: ''

    property string provider: MediaHelper.extractProviderFromUrl(url)

    property string image: ''
    property string title: ''
    property string author: ''

    onUrlChanged: {
        root.state = "LOADING"
        MediaHelper.getDataFromUrl(url)
            .then(data => {
                try {
                    data = MediaHelper.formatDataset(provider, data);
                    root.image = data.image
                    root.title = data.title
                    root.author = data.author
                    root.state = "DONE"
                } catch(ex) {
                    console.error(ex)
                    root.state = "ERROR"
                }
            })
            .catch(ex => {
                console.error(ex);
                root.state = "ERROR"
            })
    }

    height: Math.max(64, textColumn.height)
    width: parent.width

    Row {
        spacing: 4

        PlasmaComponents.BusyIndicator {
            visible: root.state === "LOADING"
            running: visible
        }

        PlasmaComponents.Label {
            text: "Not Available"
            font.pointSize: 12
            visible: root.state === "ERROR"
        }

        Image {
            id: image

            visible: root.state === "DONE"
            source: root.image
            sourceSize.height: parent.height
        }

        Column {
            id: textColumn

            visible: root.state === "DONE"
            height: titleLabel.height + authorLabel.height

            PlasmaComponents.Label {
                id: titleLabel

                text: root.title

                width: Math.min(root.width - image.width, paintedWidth) - 2
                height: paintedHeight
                wrapMode: Text.WordWrap
                font.bold: true
                font.pointSize: 12
            }

            PlasmaComponents.Label {
                id: authorLabel

                text: root.author
                height: paintedHeight
                font.pointSize: 8 + 2
                anchors.margins: 0
            }
        }

        anchors.margins: 2
        anchors.fill: parent
    }

    MouseArea {
        cursorShape: Qt.PointingHandCursor
        onClicked: Qt.openUrlExternally(url)
        anchors.fill: parent
    }
}