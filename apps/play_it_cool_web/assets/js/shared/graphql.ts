import ApolloClient from 'apollo-boost';
import { InMemoryCache } from 'apollo-cache-inmemory';

const client = new ApolloClient({
  uri: '/api/graphql',
  request: (operation) => {
    const token = localStorage.getItem('loginToken');
    operation.setContext({
      headers: {
        authorization: token ? `Bearer ${token}` : '',
      },
    });
  },
  cache: new InMemoryCache(),
});

export default client;
