import { Socket } from 'phoenix';

export const socket = new Socket('/socket');

const initSocket = (lobbyToken: number) => {
  // Finally, connect to the socket:
  socket.connect();

  // Now that you are connected, you can join channels with a topic:
  const channel = socket.channel(`lobby:${lobbyToken}`, {});
  channel
    .join()
    .receive('ok', (resp) => {
      console.log('Joined successfully', resp);
    })
    .receive('error', (resp) => {
      console.log('Unable to join', resp);
    });

  return socket;
};

export default initSocket;
