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