import QtQuick 2.0
import './api-helper.js' as ApiHelper;
import './utils.js' as Utils;

/* 
 * Type responsible for searching tracks on Genius.com and storing its data on himself.
 */
Item {
    id: root
    property string searchedTerm: ''
    property string trackTitle: ''
    property string albumCover: ''
    property var descriptionParagraphs: []
    property var media: []

    property bool loading: false

    signal error(var e)

    onError: {
        clear();
    }

    /*
     * The primary search function. Responsible for generating a search term and search for it, storing its data in the current object.
     * 
     * The search term has the format "{Track Title} {Artists sepparated by spaces}".
     * This function also writes the initial track title in the current object. May be overwritten later.
     *
     * @param title     string  The track title.
     * @param artists   array   The artists names. Default is an empty array.
     * @param apiKey    string  The Genius API access token. 
     */
    function search(title, artists, apiKey) {
        functionContainer.search(title, artists, apiKey);
    }

    /*
     * Searches a term on Genius API and stores its data in the current object.
     *
     * This function also sets the object as "loading" and writes the search term.
     *
     * @param term      string  The term to search on Genius API.
     * @param apiKey    string  The Genius API access token.
     */
    function searchTerm(term, apiKey) {
        functionContainer.searchTerm(term, apiKey);
    }

    /*
     * Fetches a track from the Genius API and store its data in the current object.
     *
     * @param trackId   string  The track ID to get the data.
     * @param apiKey    string  The Genius API access token.
     */
    function setTrack(trackId, apiKey) {
        functionContainer.setTrack(trackId, apiKey);
    }

    /*
     * Clears all the data stored in the current object.
     */
    function clear() {
        functionContainer.clear();
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
        id: functionContainer

        function search(title, artists, apiKey) {
            root.trackTitle = Utils.formatFriendlyTrackName(title, artists);
            functionContainer.searchTerm(Utils.formatSearchTrackName(title, artists), apiKey);
        }

        function searchTerm(term, apiKey) {
            root.searchedTerm = term;
            root.loading = true;
            ApiHelper.searchTrackId(term, apiKey)
                .then(track => {
                    if(track) {
                        root.setTrack(track, apiKey);
                    } else {
                        root.clear();
                    }
                }).catch(root.error);
        }

        function setTrack(trackId, apiKey) {
            root.loading = true;
            ApiHelper.searchTrackData(trackId, apiKey)
                .then((data) => {
                    root.trackTitle = data.full_title;
                    root.albumCover = data.header_image_url;
                    root.descriptionParagraphs = Utils.formatParagraphs(data.description.plain);
                    root.media = data.media;
                    root.loading = false;
                }).catch(root.error);
        }

        function clear() {
            root.searchedTerm = '';
            root.trackTitle = '';
            root.albumCover = '';
            root.descriptionParagraphs = [];
            root.media = [];
            root.loading = false;
        }
    }
}