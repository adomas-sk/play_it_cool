import React, { useEffect, useState } from 'react';
import { useDispatch } from 'react-redux';

import Layout from '../../components/Layout';
import { useParams, useHistory } from 'react-router-dom';
import initSocket, { socket, initializeUserSocket } from '../../shared/socket';
import PlayerList from './stages/PlayerList';
import Button from '../../components/Button';
import TopicList from './stages/TopicList';
import Confirmation from './stages/Confirmation';
import { resetLobby } from './actions';
import Questioning from './stages/Questioning';
import Voting from './stages/Voting';
import Results from './stages/Results';

const Game = () => {
  const { lobbyToken } = useParams();

  const history = useHistory();
  const [stage, setStage] = useState('init');
  const dispatch = useDispatch();

  useEffect(() => {
    if (!socket || !socket.isConnected()) {
      initSocket(lobbyToken);
      initializeUserSocket();
    }
  }, [socket]);

  const handleGoingToLobby = () => {
    history.push('/lobby');
    dispatch(resetLobby());
    socket.disconnect();
  };

  const renderStages = () => {
    switch (stage) {
      case 'init':
        return <PlayerList lobbyToken={lobbyToken} changeStage={setStage} />;
      case 'topic':
        return <TopicList nextStage={() => setStage('confirmation')} />;
      case 'confirmation':
        return <Confirmation nextStage={() => setStage('questioning')} />;
      case 'questioning':
        return <Questioning nextStage={() => setStage('voting')} />;
      case 'voting':
        return <Voting nextStage={() => setStage('results')} />;
      case 'results':
        return <Results nextStage={() => setStage('init')} />;
      default:
        return <PlayerList lobbyToken={lobbyToken} changeStage={setStage} />;
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
