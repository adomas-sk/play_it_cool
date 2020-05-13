export const UPDATE_LOBBY_STATE = 'UPDATE_LOBBY_STATE';
export const UPDATE_LOBBY_PLAYERS = 'UPDATE_LOBBY_PLAYERS';
export const STORE_CHANNEL = 'STORE_CHANNEL';
export const START_GAME = 'START_GAME';
export const CONFIRM_WORD = 'CONFIRM_WORD';
export const RESET_LOBBY = 'RESET_LOBBY';
export const RECEIVE_WORD = 'RECEIVE_WORD';
export const START_VOTE = 'START_VOTE';
export const QUESTION_MARKED_AS_CONFIRMED = 'QUESTION_MARKED_AS_CONFIRMED';
export const VOTED = 'VOTED';
export const END_GAME = 'END_GAME';
export const SHOW_RESULTS = 'SHOW_RESULTS';
export const UPDATE_QUESTIONING = 'UPDATE_QUESTIONING';

export type GameReducerActions =
  | typeof UPDATE_LOBBY_STATE
  | typeof STORE_CHANNEL
  | typeof RESET_LOBBY
  | typeof RECEIVE_WORD
  | typeof QUESTION_MARKED_AS_CONFIRMED
  | typeof UPDATE_QUESTIONING
  | typeof START_VOTE
  | typeof VOTED
  | typeof END_GAME
  | typeof SHOW_RESULTS
  | typeof CONFIRM_WORD
  | typeof UPDATE_LOBBY_PLAYERS;
