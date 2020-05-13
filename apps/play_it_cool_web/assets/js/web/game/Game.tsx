import React, { useEffect, useState } from 'react';
import { useDispatch, useSelector } from 'react-redux';

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
import { IRootStore } from '../../shared/store';
import { SET_SELF_AS_OWNER_OF_LOBBY } from '../lobby/actionTypes';

const Game = () => {
  const { lobbyToken } = useParams();

  const history = useHistory();
  const [stage, setStage] = useState('init');
  const dispatch = useDispatch();

  const players = useSelector((state: IRootStore) => state.game.players) || [];
  const wordReceived = useSelector(
    (state: IRootStore) => state.game.wordReceived
  );
  const questioneer = useSelector(
    (state: IRootStore) => state.game.questioneer
  );

  const votingStarted = useSelector(
    (state: IRootStore) => state.game.votingStarted
  );
  const lobbyMaster = useSelector(
    (state: IRootStore) => state.game.lobbyMaster
  );

  useEffect(() => {
    if (lobbyMaster) {
      const currentUsername = localStorage.getItem('currentUsername');
      const player = players.find((p) => p.name === currentUsername);
      if (player && player.id === lobbyMaster) {
        dispatch({ type: SET_SELF_AS_OWNER_OF_LOBBY });
      }
    }
  }, [lobbyMaster]);

  useEffect(() => {
    if (votingStarted) {
      // setStage('voting');
    } else if (players.length && players.every((p) => p?.confirmed)) {
      setStage('questioning');
    } else if (questioneer) {
      setStage('questioning');
    } else if (wordReceived) {
      setStage('confirmation');
    }
  }, [players, votingStarted, questioneer, wordReceived]);

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
        return (
          <PlayerList
            lobbyToken={lobbyToken}
            nextStage={() => setStage('topic')}
          />
        );
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
