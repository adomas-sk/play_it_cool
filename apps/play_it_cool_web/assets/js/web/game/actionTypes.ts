export const UPDATE_LOBBY_STATE = 'UPDATE_LOBBY_STATE';
export const UPDATE_LOBBY_PLAYERS = 'UPDATE_LOBBY_PLAYERS';
export const STORE_CHANNEL = 'STORE_CHANNEL';
export const START_GAME = 'START_GAME';
export const RECEIVE_WORD = 'RECEIVE_WORD';

export type GameReducerActions =
  | typeof UPDATE_LOBBY_STATE
  | typeof STORE_CHANNEL
  | typeof RECEIVE_WORD
  | typeof UPDATE_LOBBY_PLAYERS;
