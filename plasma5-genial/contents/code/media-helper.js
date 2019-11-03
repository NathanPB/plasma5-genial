const getProviderIcon = (provider) => {
    switch(provider) {
        case 'spotify': return 'spotify-client';
        case 'soundcloud': return 'soundcloud';
        case 'youtube': return 'youtube';
    }
}

const reduceMediaToProviders = (mediaArray) => mediaArray.reduce((previous, current) => {
    if(current.provider in previous) {
        previous[current.provider].push(current.url);
    } else {
        previous[current.provider] = [current.url];
    }
    return previous;
}, {});