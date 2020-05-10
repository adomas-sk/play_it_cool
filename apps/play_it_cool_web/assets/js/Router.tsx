import React from 'react';
import Lobby from './web/lobby/Lobby';
import { Router as ReactRouter, Switch, Route } from 'react-router-dom';
import { createBrowserHistory } from 'history';

const history = createBrowserHistory({ basename: '/web' });

const Router = () => {
  return (
    <ReactRouter history={history}>
      <Switch>
        <Route exact path="/">
          Hello
          <br />
          World
        </Route>
        <Route exact path="/lobby">
          <Lobby />
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
