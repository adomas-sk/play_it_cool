import React, { useEffect, useState } from 'react';
import { makeStyles } from '@material-ui/styles';
import { useDispatch } from 'react-redux';
import { useMutation } from '@apollo/react-hooks';
import { ITheme } from '../../shared/theme';
import Button from '../../components/Button';
import Layout from '../../components/Layout';
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

  const username = 'testuser';

  useEffect(() => {
    if (createLobbyData) {
      const lobbyToken = createLobbyData.createLobby.lobbyToken;
      localStorage.setItem('currentUsername', username);
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
    <Layout>
      <div className={classes.lobbyContainer}>
        <Button
          label="Create Lobby"
          onClick={() => createLobby({ variables: { id: '1', username } })}
        />
        <div className={classes.divider} />
        <TextInput label="Lobby Token" onChange={setLobbyToken} />
        <TextInput label="Player Name" onChange={setPlayerName} />
        <Button
          disabled={
            !RegExp(/^[0-9]{6}$/).test(lobbyToken) || !playerName.length
          }
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
    </Layout>
  );
};

export default Lobby;
