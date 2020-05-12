import { createStore, combineReducers, applyMiddleware, compose } from 'redux';
import thunk from 'redux-thunk';

import { reducer as lobbyReducer, ILobbyReducer } from '../web/lobby/reducer';
import { reducer as gameReducer, IGameReducer } from '../web/game/reducer';

export interface IRootStore {
  lobby: ILobbyReducer;
  game: IGameReducer;
}

const rootReducer = combineReducers<IRootStore>({
  lobby: lobbyReducer,
  game: gameReducer,
});

const store = createStore(
  rootReducer,
  {},
  compose(
    applyMiddleware(thunk),
    (window as any).__REDUX_DEVTOOLS_EXTENSION__()
  )
);

export default store;
