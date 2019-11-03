import QtQuick 2.0
import QtQuick.Controls 2.0
import '../code/media-helper.js' as MediaHelper

Button {
    id: root

    property string provider
    property var urls: []

    width: 24
    height: width

    icon.name: MediaHelper.getProviderIcon(provider)

    onClicked: comboBox.popup.visible = true

    ComboBox {
        id: comboBox

        visible: false
        model: urls

        onActivated: Qt.openUrlExternally(root.urls[index])
    }
}