import QtQuick 2.0
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import QtQuick.Controls 2.5
import '../code/api-helper.js' as ApiHelper;
import '../code/utils.js' as Utils;

import '../code'

Item {
    id: root
    property string geniusToken: ''


    width: 256
    height: 256

    Authenticator {
        id: authenticator
        onSuccess: {
            root.geniusToken = token;
        }

        onFailed: {
            root.geniusToken = '';
        }
    }

    MediaWatcher {
        id: mediaWatcher

        onTitleChange: {
            if(title && root.geniusToken) {
                trackDataContainer.search(title, mediaWatcher.currentArtist, root.geniusToken);
            } else {
                trackDataContainer.clear();
            }
        }
    }

    TrackDataContainer {
        id: trackDataContainer

        onError: {
            if(error === "invalid_token" || error === 401 || (error.meta && error.meta.status === 401)) {
                root.geniusToken = '';
            } else {
                console.error(JSON.stringify(it));
            }
        }
    }

    DescriptionHolder {
        id: descriptionHolder
        descriptionArray: trackDataContainer.descriptionParagraphs

        onTriggered: {
            progressBar.updateTo(delay)
        }
    }

    Item {
        id: runningRepresentation
        opacity: geniusToken && trackDataContainer.trackTitle && !trackDataContainer.loading ? 1 : 0

        width: 256
        height: 256

        AlbumCover {
            id: albumCover
            source: trackDataContainer.albumCover
        }

        DescriptionContainer {
            id: descriptionContainer
            text: descriptionHolder.isEmpty ? '' : descriptionHolder.descriptionArray[descriptionHolder.currentIndex]
            trackTitle: trackDataContainer.trackTitle
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }    

        TimerProgressBar {
            id: progressBar

            running: !descriptionHolder.isEmpty
            opacity: descriptionHolder.isEmpty ? 0 : 1
        }
    }

    Item {
        id: missingAuthenticationRepresentation
        opacity: root.geniusToken ? 0 : 1
    
        DescriptionText {
            text: 'You are not logged in!\n'
        }

        Button {
            text: 'Login with Genius'
            onClicked: authenticator.authenticate()
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
        }

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.top: parent.top
    }

    DescriptionText {
        id: notRunningRepresentation
        opacity: !trackDataContainer.trackTitle && root.geniusToken ? 1 : 0
        text: 'No Player Detected'

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
    }

    Rectangle {
        id: loadingRepresentation
        width: 256
        height: 256
        radius: 8
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        opacity: trackDataContainer.loading && root.geniusToken ? 1 : 0
        
        AnimatedImage {
            id: loadingGif
            paused: loadingRepresentation.opacity === 0
            source: "../assets/loading.gif"
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
        }    
    }

    states: State {
        name: "RUNNING"
        when: runningRepresentation.opacity == 1
        PropertyChanges {
            target: root
            Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground
        }
    }
}