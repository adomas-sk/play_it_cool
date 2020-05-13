import {
  UPDATE_LOBBY_STATE,
  UPDATE_LOBBY_PLAYERS,
  STORE_CHANNEL,
  RECEIVE_WORD,
  GameReducerActions,
  RESET_LOBBY,
  UPDATE_QUESTIONING,
  START_VOTE,
  END_GAME,
  SHOW_RESULTS,
} from './actionTypes';
import { Player, Question, Score, Vote } from '../../shared/interfaces';
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
  votingStarted?: boolean;
  channel?: Channel;
  questioneer?: Player | null;
  answereer?: Player | null;
  question?: Question | null;
  words?: string[];
}

export const reducer = (
  state: IGameReducer = initialState,
  { type, payload }: IAction
): IGameReducer => {
  switch (type) {
    case SHOW_RESULTS:
      return {
        ...state,
        ...payload,
      };
    case END_GAME:
      return {
        ...state,
        wordReceived: false,
        votingStarted: false,
        questioneer: null,
        answereer: null,
        question: null,
        word: 'NONE',
        players: state.players?.map((p) => ({
          id: p.id,
          name: p.name,
          score: p.score,
          ready: p.ready,
        })),
      };
    case START_VOTE:
      return { ...state, votingStarted: true, words: payload };
    case UPDATE_QUESTIONING:
      return {
        ...state,
        questioneer: payload.questioneer,
        answereer: payload.answereer,
        question: payload.question,
      };
    case RESET_LOBBY:
      return initialState;
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
        questioneer: payload.questioneer,
        answereer: payload.answereer,
        question: payload.question,
        votingStarted: payload.votingStarted,
        words: payload.words,
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
