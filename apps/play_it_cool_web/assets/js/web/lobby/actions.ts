import { Dispatch } from 'redux';

import { CONNECT_TO_SOCKET } from './actionTypes';
import initSocket, { initializeUserSocket } from '../../shared/socket';
import { LobbyData } from './queries';

export const joinSocketChannel = (
  data: LobbyData,
  redirectOnSuccessCallback: () => void
) => (dispatch: Dispatch) => {
  localStorage.setItem('channelToken', data.lobbyAuthToken);
  initSocket(data.lobbyToken, redirectOnSuccessCallback);
  initializeUserSocket();

  dispatch({
    type: CONNECT_TO_SOCKET,
    payload: data,
  });
};
