/*
Copyright (C) 2019 Nathan P. Bombana

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see https://www.gnu.org/licenses/.
*/

import QtQuick 2.0
import QtQuick.Controls 2.5

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

import '../code/api-helper.js' as ApiHelper;
import '../code/utils.js' as Utils;

import '../code'
import './representations'

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

        onTitleChanged: {
            nothingFoundRepresentation.term = Utils.formatFriendlyTrackName(title, artists);
            trackDataContainer.searchTerm = Utils.formatSearchTrackName(title, artists);
        }
    }

    TrackDataContainer {
        id: trackDataContainer
        apiKey: root.geniusToken

        onError: {
            if(error === "invalid_token" || error === 401 || (error.meta && error.meta.status === 401)) {
                root.geniusToken = '';
            } else {
                console.error(JSON.stringify(error));
            }
        }
    }

    DescriptionHolder {
        id: descriptionHolder
        descriptionArray: trackDataContainer.descriptionParagraphs
        onTriggered: runningRepresentation.progressBar.updateTo(delay)
    }

    RunningRepresentation {
        id: runningRepresentation
    }

    MissingAuthenticationRepresentation {
        id: missingAuthenticationRepresentation
    }

    NoPlayerRepresentation {
        id: noPlayerRepresentation
    }

    LoadingRepresentation {
        id: loadingRepresentation
    }

    NothingFoundRepresentation {
        id: nothingFoundRepresentation
    }

    states: [
        State {
            name: "RUNNING"
            when: geniusToken && !trackDataContainer.loading && !descriptionHolder.isEmpty
            PropertyChanges {
                target: root
                Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground
            }
            PropertyChanges {
                target: runningRepresentation
                opacity: 1
            }
        },
        State {
            name: "NOTHING_FOUND"
            when: geniusToken && !trackDataContainer.loading && descriptionHolder.isEmpty
            PropertyChanges {
                target: nothingFoundRepresentation
                opacity: 1
            }
        },
        State {
            name: "LOADING"
            when: trackDataContainer.loading && root.geniusToken
            PropertyChanges {
                target: loadingRepresentation
                opacity: 1
            }
        },
        State {
            name: "NO_PLAYER"
            when: !trackDataContainer.title && root.geniusToken
            PropertyChanges {
                target: noPlayerRepresentation
                opacity: 1
            }
        },
        State {
            name: "MISSING_AUTHENTICATION"
            when: !root.geniusToken
            PropertyChanges {
                target: missingAuthenticationRepresentation
                opacity: 1
            }
        }
    ]
}
