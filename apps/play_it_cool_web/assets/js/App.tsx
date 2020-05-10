import React from 'react';

import { ThemeProvider } from '@material-ui/styles';
import { Provider } from 'react-redux';

import theme from './shared/theme';
import store from './shared/store';
import Router from './Router';
import { ApolloProvider } from '@apollo/react-hooks';
import client from './shared/graphql';

const App: React.FC = () => {
  return (
    <ApolloProvider client={client}>
      <Provider store={store}>
        <ThemeProvider theme={theme}>
          <Router />
        </ThemeProvider>
      </Provider>
    </ApolloProvider>
  );
};

export default App;
