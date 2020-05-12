import {
  UPDATE_LOBBY_STATE,
  UPDATE_LOBBY_PLAYERS,
  STORE_CHANNEL,
  RECEIVE_WORD,
  GameReducerActions,
} from './actionTypes';
import { Player } from '../../shared/interfaces';
import { Channel } from 'phoenix';

export interface IAction {
  type: GameReducerActions;
  payload: any;
}

const initialState = {
  // players: [],
  word: 'NONE',
  wordReceived: false,
};

export interface IGameReducer {
  players?: Player[];
  word: string;
  lobbyMaster?: number;
  wordReceived: boolean;
  channel?: Channel;
}

export const reducer = (
  state = initialState,
  { type, payload }: IAction
): IGameReducer => {
  switch (type) {
    case RECEIVE_WORD:
      if (payload) {
        return { ...state, word: payload, wordReceived: true };
      }
      return { ...state, wordReceived: true };
    case STORE_CHANNEL:
      return { ...state, channel: payload };
    case UPDATE_LOBBY_STATE:
      return {
        ...state,
        players: payload.players,
        lobbyMaster: payload.lobbyMaster,
      };
    case UPDATE_LOBBY_PLAYERS:
      return {
        ...state,
        players: payload.players,
      };
    default:
      return state;
  }
};
