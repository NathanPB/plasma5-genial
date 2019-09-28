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

    property string currentTrackId: internals.metadata['mpris:trackid'] || null
    property string currentAlbum:   internals.metadata['xesam:album']   || null
    property var currentArtist:     internals.metadata['xesam:artist']  || null
    property string currentTitle:   internals.metadata['xesam:title']   || null
    property string currentUrl:     internals.metadata['xesam:url']     || null

    signal trackIdChange(string trackId)
    signal albumChange(string album)
    signal artistChange(var artist)
    signal titleChange(string title)
    signal urlChange(url url)

    function refresh() {
        dataSource.currentDataChanged();
    }

    Item {
        id: internals
        property var cache: {}
        property var metadata: dataSource.currentData.Metadata || {};
    }

    PlasmaCore.DataSource {
        id: dataSource

        engine: "mpris2"

        readonly property var currentData: data["@multiplex"] || {}

        connectedSources: "@multiplex"

        onCurrentDataChanged: {
            const cache = internals.cache || {};
            const currentData = {
                trackId: root.currentTrackId,
                album: root.currentAlbum,
                artist: root.currentArtist,
                title: root.currentTitle,
                url: root.currentUrl
            };

            if(root.currentTrackId !== cache.trackId)
                root.trackIdChange(root.currentTrackId);

            if(root.currentAlbum !== cache.album)
                root.albumChange(root.currentAlbum);
            
            //JS hacks ftw
            if((root.currentArtist || []).sort().toString() !== (cache.artist || []).sort().toString())
                root.artistChange(root.currentArtist);

            if(root.currentTitle !== cache.title)
                root.titleChange(root.currentTitle);

            if(root.currentUrl !== cache.url)
                root.urlChange(root.currentUrl);

            internals.cache = currentData;
        }
    }

    Timer {
        running: true
        repeat: true
        onTriggered: {
            if(!root.currentTitle)
                root.refresh();
        }
    }
}