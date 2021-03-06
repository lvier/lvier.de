/*
 * Configuration for webpack.
 *
 * TODO Set mode dynamically.
 */

// noinspection JSAnnotator
const path = require('path');

module.exports = {
    entry: {
        main: './src/scripts/main.js',
        sermons: './src/scripts/sermons.js'
    },
    output: {
        filename: '[name].js',
        path: path.resolve(__dirname, 'dist/scripts')
    },
    mode: 'production'
};