/*
Copyright (C) 2019 Nathan P. Bombana

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see https://www.gnu.org/licenses/.
*/

import QtQuick 2.0
import './api-helper.js' as ApiHelper;
import './utils.js' as Utils;

/*
 * Type responsible for searching tracks on Genius.com and storing its data on himself.
 */
Item {
    id: root

    property string title: ''
    property string albumCover: ''
    property var descriptionParagraphs: []
    property var media: []

    /**
     * Searches a term on Genius API.
     */
    property string searchTerm

    /**
    * Searches a song on Genius API based in the song ID.
    */
    property string searchId

    /**
     * Indicates a search in proggress.
     */
    property bool loading: false

    /**
     * The Genius API key to use in the searches.
     */
    property string apiKey

    onApiKeyChanged: searchTermChanged()

    onSearchTermChanged: {
        console.log('searchTermChanged', searchTerm, apiKey)
        if(searchTerm && apiKey) {
            root.loading = true;
            ApiHelper.searchTrackId(searchTerm, root.apiKey)
                .then(track => {
                    if(track) {
                        root.searchId = track;
                    } else {
                        internals.clear();
                    }
                }).catch(root.error);
        } else {
            internals.clear();
        }
    }

    onSearchIdChanged: {
        root.loading = true;
        if(searchId && apiKey) {
            ApiHelper.searchTrackData(searchId, apiKey)
                .then((data) => {
                    root.albumCover = data.header_image_url;
                    root.descriptionParagraphs = Utils.formatParagraphs(data.description.plain);
                    root.media = data.media;
                    root.loading = false;
                    root.title = data.full_title
                    loading = false;
                }).catch(root.error);
        } else {
            internals.clear();
        }
    }

    /**
     * Indicates that an error happened while searching.
     */
    signal error(var e)

    onError: internals.clear()

    /*
     * Clears all the data stored in the current object.
     */
    function clear() {
        internals.clear();
    }

    /*
     * Just a container to the functions. The functions documentation are exactly the same as refeered
     * above.
     *
     * From [Qt docs](https://doc.qt.io/qt-5/qtqml-javascript-expressions.html):
     * ```The custom methods defined inline in a QML document are exposed to other objects,
     * and therefore inline functions on the root object in a QML component can be invoked
     * by callers outside the component.
     * If this is not desired, the method can be added to a non-root object or, preferably,
     * written in an external JavaScript file.```
     */
    Item {
        id: internals

        function clear() {
            root.title = '';
            root.albumCover = '';
            root.descriptionParagraphs = [];
            root.media = [];
            root.loading = false;
        }
    }
}