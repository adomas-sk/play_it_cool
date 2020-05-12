import { Socket } from 'phoenix';

import store from './store';
import {
  UPDATE_LOBBY_STATE,
  UPDATE_LOBBY_PLAYERS,
  STORE_CHANNEL,
  RECEIVE_WORD,
} from '../web/game/actionTypes';
import { Player } from './interfaces';

export let socket: Socket;

const initSocket = (lobbyToken: number, successCallback?: () => void) => {
  socket = new Socket('/socket');
  // Finally, connect to the socket:
  socket.connect();

  // Now that you are connected, you can join channels with a topic:
  const channel = socket.channel(`lobby:${lobbyToken}`, {
    token: localStorage.getItem('channelToken'),
  });
  store.dispatch({ type: STORE_CHANNEL, payload: channel });
  channel
    .join()
    .receive('ok', (resp: { players: Player[]; lobbyMaster: number }) => {
      console.log('Joined lobby channel successfully');
      store.dispatch({ type: UPDATE_LOBBY_STATE, payload: resp });
      if (successCallback) {
        successCallback();
      }
    })
    .receive('error', (resp) => {
      console.log('Unable to join', resp);
    });
  channel.on('player_update', (message: { players: Player[] }) => {
    store.dispatch({ type: UPDATE_LOBBY_PLAYERS, payload: message.players });
  });

  return socket;
};

export let userSocket: Socket;

export const initializeUserSocket = () => {
  userSocket = new Socket('/socket');
  // Finally, connect to the socket:
  userSocket.connect();

  // Now that you are connected, you can join channels with a topic:
  const channel = userSocket.channel(
    `user:${localStorage.getItem('channelToken')}`,
    {
      token: localStorage.getItem('channelToken'),
    }
  );
  channel
    .join()
    .receive('ok', (_resp) => {
      console.log('Joined user channel successfully');
    })
    .receive('error', (resp) => {
      console.log('Unable to join', resp);
    });
  channel.on('word', (message: { word: string | null }) => {
    store.dispatch({ type: RECEIVE_WORD, payload: message.word });
  });

  return userSocket;
};

export default initSocket;
