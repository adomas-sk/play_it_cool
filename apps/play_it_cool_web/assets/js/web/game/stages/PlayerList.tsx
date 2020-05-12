import React, { useEffect } from 'react';
import { Player } from '../../../shared/interfaces';
import { makeStyles } from '@material-ui/styles';
import { ITheme } from '../../../shared/theme';
import { useSelector, useDispatch } from 'react-redux';
import { IRootStore } from '../../../shared/store';
import Button from '../../../components/Button';
import List from '../../../components/List';
import { SET_SELF_AS_OWNER_OF_LOBBY } from '../../lobby/actionTypes';

const useStyle = makeStyles((theme: ITheme) => ({
  lobbyToken: {
    color: theme.palette.primary,
  },
  lobbyTokenStrong: {
    fontWeight: 'bold',

    '&:hover': {
      color: theme.palette.primaryLight,
      cursor: 'pointer',
      textDecoration: 'underline',
    },
  },
}));

interface PlayerListProps {
  lobbyToken: number;
  nextStage: () => void;
}

const PlayerList: React.FC<PlayerListProps> = ({ lobbyToken, nextStage }) => {
  const classes = useStyle();
  const isOwner = useSelector((state: IRootStore) => state.lobby.isOwner);
  const players = useSelector((state: IRootStore) => state.game.players) || [];
  const lobbyMaster = useSelector(
    (state: IRootStore) => state.game.lobbyMaster
  );
  const dispatch = useDispatch();

  useEffect(() => {
    if (lobbyMaster) {
      const currentUsername = localStorage.getItem('currentUsername');
      const player = players.find((p) => p.name === currentUsername);
      if (player && player.id === lobbyMaster) {
        dispatch({ type: SET_SELF_AS_OWNER_OF_LOBBY });
      }
    }
  }, [lobbyMaster]);

  return (
    <>
      {lobbyToken && (
        <div className={classes.lobbyToken}>
          Lobby Token:{' '}
          <strong className={classes.lobbyTokenStrong}>{lobbyToken}</strong>
        </div>
      )}
      <List
        loading={!players.length}
        itemList={players.map((player) => ({
          key: player.id,
          label: player.name,
        }))}
      />
      {isOwner && <Button label="Start Game" onClick={nextStage} />}
    </>
  );
};

export default PlayerList;
