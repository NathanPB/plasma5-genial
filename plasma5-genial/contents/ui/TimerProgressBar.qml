/*
Copyright (C) 2019 Nathan P. Bombana

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see https://www.gnu.org/licenses/.
*/

import QtQuick 2.0
import QtQuick.Controls 2.5

Item {
    id: root

    property bool running: false
    property int targetValue: 0

    onTargetValueChanged: {
        progressBar.value = 0;
    }

    ProgressBar {
        id: progressBar

        to: root.targetValue

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 16 //hardcoded shit, must get rid of this
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
}