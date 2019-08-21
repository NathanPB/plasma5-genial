import QtQuick 2.0
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import '../code/api-helper.js' as ApiHelper;

import '../code'

Item {

    Timer {
        repeat: true
        running: false
        onTriggered: {
            console.log(mediaWatcher.currentTitle);
        }
    }

    MediaWatcher {
        id: mediaWatcher

        onTitleChange: {
            console.log('new title received on main.qml', title);
            if(title){
                ApiHelper.searchTrack(`${title} ${(mediaWatcher.currentArtist || []).join(' ')}`)
                    .then(track => {
                        if(track) {
                        albumCover.source = track.header_image_url;
                        ApiHelper.searchTrackDescriptions(track.id)
                            .then(description => {
                                descriptionHolder.descriptionArray = description.split('\n\n');
                                descriptionHolder.forceUpdate();
                            });
                        }
                    })
            } else {
                descriptionHolder.clear();
                albumCover.source = '';
            }
        }
    }

    Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground

    width: 256
    height: 256

    AlbumCover {
        id: albumCover
    }

    DescriptionContainer {
        id: descriptionContainer
        text: descriptionHolder.isEmpty ? '' : descriptionHolder.descriptionArray[descriptionHolder.currentIndex]
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }    

    DescriptionHolder {
        id: descriptionHolder

        onTriggered: {
            progressBar.updateTo(delay)
        }
    }

    TimerProgressBar {
        id: progressBar

        running: !descriptionHolder.isEmpty
        opacity: descriptionHolder.isEmpty ? 0 : 1
    }
}