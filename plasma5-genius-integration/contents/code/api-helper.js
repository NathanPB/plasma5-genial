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


const searchTrack = (searchTerm, apiKey) => new Promise((resolve, reject) => {
    apiRequest(`search?q=${encodeURI(searchTerm)}`, apiKey)
        .then(response => {
            let tracks = response.hits.filter(it => it.type === 'song');
            resolve(tracks.length > 0 ? tracks[0].result : undefined);
        }).catch(reject);
});

const searchTrackDescriptions = (trackId, apiKey) => new Promise((resolve, reject) => {
    apiRequest(`songs/${trackId}?text_format=plain`, apiKey)
        .then(response => resolve(response.song.description.plain))
        .catch(reject);
})