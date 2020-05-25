import React, { useEffect, useState } from 'react';
import { makeStyles } from '@material-ui/styles';
import { useDispatch } from 'react-redux';
import { useMutation } from '@apollo/react-hooks';
import { ITheme } from '../../shared/theme';
import Button from '../../components/Button';
import { CREATE_LOBBY, JOIN_LOBBY } from './queries';
import { SET_SELF_AS_OWNER_OF_LOBBY } from './actionTypes';
import { joinSocketChannel } from './actions';
import { useHistory } from 'react-router-dom';
import TextInput from '../../components/TextInput';

const useStyle = makeStyles((theme: ITheme) => ({
  lobbyContainer: {
    height: '100%',
    display: 'flex',
    flexDirection: 'column',
    justifyContent: 'center',
    alignItems: 'center',
  },
  divider: {
    width: '100%',
    height: 1,
    background: theme.palette.secondaryDark,
    margin: 24,
  },
}));

const Lobby: React.FC = () => {
  const [lobbyToken, setLobbyToken] = useState('');
  const [playerName, setPlayerName] = useState('');
  const classes = useStyle();
  const [createLobby, { data: createLobbyData }] = useMutation(CREATE_LOBBY);
  const [joinLobby, { data: joinLobbyData }] = useMutation(JOIN_LOBBY);
  const dispatch = useDispatch();
  const history = useHistory();

  useEffect(() => {
    if (createLobbyData) {
      const lobbyToken = createLobbyData.createLobby.lobbyToken;
      dispatch({ type: SET_SELF_AS_OWNER_OF_LOBBY });
      dispatch(
        joinSocketChannel(createLobbyData.createLobby, () => {
          history.push(`/game/${lobbyToken}`);
        })
      );
    } else if (joinLobbyData) {
      const lobbyToken = joinLobbyData.joinLobby.lobbyToken;
      localStorage.setItem('currentUsername', playerName);
      dispatch(
        joinSocketChannel(joinLobbyData.joinLobby, () => {
          history.push(`/game/${lobbyToken}`);
        })
      );
    }
  }, [createLobbyData, joinLobbyData]);

  return (
    <div className={classes.lobbyContainer}>
      <Button
        disabled={!localStorage.getItem('loginToken')}
        label="Create Lobby"
        onClick={() => createLobby()}
      />
      <div className={classes.divider} />
      <TextInput label="Lobby Token" onChange={setLobbyToken} message="Paste a valid lobby token" />
      <TextInput
        label="Player Name"
        onChange={setPlayerName}
        message="Name that you're going to use in the lobby you're joining"
      />
      <Button
        disabled={!RegExp(/^[0-9]{6}$/).test(lobbyToken) || !playerName.length}
        label="Join Lobby"
        onClick={() =>
          joinLobby({
            variables: {
              playerName,
              lobbyToken: Number.parseInt(lobbyToken),
            },
          })
        }
      />
    </div>
  );
};

export default Lobby;
