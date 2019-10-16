/*
Copyright (C) 2019 Nathan P. Bombana

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see https://www.gnu.org/licenses/.
*/

import QtQuick 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    id: root

    property string trackId: dataSource.metadata['mpris:trackid']
    property string album: dataSource.metadata['xesam:album']
    property var artists: dataSource.metadata['xesam:artist']
    property string title: dataSource.metadata['xesam:title']
    property string url: dataSource.metadata['xesam:url']

    PlasmaCore.DataSource {
        id: dataSource

        engine: "mpris2"

        readonly property var currentData: data["@multiplex"] || {}
        readonly property var metadata: dataSource.currentData.Metadata || {};

        connectedSources: "@multiplex"
    }
}