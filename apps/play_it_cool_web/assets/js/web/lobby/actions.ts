import { Dispatch } from 'redux';

import { CONNECT_TO_SOCKET } from './actionTypes';
import initSocket from '../../shared/socket';
import { ICreateLobbyResult } from './queries';

export const startSocket = (data: ICreateLobbyResult) => (
  dispatch: Dispatch
) => {
  initSocket(data.createLobby.lobbyToken);

  dispatch({
    type: CONNECT_TO_SOCKET,
    payload: data.createLobby.lobbyToken,
  });
};
