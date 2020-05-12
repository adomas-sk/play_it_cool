import React, { useEffect, useState } from 'react';
import { useSelector } from 'react-redux';

import Layout from '../../components/Layout';
import { IRootStore } from '../../shared/store';
import { useParams, useHistory } from 'react-router-dom';
import initSocket, { socket, initializeUserSocket } from '../../shared/socket';
import PlayerList from './stages/PlayerList';
import Button from '../../components/Button';
import TopicList from './stages/TopicList';
import Confirmation from './stages/Confirmation';

const Game = () => {
  const { lobbyToken } = useParams();

  const history = useHistory();
  const [stage, setStage] = useState('init');

  useEffect(() => {
    if (!socket || !socket.isConnected()) {
      initSocket(lobbyToken);
      initializeUserSocket();
    }
  }, [socket]);

  const handleGoingToLobby = () => {
    history.push('/lobby');
    socket.disconnect();
  };

  const renderStages = () => {
    switch (stage) {
      case 'init':
        return (
          <PlayerList
            lobbyToken={lobbyToken}
            nextStage={() => setStage('topic')}
          />
        );
      case 'confirmation':
        return <Confirmation nextStage={() => setStage('questioning')} />;
      case 'topic':
        return <TopicList nextStage={() => setStage('confirmation')} />;
      default:
        return (
          <PlayerList
            lobbyToken={lobbyToken}
            nextStage={() => setStage('topic')}
          />
        );
    }
  };

  return (
    <Layout>
      <Button label="Go to Lobby" onClick={handleGoingToLobby} />
      {renderStages()}
    </Layout>
  );
};

export default Game;
