/*
Copyright (C) 2019 Nathan P. Bombana

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see https://www.gnu.org/licenses/.
*/

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