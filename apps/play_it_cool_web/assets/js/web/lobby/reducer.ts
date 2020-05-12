import { CONNECT_TO_SOCKET, SET_SELF_AS_OWNER_OF_LOBBY } from './actionTypes';
import { LobbyData } from './queries';

type LobbyReducerTypes =
  | typeof CONNECT_TO_SOCKET
  | typeof SET_SELF_AS_OWNER_OF_LOBBY;

export interface IAction {
  type: LobbyReducerTypes;
  payload: any;
}

const initialState = {
  isOwner: false,
};

export interface ILobbyReducer {
  initialLobby?: LobbyData;
  isOwner: boolean;
}

export const reducer = (
  state = initialState,
  { type, payload }: IAction
): ILobbyReducer => {
  switch (type) {
    case CONNECT_TO_SOCKET:
      return { ...state, initialLobby: payload };
    case SET_SELF_AS_OWNER_OF_LOBBY:
      return { ...state, isOwner: true };
    default:
      return state;
  }
};
