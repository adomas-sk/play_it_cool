import { LOGIN, RootReducerActions, REGISTER } from './actionTypes';
import { User } from '../../shared/interfaces';

export interface IAction {
  type: RootReducerActions;
  payload: any;
}

const initialState = {};

export interface IRootReducer {
  user?: User;
}

export const reducer = (state: IRootReducer = initialState, { type, payload }: IAction): IRootReducer => {
  switch (type) {
    case LOGIN:
      return { ...state, user: payload };
    case REGISTER:
      return { ...state, user: payload };
    default:
      return state;
  }
};
