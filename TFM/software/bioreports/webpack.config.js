const path = require('path');

module.exports = [{
  entry: './src/index.js',
  output: {
    filename: 'bioreports.js',
    path: path.resolve(__dirname, 'dist')
  },
  mode:'development'
},
{
  entry: './src/server/server.ts',
  devtool: 'inline-source-map',
  module: {
    rules: [
      {
        test: /\.tsx?$/,
        use: 'ts-loader',
        exclude: /node_modules/
      }
    ]
  },
  resolve: {
    extensions: [ '.tsx', '.ts', '.js' ]
  },
  output: {
    filename: 'server.js',
    path: path.resolve(__dirname, 'dist')
  },
  mode:'development'
}];
