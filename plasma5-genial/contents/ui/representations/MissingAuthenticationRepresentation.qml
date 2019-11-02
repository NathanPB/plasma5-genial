/*
Copyright (C) 2019 Nathan P. Bombana

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see https://www.gnu.org/licenses/.
*/

import QtQuick.Controls 2.5
import org.kde.plasma.components 2.0 as PlasmaComponents

/*
 * Representation responsible for alerting the user that he is not logged in and show the login button.
 */
AppRepresentation {
    PlasmaComponents.Label {
        text: 'You are not logged in!'
        font.pointSize: 12
        font.bold: true

        anchors.horizontalCenter: parent.horizontalCenter
    }

    Button {
        text: 'Login with Genius'
        onClicked: authenticator.authenticate()
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
    }
}