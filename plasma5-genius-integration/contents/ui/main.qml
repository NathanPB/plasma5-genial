import QtQuick 2.0
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import QtQuick.Controls 2.5
import '../code/api-helper.js' as ApiHelper;

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
    }

    MediaWatcher {
        id: mediaWatcher

        onTitleChange: {
            if(title && root.geniusToken) {
                let artists = mediaWatcher.currentArtist;
                let trackTitle = title;
                if(artists.length > 0) {
                    trackTitle = `${artists[0]} - ${trackTitle}`;
                    
                    if(artists.length > 1) {
                        trackTitle += ` ft. ${artists.slice(1).join(', ')}`;
                    }
                }

                descriptionContainer.trackTitle = trackTitle;
                descriptionHolder.loading = true
                ApiHelper.searchTrack(`${title} ${(mediaWatcher.currentArtist || []).join(' ')}`, root.geniusToken)
                    .then(track => {
                        if(track) {
                        albumCover.source = track.header_image_url;
                        ApiHelper.searchTrackDescriptions(track.id, root.geniusToken)
                            .then(description => {
                                let descriptionArray = [];
                                description.split('\n\n').forEach(paragraph => {
                                    if(paragraph.length > 3) {
                                        if(paragraph.length <= 256) {
                                            descriptionArray.push(paragraph);
                                        } else {
                                            let appender = '';
                                            paragraph.split(" ").forEach(word => {
                                                if(appender.length > 256) {
                                                    descriptionArray.push(`${appender}...`);
                                                    appender = '';
                                                } else {
                                                    appender += ` ${word}`;
                                                }
                                            })
                                            if(appender.length <= 256) {
                                                descriptionArray.push(appender);
                                            }
                                        }
                                    }
                                });


                                descriptionHolder.descriptionArray = descriptionArray;
                                descriptionHolder.loading = false;
                                descriptionHolder.forceUpdate();
                            });
                        }
                    })
                    .catch(it => {
                        if(it.error === "invalid_token" || it === 401 || (it.meta && it.meta.status === 401)) {
                            root.geniusToken = '';
                        } else {
                            console.error(JSON.stringify(it));
                        }
                    });
            } else {
                descriptionHolder.clear();
                albumCover.source = '';
                descriptionContainer.trackTitle = '';
            }
        }
    }

    DescriptionHolder {
        id: descriptionHolder

        onTriggered: {
            progressBar.updateTo(delay)
        }
    }

    Item {
        id: runningRepresentation
        opacity: geniusToken && descriptionContainer.trackTitle && !descriptionHolder.loading ? 1 : 0

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
        opacity: !descriptionContainer.trackTitle && root.geniusToken ? 1 : 0
        text: 'No Player Detected'

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
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
        opacity: descriptionHolder.loading && root.geniusToken ? 1 : 0
        
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