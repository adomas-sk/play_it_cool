import React from 'react';
import {
  Router as ReactRouter,
  Switch,
  Route,
  Redirect,
} from 'react-router-dom';
import { createBrowserHistory } from 'history';

import Lobby from './web/lobby/Lobby';
import Game from './web/game/Game';
import Initial from './web/initial/Initial';

const history = createBrowserHistory({ basename: '/web' });

const Router = () => {
  return (
    <ReactRouter history={history}>
      <Switch>
        <Route exact path="/">
          <Initial />
        </Route>
        <Route exact path="/lobby">
          <Lobby />
        </Route>
        <Route exact path="/game/:lobbyToken">
          <Game />
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
