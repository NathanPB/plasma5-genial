const API_URL = "https://api.genius.com/";
const API_KEY = "not today babe";

const httpRequest = (url, method, headers) => new Promise((resolve, reject) => {
    if(!headers) headers = {};
    let request = new XMLHttpRequest();
    request.open(method, url, true);
    
    Object.keys(headers).forEach((key) => {
        request.setRequestHeader(key, headers[key]);
    })

    console.log(url);
    request.onreadystatechange = () => {
        if(request.readyState === XMLHttpRequest.DONE) {
            resolve(request);
        }
    }

    request.send(null);
});

const apiRequest = (endpoint) => httpRequest(`${API_URL}${endpoint}`, 'GET', {Authorization: `Bearer ${API_KEY}`});


const searchTrack = (searchTerm) => new Promise((resolve, reject) => {
    apiRequest(`search?q=${encodeURI(searchTerm)}`)
        .then(request => {
            let response = JSON.parse(request.response);
            let tracks = response.response.hits.filter(it => it.type === 'song');
            resolve(tracks.length > 0 ? tracks[0].result : undefined);
        })
});

const searchTrackDescriptions = (trackId) => new Promise((resolve) => {
    apiRequest(`songs/${trackId}?text_format=plain`)
        .then(request => {
            let response = JSON.parse(request.response);
            resolve(response.response.song.description.plain);
        })
})