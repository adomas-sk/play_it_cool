import React from 'react';
import { Router as ReactRouter, Switch, Route, Redirect } from 'react-router-dom';
import { createBrowserHistory } from 'history';

import Lobby from './web/lobby/Lobby';
import Game from './web/game/Game';
import Initial from './web/initial/Initial';
import Layout from './components/Layout';

const history = createBrowserHistory({ basename: '/web' });

const Router = () => {
  return (
    <ReactRouter history={history}>
      <Switch>
        <Route exact path="/">
          <Layout>
            <Initial />
          </Layout>
        </Route>
        <Route exact path="/lobby">
          <Layout>
            <Lobby />
          </Layout>
        </Route>
        <Route exact path="/game/:lobbyToken">
          <Layout>
            <Game />
          </Layout>
        </Route>
        <Route path="/game">
          <Redirect to="/lobby" />
        </Route>
        <Route exact path="/login">
          Login
        </Route>
        <Route>NONO</Route>
      </Switch>
    </ReactRouter>
  );
};

export default Router;
