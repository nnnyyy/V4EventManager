const path = require('path')

module.exports = { 
  css: {
    loaderOptions: {
      scss:  {
        data: `@import "@/styles/_variables.scss";@import "@/styles/_globalStyles.scss";`
      }
    }
  },
  outputDir: path.resolve(__dirname, '../backend/public'),
  devServer: {
    proxy: 'http://localhost:2500'      
  },
  pages: {
    index: {
      entry: 'src/main.js',
      template: 'public/index.html',
      filename: 'index.html',
      title: 'v4 이벤트 관리기'
    }
  }
}