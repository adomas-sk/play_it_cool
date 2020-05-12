import { Dispatch } from 'redux';
import { START_GAME } from './actionTypes';
import { Channel } from 'phoenix';

export const startGame = (topic: string, channel: Channel | undefined) => (
  dispatch: Dispatch
) => {
  if (!channel) {
    throw new Error('Channel is not defined in startGame call');
  }

  channel.push('start_game', { topic: topic });

  dispatch({ type: START_GAME });
};
