/**
 * Formats a raw metadata object from mpris2/xesam to a easier to work one.
 *
 * | key         | mpris2/xesam key  |
 * |-------------|-------------------|
 * | ``trackId`` | ``mpris:trackid`` |
 * | ``album``   | ``xesam:album``   |
 * | ``artist``  | ``xesam:artist``  |
 * | ``title``   | ``xesam:title``   |
 * | ``url``     | ``xesam:url``     |
 *
 * @param {object} metadata the metadata from mpris.
 * @returns {object} the formatted object.
 */
const formatDataset = (metadata) => ({
    trackId: metadata['mpris:trackid'],
    album: metadata['xesam:album'],
    artist: metadata['xesam:artist'],
    title: metadata['xesam:title'],
    url: metadata['xesam:url'],
});

/**
 * Compares two objects and finds differences between them.
 *
 * It only detect changes based in the [objectA] keys.
 * It also detects undefined or nullable values.
 *
 * @param {object} objectA The object to compare the keys
 * @param {object} objectB The object to be compared with
 * @returns {Array} the keys of [objectA] that changed or was not present in [objectB];
 */
const detectChanges = (objectA, objectB) => Object.keys(objectA)
    .map(key => new String(objectA[key]) === new String(objectB[key]) ? key : null)
    .filter(it => it !== null);