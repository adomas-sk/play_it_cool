import { createStore, combineReducers, applyMiddleware, compose } from 'redux';
import thunk from 'redux-thunk';

import { reducer as webReducer } from '../web/lobby/reducer';

const rootReducer = combineReducers({
  web: webReducer,
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
