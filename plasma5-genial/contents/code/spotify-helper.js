.import 'api-helper.js' as APIHelper;

const getTrackDataFromUrl = (url) => new Promise((resolve, reject) => {
    APIHelper.httpRequest(url, 'GET')
        .then(responseText => {
            let htmlTitle = new RegExp('<title>(.+?), a song by (.+?)<\/title>').exec(responseText);
            let image = new RegExp('<meta property="og:image" content="(.+?)" \/>').exec(responseText);
            resolve({
                title: htmlTitle[1],
                author: htmlTitle[2],
                image: image[1]
            })
        })
        .catch(reject)
});