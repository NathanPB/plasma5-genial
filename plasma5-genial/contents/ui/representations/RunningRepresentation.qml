/*
Copyright (C) 2019 Nathan P. Bombana

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see https://www.gnu.org/licenses/.
*/

import QtQuick 2.13
import QtQuick.Controls 2.13
import '../'

/*
 * Representation responsible for showing the album cover and the description of the current track.
 * This representation also shows the "Nothing Found" message, that should be moved in the future (issue #7).
 */
AppRepresentation {

    AlbumCover {
        id: albumCover
        source: trackDataContainer.albumCover

        anchors.fill: parent
    }

    DescriptionContainer {
        id: descriptionContainer
        text: descriptionHolder.isEmpty ? '' : descriptionHolder.descriptionArray[descriptionHolder.currentIndex]
        trackTitle: trackDataContainer.title
        anchors.fill: parent

        PageIndicator {

            interactive: true
            count: descriptionHolder.descriptionArray.length > 1 ? descriptionHolder.descriptionArray.length : 0
            currentIndex: descriptionHolder.currentIndex

            onCurrentIndexChanged: {
                if(descriptionHolder.currentIndex != currentIndex) {
                    descriptionHolder.currentIndex = currentIndex;
                    descriptionHolder.forceUpdate();
                }
            }

            delegate: BulletsDelegate {
                active: descriptionHolder.currentIndex === index
                interval: active ? descriptionHolder.interval : 0
            }

            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}