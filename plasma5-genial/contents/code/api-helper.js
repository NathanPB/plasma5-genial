/*
Copyright (C) 2019 Nathan P. Bombana

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see https://www.gnu.org/licenses/.
*/

const API_URL = "https://api.genius.com/";

const httpRequest = (url, method, headers) => new Promise((resolve, reject) => {
    if(!headers) headers = {};
    let request = new XMLHttpRequest();
    request.open(method, url, true);
    
    Object.keys(headers).forEach((key) => {
        request.setRequestHeader(key, headers[key]);
    })

    request.onreadystatechange = () => {
        if(request.readyState === XMLHttpRequest.DONE) {
            resolve(request.response);
        }
    }

    request.send(null);
});

const apiRequest = (endpoint, apiKey) => new Promise((resolve, reject) => {
    httpRequest(`${API_URL}${endpoint}`, 'GET', {Authorization: `Bearer ${apiKey}`})
        .then(textResponse => {
            let response = JSON.parse(textResponse);
            if(response.meta) {
                if(response.response && response.meta.status === 200) {
                    resolve(response.response);
                } else {
                    reject(response.meta);
                }
            } else {
                reject(response);
            }
        }).catch(reject);
})

/*
 * Searches a term on Genius API and return the ID of the track, if found.
 * 
 * @param searchTerm    string  The term to search for.
 * @param apiKey        string  The Genius API access token.
 * @returns string      The ID of the first song found. Undefined if nothing is found.
 * @throws              Errors during the HTTP request or the response meta from Genius if the response status code is not 200.
 */
const searchTrackId = (searchTerm, apiKey) => new Promise((resolve, reject) => {
    apiRequest(`search?q=${encodeURI(searchTerm)}`, apiKey)
        .then(response => {
            let tracks = response.hits.filter(it => it.type === 'song');
            resolve(tracks.length > 0 ? tracks[0].result.id : undefined);
        }).catch(reject);
});

/*
 * Fetches data from a song on Genius API with its ID.
 * 
 * @param trackId   string  The ID of the track to get the data.
 * @param apiKey    string  The Genius API access token.
 * @throws                  Errors during the HTTP request or the response meta from Genius if the response status code is not 200.
 */
const searchTrackData = (trackId, apiKey) => new Promise((resolve, reject) => {
    apiRequest(`songs/${trackId}?text_format=plain`, apiKey)
        .then(response => resolve(response.song))
        .catch(reject);
});