.import 'api-helper.js' as APIHelper;

const getVideoDataFromUrl = (url) => new Promise((resolve, reject) => {
    APIHelper.httpRequest(`https://www.youtube.com/oembed?format=json&url=${encodeURIComponent(url)}`, 'GET')
        .then(response => resolve(JSON.parse(response)))
        .catch(reject)
})