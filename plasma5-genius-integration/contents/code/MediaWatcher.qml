import QtQuick 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    id: mpris2Source
    property var mprisSource: mpris2DataSource

    property var metadata: mpris2DataSource.currentData.Metadata || {};

    property string currentTrackId: metadata['mpris:trackid'] || null
    property string currentAlbum:   metadata['xesam:album']   || null
    property var currentArtist:     metadata['xesam:artist']  || null
    property string currentTitle:   metadata['xesam:title']   || null
    property string currentUrl:     metadata['xesam:url']     || null

    signal trackIdChange(string trackId)
    signal albumChange(string album)
    signal artistChange(var artist)
    signal titleChange(string title)
    signal urlChange(url url)

    Item {
        id: playerCache
        property var cache: {}
    }

    PlasmaCore.DataSource {
        id: mpris2DataSource

        engine: "mpris2"

        readonly property var currentData: data["@multiplex"] || {}

        connectedSources: "@multiplex"

        onCurrentDataChanged: {
            const cache = playerCache.cache || {};
            const currentData = {
                trackId: mpris2Source.currentTrackId,
                album: mpris2Source.currentAlbum,
                artist: mpris2Source.currentArtist,
                title: mpris2Source.currentTitle,
                url: mpris2Source.currentUrl
            };

            if(mpris2Source.currentTrackId !== cache.trackId)
                mpris2Source.trackIdChange(mpris2Source.currentTrackId);

            if(mpris2Source.currentAlbum !== cache.album)
                mpris2Source.albumChange(mpris2Source.currentAlbum);
            
            //JS hacks ftw
            if( (mpris2Source.currentArtist || []).sort().toString() !== (cache.artist || []).sort().toString())
                mpris2Source.artistChange(mpris2Source.currentArtist);

            if(mpris2Source.currentTitle !== cache.title)
                mpris2Source.titleChange(mpris2Source.currentTitle);

            if(mpris2Source.currentUrl !== cache.url)
                mpris2Source.urlChange(mpris2Source.currentUrl);

            playerCache.cache = currentData;
        }
    }

    Timer {
        running: true
        repeat: true
        onTriggered: {
            if(!mpris2Source.currentTitle) mpris2DataSource.currentDataChanged();
        }
    }
}