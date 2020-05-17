import { createStore, combineReducers, applyMiddleware, compose } from 'redux';
import thunk from 'redux-thunk';

import { reducer as lobbyReducer, ILobbyReducer } from '../web/lobby/reducer';
import { reducer as gameReducer, IGameReducer } from '../web/game/reducer';
import { reducer as rootReducer, IRootReducer } from '../web/initial/reducer';

export interface IRootStore {
  lobby: ILobbyReducer;
  game: IGameReducer;
  root: IRootReducer;
}

const reducer = combineReducers<IRootStore>({
  lobby: lobbyReducer,
  game: gameReducer,
  root: rootReducer,
});

const middleware = [applyMiddleware(thunk)];
if ((window as any).__REDUX_DEVTOOLS_EXTENSION__) {
  middleware.push((window as any).__REDUX_DEVTOOLS_EXTENSION__());
}

const store = createStore(reducer, {}, compose(...middleware));

export default store;
