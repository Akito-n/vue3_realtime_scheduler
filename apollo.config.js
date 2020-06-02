require('dotenv').config()
const { GRAPHQL_BASE_URL } = process.env.GRAPHQL_BASE_URL

module.exports = {
  client: {
    service: {
      name: 'my-app',
      // URL to the GraphQL API
      url: GRAPHQL_BASE_URL
    },
    // Files processed by the extension
    includes: [
      'app/javascript/**/*.vue',
      'app/javascript/**/*.js',
      'app/javascript/**/*.ts'
    ]
  }
}
