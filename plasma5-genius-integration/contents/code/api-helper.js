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
            resolve(request);
        }
    }

    request.send(null);
});

const apiRequest = (endpoint, apiKey) => new Promise((resolve, reject) => {
    httpRequest(`${API_URL}${endpoint}`, 'GET', {Authorization: `Bearer ${apiKey}`})
        .then(request => {
            let response = JSON.parse(request.response);
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