import { CONNECT_TO_SOCKET } from './actionTypes';

export interface IAction {
  type: typeof CONNECT_TO_SOCKET;
  payload: any;
}

const initialState = {};

export const reducer = (state = initialState, { type, payload }: IAction) => {
  switch (type) {
    case CONNECT_TO_SOCKET:
      return { ...state, connection: payload };
    default:
      return state;
  }
};
