/*
Copyright (C) 2019 Nathan P. Bombana

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see https://www.gnu.org/licenses/.
*/

const URL_DETECT_REGEX = /((\w+:\/\/\S+)|(\w+[\.:]\w+\S+))[^\s,\.]/ig;

/*
 * Formats a raw Genius description string to an array of valid paragraphs ready to display.
 * 
 * This function explodes the longer paragraphs with an average of 256 characters each,
 * sepparating them with "...".
 * It also normalize and remove random URLs and trailing spaces from the text.
 * 
 * @param description   string  The description to format.
 * @returns array       The formmatted paragraphs.
 */
const formatParagraphs = (description) => {
    let descriptionArray = [];
    description.split('\n\n').forEach(paragraph => {
        if(paragraph.length > 3 && !paragraph.match(URL_DETECT_REGEX)) {
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

    return descriptionArray
        .map(it => it.replace('\n', '').normalize().trim());
}

/*
 * Formats a track title and artists to a user-friendly name.
 * It has the format "{Track Title} {Primary Artist} ft {Secondary Artists sepparated by commas}".
 * If the artists array is empty or undefined, its gonna return just the track title.
 * 
 * @param trackTitle    string  The track title.
 * @param artists       array   The array of artists to format. Default is an empty array.
 * @returns string      The formatted user-friendly track name and artists.
 */
const formatFriendlyTrackName = (trackTitle, artists) => {
    if(artists && artists.length > 0) {
        trackTitle = `${artists[0]} - ${trackTitle}`;
        
        if(artists.length > 1) {
            trackTitle += ` ft. ${artists.slice(1).join(', ')}`;
        }
    }

    return trackTitle;
}

/*
 * Formats a track title and artists to a search term, ready to be searched on Genius.com
 * It has the format "{Track Title} {Artists sepparated by spaces}".
 * If the artists array is empty or undefined, its gonna return just the track title.
 * 
 * @param title         string  The track title.
 * @param artists       array   The array of artists to format. Default is an empty array.
 * @returns string      The formatted search term. 
 */
const formatSearchTrackName = (title, artists) => `${title} ${(artists || []).join(' ')}`;