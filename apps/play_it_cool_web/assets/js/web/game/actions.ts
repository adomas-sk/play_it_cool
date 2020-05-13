import { Dispatch } from 'redux';
import {
  START_GAME,
  CONFIRM_WORD,
  RESET_LOBBY,
  QUESTION_MARKED_AS_CONFIRMED,
  VOTED,
  END_GAME,
} from './actionTypes';
import { Channel } from 'phoenix';
import { IRootStore } from '../../shared/store';

export const startGame = (topic: string, channel: Channel | undefined) => (
  dispatch: Dispatch
) => {
  if (!channel) {
    throw new Error('Channel is not defined in startGame call');
  }

  channel.push('start_game', { topic: topic });

  dispatch({ type: START_GAME });
};

export const confirmWord = () => (
  dispatch: Dispatch,
  getState: () => IRootStore
) => {
  const channel = getState().game.channel;
  if (!channel) {
    throw new Error('Channel is not defined in confirmWord call');
  }

  channel.push('confirmation', { token: localStorage.getItem('channelToken') });

  dispatch({ type: CONFIRM_WORD });
};

export const resetLobby = () => (dispatch: Dispatch) => {
  dispatch({
    type: RESET_LOBBY,
  });
};

export const markQuestionAsAnswered = (questionId: number) => (
  dispatch: Dispatch,
  getState: () => IRootStore
) => {
  const channel = getState().game.channel;
  if (!channel) {
    throw new Error('Channel is not defined in markQuestionAsAnswered call');
  }

  channel.push('answer', {
    token: localStorage.getItem('channelToken'),
    questionId,
  });

  dispatch({
    type: QUESTION_MARKED_AS_CONFIRMED,
  });
};

export const vote = (vote: string) => (
  dispatch: Dispatch,
  getState: () => IRootStore
) => {
  const channel = getState().game.channel;
  if (!channel) {
    throw new Error('Channel is not defined in markQuestionAsAnswered call');
  }

  channel.push('vote', {
    token: localStorage.getItem('channelToken'),
    vote,
  });

  dispatch({
    type: VOTED,
  });
};

export const ready = () => (dispatch: Dispatch, getState: () => IRootStore) => {
  const channel = getState().game.channel;
  if (!channel) {
    throw new Error('Channel is not defined in markQuestionAsAnswered call');
  }

  channel.push('ready', {
    token: localStorage.getItem('channelToken'),
  });

  dispatch({
    type: END_GAME,
  });
};
