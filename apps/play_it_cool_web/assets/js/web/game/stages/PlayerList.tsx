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
    height: '100%',
    '@media screen and (max-width: 800px)': {
      fontSize: '1rem',
    },
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

  const renderButton = () => {
    if (!isOwner) {
      return null;
    }
    if (!players.every((p) => p.ready)) {
      return <Button label="Waiting for other players..." disabled />;
    }
    return <Button label="Start Game" onClick={() => nextStage()} />;
  };

  return (
    <>
      {lobbyToken && (
        <div className={classes.lobbyToken}>
          Lobby Token: <strong className={classes.lobbyTokenStrong}>{lobbyToken}</strong>
        </div>
      )}
      <List
        loading={!players.length}
        itemList={players.map((player) => ({
          key: player.id,
          label: player.name,
          right: player.score,
        }))}
      />
      {renderButton()}
    </>
  );
};

export default PlayerList;
