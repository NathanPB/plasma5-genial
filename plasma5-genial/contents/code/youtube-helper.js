.import 'api-helper.js' as APIHelper;

const getVideoDataFromUrl = (url) => new Promise((resolve, reject) => {
    APIHelper.httpRequest(`https://www.youtube.com/oembed?format=json&url=${encodeURIComponent(url)}`, 'GET')
        .then(response => {
            try {
                resolve(JSON.parse(response))
            } catch(ex) {
                reject(ex)
            }
        })
        .catch(reject)
})