import { ApolloClient } from 'apollo-client'
import { createHttpLink } from 'apollo-link-http'
import { InMemoryCache } from 'apollo-cache-inmemory'
import { ApolloLink } from 'apollo-link'
import { setContext } from 'apollo-link-context'
import Rails from '@rails/ujs'

const { GRAPHQL_BASE_URL } = process.env

const httpLink = createHttpLink({
  uri: GRAPHQL_BASE_URL
})

const authLink = setContext(async (_, { headers }) => {
  return {
    headers: {
      ...headers,
      'X-CSRF-Token': Rails.csrfToken()
    }
  }
})

const cache = new InMemoryCache()

export const apolloClient = new ApolloClient({
  link: ApolloLink.from([authLink.concat(httpLink)]),
  cache
})
