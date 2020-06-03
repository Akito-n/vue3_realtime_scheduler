module.exports = {
  client: {
    service: {
      name: 'my-app',
      // URL to the GraphQL API
      url: '/graphql'
    },
    // Files processed by the extension
    includes: [
      'app/javascript/**/*.vue',
      'app/javascript/**/*.js',
      'app/javascript/**/*.ts'
    ]
  }
}
