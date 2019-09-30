/*
Copyright (C) 2019 Nathan P. Bombana

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see https://www.gnu.org/licenses/.
*/

import QtQuick 2.0

Item {
    id: root
    property var descriptionArray: []
    property int currentIndex: 0
    property bool isEmpty: descriptionArray.length === 0

    signal triggered(string desc, int delay)

    Timer {
        id: theTimer
        running: !root.isEmpty
        repeat: true
        triggeredOnStart: true
        interval: Math.max((root.descriptionArray[root.currentIndex] || '').length * 75, 5000)

        onTriggered: {
            if(root.currentIndex+1 >= root.descriptionArray.length){
                root.currentIndex = 0;
            } else {
                root.currentIndex++;
            }

            if(!root.isEmpty)
                root.triggered(root.descriptionArray[root.currentIndex], theTimer.interval);
        }
    }


    function forceUpdate() {
        if(theTimer.running) theTimer.restart();   
    }

    function clear() {
        root.descriptionArray = [];
        root.currentIndex = 0;
    }
}