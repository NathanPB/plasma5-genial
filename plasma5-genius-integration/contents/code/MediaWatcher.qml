import QtQuick 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    id: mpris2Source
    property var mprisSource: mpris2DataSource

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

        readonly property string multiplexSource: "@multiplex"
        property string current: multiplexSource

        readonly property var currentData: data[current]

        connectedSources: current

        onCurrentDataChanged: {
            const metadata = (mpris2DataSource.currentData || {}).Metadata || {}

            const newData = {
                trackId: metadata['mpris:trackid'],
                album: metadata['xesam:album'],
                artist: metadata['xesam:artist'],
                title: metadata['xesam:title'],
                url: metadata['xesam:url']
            };
            
            const cache = playerCache.cache || {};

            if(newData.trackId !== cache.trackId)
                mpris2Source.trackIdChange(newData.trackId);

            if(newData.album !== cache.album)
                mpris2Source.albumChange(newData.album);
            
            //JS hacks ftw
            if( (newData.artist || []).sort().toString() !== (cache.artist || []).sort().toString())
                mpris2Source.artistChange(newData.artist);

            if(newData.title !== cache.title)
                mpris2Source.titleChange(newData.title);

            if(newData.url !== cache.url)
                mpris2Source.urlChange(newData.url);

            playerCache.cache = newData;
        }
    }
}