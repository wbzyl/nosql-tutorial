exports.artists = {
    map: function (doc) {
        if (doc.type === 'album') {
            emit(doc.artist, null);
        }
    },
    reduce: function (keys, values, rereduce) {
        return true;
    }
};
