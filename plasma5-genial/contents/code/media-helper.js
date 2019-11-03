.import 'youtube-helper.js' as YoutubeHelper
.import 'spotify-helper.js' as SpotifyHelper

const getProviderIcon = (provider) => {
    switch(provider) {
        case 'spotify': return 'spotify-client';
        case 'soundcloud': return 'soundcloud';
        case 'youtube': return 'youtube';
    }
}

const extractProviderFromUrl = (url) =>
    url.includes('soundcloud.com') ? 'soundcloud' :
    url.includes('spotify.com') ? 'spotify' :
    url.includes('youtube.com') || url.includes('youtu.be') ? 'youtube' :
    'UNKNOWN'

const reduceMediaToProviders = (mediaArray) => mediaArray.reduce((previous, current) => {
    if(current.provider in previous) {
        previous[current.provider].push(current.url);
    } else {
        previous[current.provider] = [current.url];
    }
    return previous;
}, {});

const formatDataset = (provider, dataset) => {
    switch(provider) {
        case 'youtube': return {
            image: dataset.thumbnail_url,
            title: dataset.title,
            author: dataset.author_name
        }
        case 'spotify': return dataset;
        default: throw `Provider '${provider}' not supported!`
    }
}

const getDataFromUrl = (url) => new Promise((resolve, reject) => {
    let provider = extractProviderFromUrl(url);
    let func;

    switch(provider) {
        case 'youtube': func = YoutubeHelper.getVideoDataFromUrl; break;
        case 'spotify': func = SpotifyHelper.getTrackDataFromUrl; break;
        default: reject(`Provier '${provider}' not supported!`)
    }

    if(func)
        func(url).then(resolve).catch(reject);
})