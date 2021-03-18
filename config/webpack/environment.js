const { environment } = require('@rails/webpacker')

// 引入jQuery 库
var webpack = require('webpack');
environment.plugins.append( 'Provide',
    new webpack.ProvidePlugin({
        $: 'jquery',
    })
)

module.exports = environment
