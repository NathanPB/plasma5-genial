/*
Copyright (C) 2019 Nathan P. Bombana

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see https://www.gnu.org/licenses/.
*/

import QtQuick 2.0
import '../'

/*
 * Representation responsible for showing the album cover and the description of the current track.
 * This representation also shows the "Nothing Found" message, that should be moved in the future (issue #7).
 */
AppRepresentation {
    property var progressBar: progressBar

    AlbumCover {
        id: albumCover
        source: trackDataContainer.albumCover
        width: 256
        height: 256
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }

    DescriptionContainer {
        id: descriptionContainer
        text: descriptionHolder.isEmpty ? '' : descriptionHolder.descriptionArray[descriptionHolder.currentIndex]
        trackTitle: trackDataContainer.trackTitle
        anchors.fill: parent


        TimerProgressBar {
            id: progressBar

            running: !descriptionHolder.isEmpty
            opacity: descriptionHolder.isEmpty ? 0 : 1
            anchors.fill: parent
        }
    }
}