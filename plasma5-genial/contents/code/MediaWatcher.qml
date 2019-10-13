/*
Copyright (C) 2019 Nathan P. Bombana

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see https://www.gnu.org/licenses/.
*/

import QtQuick 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

import './mediawatcher-helper.js' as MediaWatcherHelper

Item {
    id: root

    property var dataset

    Component.onCompleted: {
        dataset = Qt.binding(() => {
            let newDataset = MediaWatcherHelper.formatDataset(dataSource.metadata);
            let changes = MediaWatcherHelper.detectChanges(newDataset, this.dataset || {});

            if(changes.length > 0) {
                root.datasetChange(newDataset, changes);
            }

            return newDataset;
        });
    }

    signal datasetChange(var dataset, var changedFields)

    PlasmaCore.DataSource {
        id: dataSource

        engine: "mpris2"

        readonly property var currentData: data["@multiplex"] || {}
        readonly property var metadata: dataSource.currentData.Metadata || {};

        connectedSources: "@multiplex"
    }
}